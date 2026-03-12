// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

import "@openzeppelin/contracts-upgradeable/access/AccessControlUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/security/PausableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/security/ReentrancyGuardUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/token/ERC20/IERC20Upgradeable.sol";
import "@openzeppelin/contracts-upgradeable/token/ERC20/utils/SafeERC20Upgradeable.sol";

/**
 * @title ArtifactTreasury — The Bank
 * @author Artifact Virtual
 * @notice Holds ETH (for Copilot fiat bridge) and ARCx (ecosystem reserves).
 *         Authorized spends flow through COMPTROLLER_ROLE (Mach6 bridge wallet).
 *         Daily cap prevents runaway bridge spend.
 *         Gnosis Safe retains emergency override at all times.
 *
 * @dev Flow (normal):
 *      1. Mach6 bridge routes Copilot call
 *      2. Bridge calls authorizeSpend(recipient, ethAmount, ref)
 *      3. Contract checks daily cap, then transfers ETH
 *      4. SpendAuthorized event emitted — full audit trail
 *
 *      Flow (emergency):
 *      1. Treasury Safe calls emergencyWithdraw
 *      2. Bypasses daily cap — full admin control
 *
 * @custom:security-contact security@artifactvirtual.com
 * @custom:version 1.0.0
 * @custom:network Base L2 Mainnet (Chain ID: 8453)
 *
 * ROLES:
 *   DEFAULT_ADMIN_ROLE  — Treasury Safe (Gnosis). Full control.
 *   COMPTROLLER_ROLE    — Mach6 bridge hot wallet. Authorized spend within cap.
 *   UPGRADER_ROLE       — Ecosystem Safe. Contract upgrades.
 *   PAUSER_ROLE         — Treasury Safe. Emergency pause.
 */
contract ArtifactTreasury is
    Initializable,
    AccessControlUpgradeable,
    PausableUpgradeable,
    ReentrancyGuardUpgradeable,
    UUPSUpgradeable
{
    using SafeERC20Upgradeable for IERC20Upgradeable;

    // ── Roles ─────────────────────────────────────────────────────────────────
    bytes32 public constant COMPTROLLER_ROLE = keccak256("COMPTROLLER_ROLE");
    bytes32 public constant UPGRADER_ROLE    = keccak256("UPGRADER_ROLE");
    bytes32 public constant PAUSER_ROLE      = keccak256("PAUSER_ROLE");

    // ── Constants ─────────────────────────────────────────────────────────────
    /// @notice Initial daily ETH spend cap: 0.05 ETH (~$120 at current prices).
    uint256 public constant DAILY_CAP_INITIAL = 0.05 ether;

    // ── State ─────────────────────────────────────────────────────────────────
    /// @notice Current daily spend cap (ETH). Admin-adjustable.
    uint256 public dailyCap;

    /// @notice ETH spent today.
    uint256 public dailySpent;

    /// @notice Timestamp of last daily reset.
    uint256 public dailyResetAt;

    /// @notice Total ETH ever authorized through COMPTROLLER.
    uint256 public totalAuthorized;

    /// @notice Total ETH ever emergency-withdrawn by admin.
    uint256 public totalEmergencyWithdrawn;

    /// @notice Reference tracking (deduplication for bridge).
    mapping(bytes32 => bool) public spendRefs;

    // ── Storage gap ───────────────────────────────────────────────────────────
    uint256[50] private __gap;

    // ── Events ────────────────────────────────────────────────────────────────
    event SpendAuthorized(
        address indexed recipient,
        uint256 ethAmount,
        bytes32 indexed ref,
        uint256 dailySpentAfter,
        uint256 timestamp
    );
    event EmergencyWithdrawal(
        address indexed recipient,
        uint256 ethAmount,
        address indexed by,
        uint256 timestamp
    );
    event TokenWithdrawal(
        address indexed token,
        address indexed recipient,
        uint256 amount,
        address indexed by
    );
    event DailyCapUpdated(uint256 oldCap, uint256 newCap);
    event ETHReceived(address indexed from, uint256 amount);

    // ── Errors ────────────────────────────────────────────────────────────────
    error ZeroAddress();
    error ZeroAmount();
    error DailyCapExceeded(uint256 requested, uint256 remaining);
    error InsufficientBalance(uint256 have, uint256 need);
    error DuplicateRef(bytes32 ref);
    error TransferFailed();

    // ── Initializer ───────────────────────────────────────────────────────────

    /// @custom:oz-upgrades-unsafe-allow constructor
    constructor() {
        _disableInitializers();
    }

    /**
     * @notice Initialize the treasury.
     * @param admin_        Treasury Safe.
     * @param upgrader_     Ecosystem Safe.
     * @param comptroller_  Mach6 bridge wallet. Receives COMPTROLLER_ROLE.
     */
    function initialize(
        address admin_,
        address upgrader_,
        address comptroller_
    ) external initializer {
        if (admin_ == address(0))       revert ZeroAddress();
        if (upgrader_ == address(0))    revert ZeroAddress();
        if (comptroller_ == address(0)) revert ZeroAddress();

        __AccessControl_init();
        __Pausable_init();
        __ReentrancyGuard_init();
        __UUPSUpgradeable_init();

        _grantRole(DEFAULT_ADMIN_ROLE, admin_);
        _grantRole(PAUSER_ROLE,        admin_);
        _grantRole(UPGRADER_ROLE,      upgrader_);
        _grantRole(COMPTROLLER_ROLE,   comptroller_);

        dailyCap     = DAILY_CAP_INITIAL;
        dailyResetAt = block.timestamp;
    }

    // ── Receive ETH ───────────────────────────────────────────────────────────

    receive() external payable {
        emit ETHReceived(msg.sender, msg.value);
    }

    fallback() external payable {
        emit ETHReceived(msg.sender, msg.value);
    }

    // ── Authorized Spend ─────────────────────────────────────────────────────

    /**
     * @notice Authorize an ETH payment. Called by Mach6 bridge after routing Copilot call.
     * @param recipient  Address to send ETH to (Copilot fiat bridge endpoint).
     * @param ethAmount  ETH amount to send.
     * @param ref        Unique job reference (jobId from ComputeGateway). Prevents duplicates.
     */
    function authorizeSpend(
        address payable recipient,
        uint256 ethAmount,
        bytes32 ref
    ) external nonReentrant whenNotPaused onlyRole(COMPTROLLER_ROLE) {
        if (recipient == address(0)) revert ZeroAddress();
        if (ethAmount == 0)          revert ZeroAmount();
        if (spendRefs[ref])          revert DuplicateRef(ref);

        _maybeResetDaily();

        uint256 remaining = dailyCap - dailySpent;
        if (ethAmount > remaining) revert DailyCapExceeded(ethAmount, remaining);

        uint256 balance = address(this).balance;
        if (ethAmount > balance) revert InsufficientBalance(balance, ethAmount);

        spendRefs[ref] = true;
        dailySpent    += ethAmount;
        totalAuthorized += ethAmount;

        (bool ok, ) = recipient.call{value: ethAmount}("");
        if (!ok) revert TransferFailed();

        emit SpendAuthorized(recipient, ethAmount, ref, dailySpent, block.timestamp);
    }

    // ── Emergency Withdrawal ─────────────────────────────────────────────────

    /**
     * @notice Emergency ETH withdrawal. Bypasses daily cap. Admin only.
     * @param recipient  Address to send ETH to.
     * @param ethAmount  Amount to withdraw. Pass type(uint256).max for full balance.
     */
    function emergencyWithdrawETH(
        address payable recipient,
        uint256 ethAmount
    ) external nonReentrant onlyRole(DEFAULT_ADMIN_ROLE) {
        if (recipient == address(0)) revert ZeroAddress();

        uint256 balance = address(this).balance;
        uint256 amount  = (ethAmount == type(uint256).max) ? balance : ethAmount;

        if (amount > balance) revert InsufficientBalance(balance, amount);

        totalEmergencyWithdrawn += amount;

        (bool ok, ) = recipient.call{value: amount}("");
        if (!ok) revert TransferFailed();

        emit EmergencyWithdrawal(recipient, amount, msg.sender, block.timestamp);
    }

    /**
     * @notice Emergency ERC20 withdrawal (for ARCx or other tokens held here).
     */
    function emergencyWithdrawToken(
        address token,
        address recipient,
        uint256 amount
    ) external nonReentrant onlyRole(DEFAULT_ADMIN_ROLE) {
        if (token == address(0))     revert ZeroAddress();
        if (recipient == address(0)) revert ZeroAddress();
        if (amount == 0)             revert ZeroAmount();

        IERC20Upgradeable(token).safeTransfer(recipient, amount);

        emit TokenWithdrawal(token, recipient, amount, msg.sender);
    }

    // ── Admin Config ──────────────────────────────────────────────────────────

    /**
     * @notice Update the daily ETH spend cap.
     */
    function setDailyCap(uint256 newCap) external onlyRole(DEFAULT_ADMIN_ROLE) {
        emit DailyCapUpdated(dailyCap, newCap);
        dailyCap = newCap;
    }

    function pause()   external onlyRole(PAUSER_ROLE) { _pause(); }
    function unpause() external onlyRole(PAUSER_ROLE) { _unpause(); }

    // ── View ──────────────────────────────────────────────────────────────────

    /// @notice ETH remaining in today's spend budget.
    function dailyRemaining() external view returns (uint256) {
        if (block.timestamp >= dailyResetAt + 1 days) return dailyCap;
        return dailyCap > dailySpent ? dailyCap - dailySpent : 0;
    }

    /// @notice Current ETH balance of the treasury.
    function ethBalance() external view returns (uint256) {
        return address(this).balance;
    }

    /// @notice Check if a spend ref has been used.
    function isRefUsed(bytes32 ref) external view returns (bool) {
        return spendRefs[ref];
    }

    // ── Internal ──────────────────────────────────────────────────────────────

    function _maybeResetDaily() internal {
        if (block.timestamp >= dailyResetAt + 1 days) {
            dailySpent   = 0;
            dailyResetAt = block.timestamp;
        }
    }

    // ── Upgrade ───────────────────────────────────────────────────────────────

    function _authorizeUpgrade(address newImplementation)
        internal
        override
        onlyRole(UPGRADER_ROLE)
    {}
}
