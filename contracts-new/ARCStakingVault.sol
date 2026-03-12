// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

import "@openzeppelin/contracts-upgradeable/access/AccessControlUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/security/PausableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/security/ReentrancyGuardUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/token/ERC20/IERC20Upgradeable.sol";
import "@openzeppelin/contracts-upgradeable/token/ERC20/utils/SafeERC20Upgradeable.sol";

/// @notice Minimal interface for ARCsV1 mint function
interface IARCsV1 {
    function mint(address to, uint256 amount) external;
}

/**
 * @title ARCStakingVault — Earn ARCs by staking ARCx
 * @author Artifact Virtual
 * @notice The EARN side of the ARC compute economy.
 *         Stake ARCx → accrue ARCs → claim → spend on inference.
 *
 * @dev Mechanics:
 *      - Stake ARCx: tokens transferred in, position recorded.
 *      - Accrue: ARCs accrue per second based on earnRate.
 *      - Claim: mint accrued ARCs to staker via VAULT_ROLE on ARCsV1.
 *      - Unstake: 7-day cooldown prevents flash-stake-claim-unstake gaming.
 *
 *      Earn rate: EARN_RATE_INITIAL = 100 ARCs per 1 ARCx per 7 days.
 *      Formula: accrued = (staked * rate * elapsed) / (RATE_DENOMINATOR * 7 days)
 *      Rate is in ARCs per ARCx (scaled by RATE_DENOMINATOR = 1e18).
 *
 * @custom:security-contact security@artifactvirtual.com
 * @custom:version 1.0.0
 * @custom:network Base L2 Mainnet (Chain ID: 8453)
 *
 * ROLES:
 *   DEFAULT_ADMIN_ROLE — Treasury Safe. Can update earn rate, pause.
 *   UPGRADER_ROLE      — Ecosystem Safe. Contract upgrades.
 *   PAUSER_ROLE        — Treasury Safe. Emergency pause.
 */
contract ARCStakingVault is
    Initializable,
    AccessControlUpgradeable,
    PausableUpgradeable,
    ReentrancyGuardUpgradeable,
    UUPSUpgradeable
{
    using SafeERC20Upgradeable for IERC20Upgradeable;

    // ── Roles ─────────────────────────────────────────────────────────────────
    bytes32 public constant UPGRADER_ROLE = keccak256("UPGRADER_ROLE");
    bytes32 public constant PAUSER_ROLE   = keccak256("PAUSER_ROLE");

    // ── Constants ─────────────────────────────────────────────────────────────
    uint256 public constant RATE_DENOMINATOR = 1e18;
    uint256 public constant UNSTAKE_COOLDOWN = 7 days;

    /// @notice Initial earn rate: 100 ARCs per 1 ARCx per 7 days.
    /// Expressed as: (100 * RATE_DENOMINATOR) ARCs per ARCx per EARN_PERIOD.
    uint256 public constant EARN_RATE_INITIAL = 100 * 1e18;
    uint256 public constant EARN_PERIOD       = 7 days;

    // ── State ─────────────────────────────────────────────────────────────────
    IERC20Upgradeable public arcxToken;
    IARCsV1           public arcsToken;

    /// @notice Current earn rate. Admin-adjustable.
    uint256 public earnRate;

    struct StakePosition {
        uint256 amount;          // ARCx staked
        uint256 stakedAt;        // timestamp of last stake/claim reset
        uint256 accruedARCs;     // ARCs accrued but not yet claimed
        uint256 unstakeRequestedAt; // timestamp of unstake request (0 if none)
        uint256 unstakeAmount;   // amount queued for unstake
    }

    mapping(address => StakePosition) public positions;

    /// @notice Total ARCx staked across all users.
    uint256 public totalStaked;

    // ── Storage gap ───────────────────────────────────────────────────────────
    uint256[50] private __gap;

    // ── Events ────────────────────────────────────────────────────────────────
    event Staked(address indexed user, uint256 amount, uint256 timestamp);
    event UnstakeRequested(address indexed user, uint256 amount, uint256 unlockAt);
    event Unstaked(address indexed user, uint256 amount, uint256 timestamp);
    event Claimed(address indexed user, uint256 arcsAmount, uint256 timestamp);
    event EarnRateUpdated(uint256 oldRate, uint256 newRate, uint256 timestamp);

    // ── Errors ────────────────────────────────────────────────────────────────
    error ZeroAddress();
    error ZeroAmount();
    error NothingStaked();
    error CooldownNotComplete(uint256 unlockAt, uint256 now_);
    error NoUnstakeRequested();
    error UnstakeAlreadyRequested();
    error NothingToClaim();
    error InsufficientStaked(uint256 staked, uint256 requested);

    // ── Initializer ───────────────────────────────────────────────────────────

    /// @custom:oz-upgrades-unsafe-allow constructor
    constructor() {
        _disableInitializers();
    }

    /**
     * @notice Initialize the staking vault.
     * @param admin_    Treasury Safe.
     * @param upgrader_ Ecosystem Safe.
     * @param arcx_     ARCxV3 proxy address.
     * @param arcs_     ARCsV1 proxy address.
     */
    function initialize(
        address admin_,
        address upgrader_,
        address arcx_,
        address arcs_
    ) external initializer {
        if (admin_ == address(0))    revert ZeroAddress();
        if (upgrader_ == address(0)) revert ZeroAddress();
        if (arcx_ == address(0))     revert ZeroAddress();
        if (arcs_ == address(0))     revert ZeroAddress();

        __AccessControl_init();
        __Pausable_init();
        __ReentrancyGuard_init();
        __UUPSUpgradeable_init();

        _grantRole(DEFAULT_ADMIN_ROLE, admin_);
        _grantRole(PAUSER_ROLE,        admin_);
        _grantRole(UPGRADER_ROLE,      upgrader_);

        arcxToken = IERC20Upgradeable(arcx_);
        arcsToken = IARCsV1(arcs_);
        earnRate  = EARN_RATE_INITIAL;
    }

    // ── Stake ─────────────────────────────────────────────────────────────────

    /**
     * @notice Stake ARCx to start earning ARCs.
     * @param amount ARCx amount to stake (18 decimals).
     * @dev Accrues pending rewards before adding to position.
     *      Caller must approve this contract for `amount` ARCx first.
     */
    function stake(uint256 amount) external nonReentrant whenNotPaused {
        if (amount == 0) revert ZeroAmount();

        StakePosition storage pos = positions[msg.sender];

        // Snapshot accrued rewards before modifying position
        pos.accruedARCs += _pendingARCs(msg.sender);
        pos.stakedAt     = block.timestamp;
        pos.amount      += amount;
        totalStaked     += amount;

        arcxToken.safeTransferFrom(msg.sender, address(this), amount);

        emit Staked(msg.sender, amount, block.timestamp);
    }

    // ── Unstake ───────────────────────────────────────────────────────────────

    /**
     * @notice Request to unstake ARCx. Begins 7-day cooldown.
     * @param amount ARCx amount to unstake.
     */
    function requestUnstake(uint256 amount) external nonReentrant whenNotPaused {
        StakePosition storage pos = positions[msg.sender];
        if (pos.amount == 0)        revert NothingStaked();
        if (amount == 0)            revert ZeroAmount();
        if (amount > pos.amount)    revert InsufficientStaked(pos.amount, amount);
        if (pos.unstakeRequestedAt != 0) revert UnstakeAlreadyRequested();

        // Snapshot accrued rewards before reducing position
        pos.accruedARCs += _pendingARCs(msg.sender);
        pos.stakedAt     = block.timestamp;
        pos.amount      -= amount;
        totalStaked     -= amount;

        pos.unstakeRequestedAt = block.timestamp;
        pos.unstakeAmount      = amount;

        emit UnstakeRequested(msg.sender, amount, block.timestamp + UNSTAKE_COOLDOWN);
    }

    /**
     * @notice Complete unstake after cooldown period has elapsed.
     */
    function unstake() external nonReentrant {
        StakePosition storage pos = positions[msg.sender];
        if (pos.unstakeRequestedAt == 0) revert NoUnstakeRequested();

        uint256 unlockAt = pos.unstakeRequestedAt + UNSTAKE_COOLDOWN;
        if (block.timestamp < unlockAt) revert CooldownNotComplete(unlockAt, block.timestamp);

        uint256 amount = pos.unstakeAmount;
        pos.unstakeRequestedAt = 0;
        pos.unstakeAmount      = 0;

        arcxToken.safeTransfer(msg.sender, amount);

        emit Unstaked(msg.sender, amount, block.timestamp);
    }

    // ── Claim ─────────────────────────────────────────────────────────────────

    /**
     * @notice Claim all accrued ARCs.
     * @dev Mints ARCs directly to caller via ARCsV1.mint() (VAULT_ROLE).
     */
    function claim() external nonReentrant whenNotPaused {
        StakePosition storage pos = positions[msg.sender];

        uint256 pending  = _pendingARCs(msg.sender);
        uint256 claimable = pos.accruedARCs + pending;

        if (claimable == 0) revert NothingToClaim();

        pos.accruedARCs = 0;
        pos.stakedAt    = block.timestamp;

        arcsToken.mint(msg.sender, claimable);

        emit Claimed(msg.sender, claimable, block.timestamp);
    }

    // ── Admin ─────────────────────────────────────────────────────────────────

    /**
     * @notice Update the earn rate. Affects future accrual only.
     * @param newRate New rate (ARCs per ARCx per EARN_PERIOD, scaled by RATE_DENOMINATOR).
     *                Example: 100 ARCs per ARCx per 7 days = 100 * 1e18.
     */
    function setEarnRate(uint256 newRate) external onlyRole(DEFAULT_ADMIN_ROLE) {
        uint256 old = earnRate;
        earnRate = newRate;
        emit EarnRateUpdated(old, newRate, block.timestamp);
    }

    function pause()   external onlyRole(PAUSER_ROLE) { _pause(); }
    function unpause() external onlyRole(PAUSER_ROLE) { _unpause(); }

    // ── View ──────────────────────────────────────────────────────────────────

    /**
     * @notice Get pending (unaccrued) ARCs for an address.
     * @param user Address to query.
     */
    function pendingARCs(address user) external view returns (uint256) {
        return positions[user].accruedARCs + _pendingARCs(user);
    }

    /**
     * @notice Get full position info for an address.
     */
    function getPosition(address user) external view returns (
        uint256 stakedAmount,
        uint256 totalPendingARCs,
        uint256 unstakeAmount,
        uint256 unstakeUnlocksAt
    ) {
        StakePosition storage pos = positions[user];
        return (
            pos.amount,
            pos.accruedARCs + _pendingARCs(user),
            pos.unstakeAmount,
            pos.unstakeRequestedAt == 0 ? 0 : pos.unstakeRequestedAt + UNSTAKE_COOLDOWN
        );
    }

    // ── Internal ──────────────────────────────────────────────────────────────

    /**
     * @dev Calculate ARCs accrued since last snapshot.
     *      Formula: (stakedAmount * earnRate * elapsed) / (RATE_DENOMINATOR * EARN_PERIOD)
     */
    function _pendingARCs(address user) internal view returns (uint256) {
        StakePosition storage pos = positions[user];
        if (pos.amount == 0 || pos.stakedAt == 0) return 0;

        uint256 elapsed = block.timestamp - pos.stakedAt;
        return (pos.amount * earnRate * elapsed) / (RATE_DENOMINATOR * EARN_PERIOD);
    }

    // ── Upgrade ───────────────────────────────────────────────────────────────

    function _authorizeUpgrade(address newImplementation)
        internal
        override
        onlyRole(UPGRADER_ROLE)
    {}
}
