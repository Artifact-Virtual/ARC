// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

import "@openzeppelin/contracts-upgradeable/access/AccessControlUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/security/PausableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/security/ReentrancyGuardUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/token/ERC721/IERC721Upgradeable.sol";

/// @notice Minimal interface for ARCsV1 burn function
interface IARCsV1Burnable {
    function burn(address from, uint256 amount) external;
    function balanceOf(address account) external view returns (uint256);
}

/**
 * @title ComputeGateway — Spend ARCs to purchase inference compute
 * @author Artifact Virtual
 * @notice The SPEND side of the ARC compute economy.
 *         Burn ARCs → receive signed compute voucher → Mach6 bridge routes to Copilot.
 *
 * @dev Flow:
 *      1. Agent calls requestCompute(arcsAmount, jobId)
 *      2. Contract validates: caller has SHARD identity (or is whitelisted)
 *      3. Contract burns ARCs via GATEWAY_ROLE on ARCsV1
 *      4. Emits ComputeRequested event with signed voucher data
 *      5. Mach6 bridge (off-chain) catches event, routes to Copilot
 *      6. Bridge calls fulfillCompute(jobId, success) to log result
 *
 *      Every inference call is auditable on-chain.
 *      Who burned what, when, for how much.
 *
 * @custom:security-contact security@artifactvirtual.com
 * @custom:version 1.0.0
 * @custom:network Base L2 Mainnet (Chain ID: 8453)
 *
 * ROLES:
 *   DEFAULT_ADMIN_ROLE — Treasury Safe. Config, whitelist, rates.
 *   BRIDGE_ROLE        — Mach6 gateway hot wallet. Calls fulfillCompute.
 *   UPGRADER_ROLE      — Ecosystem Safe. Contract upgrades.
 *   PAUSER_ROLE        — Treasury Safe. Emergency pause.
 */
contract ComputeGateway is
    Initializable,
    AccessControlUpgradeable,
    PausableUpgradeable,
    ReentrancyGuardUpgradeable,
    UUPSUpgradeable
{
    // ── Roles ─────────────────────────────────────────────────────────────────
    bytes32 public constant BRIDGE_ROLE   = keccak256("BRIDGE_ROLE");
    bytes32 public constant UPGRADER_ROLE = keccak256("UPGRADER_ROLE");
    bytes32 public constant PAUSER_ROLE   = keccak256("PAUSER_ROLE");

    // ── Constants ─────────────────────────────────────────────────────────────
    /// @notice Minimum ARCs required per compute request.
    uint256 public constant MIN_ARCS_PER_REQUEST = 1 * 10 ** 18; // 1 ARCs

    // ── State ─────────────────────────────────────────────────────────────────
    IARCsV1Burnable public arcsToken;
    IERC721Upgradeable public shardToken;

    /// @notice ARCs burned per compute unit. Admin-adjustable.
    /// 1 compute unit ≈ 1K Copilot tokens.
    uint256 public computeRate; // ARCs per unit (18 decimals)

    /// @notice Addresses whitelisted to request compute without SHARD.
    /// Used for agent wallets (AVA, Aria, Singularity) before SBT is assigned.
    mapping(address => bool) public whitelist;

    /// @notice Daily ARCs burned tracking for budget analytics.
    uint256 public dailyBurnedARCs;
    uint256 public dailyResetTimestamp;

    /// @notice Job tracking: jobId => fulfilled
    mapping(bytes32 => bool) public jobFulfilled;
    mapping(bytes32 => address) public jobRequester;
    mapping(bytes32 => uint256) public jobTimestamp;

    /// @notice Total stats
    uint256 public totalARCsBurned;
    uint256 public totalJobsRequested;
    uint256 public totalJobsFulfilled;

    // ── Storage gap ───────────────────────────────────────────────────────────
    uint256[50] private __gap;

    // ── Events ────────────────────────────────────────────────────────────────
    event ComputeRequested(
        address indexed agent,
        bytes32 indexed jobId,
        uint256 arcsAmount,
        uint256 computeUnits,
        uint256 timestamp
    );
    event ComputeFulfilled(
        address indexed agent,
        bytes32 indexed jobId,
        bool success,
        uint256 timestamp
    );
    event WhitelistUpdated(address indexed account, bool status);
    event ComputeRateUpdated(uint256 oldRate, uint256 newRate);

    // ── Errors ────────────────────────────────────────────────────────────────
    error ZeroAddress();
    error ZeroAmount();
    error BelowMinimum(uint256 provided, uint256 minimum);
    error NotAuthorized(address caller);
    error JobAlreadyFulfilled(bytes32 jobId);
    error JobNotFound(bytes32 jobId);
    error ZeroComputeRate();
    error DuplicateJobId(bytes32 jobId);

    // ── Initializer ───────────────────────────────────────────────────────────

    /// @custom:oz-upgrades-unsafe-allow constructor
    constructor() {
        _disableInitializers();
    }

    /**
     * @notice Initialize the ComputeGateway.
     * @param admin_        Treasury Safe.
     * @param upgrader_     Ecosystem Safe.
     * @param bridge_       Mach6 hot wallet. Receives BRIDGE_ROLE.
     * @param arcs_         ARCsV1 proxy address.
     * @param shard_        SHARD SBT contract address.
     * @param computeRate_  Initial ARCs per compute unit (18 decimals).
     */
    function initialize(
        address admin_,
        address upgrader_,
        address bridge_,
        address arcs_,
        address shard_,
        uint256 computeRate_
    ) external initializer {
        if (admin_ == address(0))    revert ZeroAddress();
        if (upgrader_ == address(0)) revert ZeroAddress();
        if (bridge_ == address(0))   revert ZeroAddress();
        if (arcs_ == address(0))     revert ZeroAddress();
        if (shard_ == address(0))    revert ZeroAddress();
        if (computeRate_ == 0)       revert ZeroComputeRate();

        __AccessControl_init();
        __Pausable_init();
        __ReentrancyGuard_init();
        __UUPSUpgradeable_init();

        _grantRole(DEFAULT_ADMIN_ROLE, admin_);
        _grantRole(PAUSER_ROLE,        admin_);
        _grantRole(UPGRADER_ROLE,      upgrader_);
        _grantRole(BRIDGE_ROLE,        bridge_);

        arcsToken    = IARCsV1Burnable(arcs_);
        shardToken   = IERC721Upgradeable(shard_);
        computeRate  = computeRate_;
        dailyResetTimestamp = block.timestamp;
    }

    // ── Request Compute ───────────────────────────────────────────────────────

    /**
     * @notice Request compute by burning ARCs.
     * @param arcsAmount ARCs to burn (18 decimals). Must be >= MIN_ARCS_PER_REQUEST.
     * @param jobId      Unique job identifier. Generated off-chain by agent.
     * @dev Caller must either hold a SHARD token or be on the whitelist.
     *      Caller must approve this contract to spend arcsAmount ARCs first.
     *
     *      Emits ComputeRequested — Mach6 bridge listens for this event.
     */
    function requestCompute(
        uint256 arcsAmount,
        bytes32 jobId
    ) external nonReentrant whenNotPaused {
        // Identity check
        if (!_isAuthorized(msg.sender)) revert NotAuthorized(msg.sender);

        // Amount check
        if (arcsAmount < MIN_ARCS_PER_REQUEST) revert BelowMinimum(arcsAmount, MIN_ARCS_PER_REQUEST);

        // Job deduplication
        if (jobRequester[jobId] != address(0)) revert DuplicateJobId(jobId);

        // Calculate compute units
        uint256 computeUnits = arcsAmount / computeRate;

        // Record job
        jobRequester[jobId]  = msg.sender;
        jobTimestamp[jobId]  = block.timestamp;

        // Update stats
        totalARCsBurned      += arcsAmount;
        totalJobsRequested   += 1;
        dailyBurnedARCs      += arcsAmount;
        _maybeResetDaily();

        // Burn ARCs (gateway pulls from caller)
        arcsToken.burn(msg.sender, arcsAmount);

        emit ComputeRequested(
            msg.sender,
            jobId,
            arcsAmount,
            computeUnits,
            block.timestamp
        );
    }

    // ── Fulfill Compute ───────────────────────────────────────────────────────

    /**
     * @notice Mark a compute job as fulfilled. Called by Mach6 bridge after Copilot responds.
     * @param jobId   Job to fulfill.
     * @param success Whether Copilot returned a successful response.
     */
    function fulfillCompute(
        bytes32 jobId,
        bool success
    ) external onlyRole(BRIDGE_ROLE) {
        if (jobRequester[jobId] == address(0)) revert JobNotFound(jobId);
        if (jobFulfilled[jobId])               revert JobAlreadyFulfilled(jobId);

        jobFulfilled[jobId] = true;
        totalJobsFulfilled += 1;

        emit ComputeFulfilled(
            jobRequester[jobId],
            jobId,
            success,
            block.timestamp
        );
    }

    // ── Admin ─────────────────────────────────────────────────────────────────

    /**
     * @notice Add or remove an address from the whitelist.
     * @param account Address to update.
     * @param status  True to whitelist, false to remove.
     */
    function setWhitelist(address account, bool status)
        external
        onlyRole(DEFAULT_ADMIN_ROLE)
    {
        if (account == address(0)) revert ZeroAddress();
        whitelist[account] = status;
        emit WhitelistUpdated(account, status);
    }

    /**
     * @notice Update compute rate (ARCs per unit).
     * @param newRate New rate (18 decimals). Must be > 0.
     */
    function setComputeRate(uint256 newRate)
        external
        onlyRole(DEFAULT_ADMIN_ROLE)
    {
        if (newRate == 0) revert ZeroComputeRate();
        emit ComputeRateUpdated(computeRate, newRate);
        computeRate = newRate;
    }

    function pause()   external onlyRole(PAUSER_ROLE) { _pause(); }
    function unpause() external onlyRole(PAUSER_ROLE) { _unpause(); }

    // ── View ──────────────────────────────────────────────────────────────────

    /**
     * @notice Check if an address is authorized to request compute.
     */
    function isAuthorized(address account) external view returns (bool) {
        return _isAuthorized(account);
    }

    /**
     * @notice Get job info.
     */
    function getJob(bytes32 jobId) external view returns (
        address requester,
        uint256 timestamp,
        bool fulfilled
    ) {
        return (jobRequester[jobId], jobTimestamp[jobId], jobFulfilled[jobId]);
    }

    // ── Internal ──────────────────────────────────────────────────────────────

    function _isAuthorized(address account) internal view returns (bool) {
        if (whitelist[account]) return true;
        // Check SHARD balance (SBT — balance is 0 or 1)
        try shardToken.balanceOf(account) returns (uint256 bal) {
            return bal > 0;
        } catch {
            return false;
        }
    }

    function _maybeResetDaily() internal {
        if (block.timestamp >= dailyResetTimestamp + 1 days) {
            dailyBurnedARCs     = 0;
            dailyResetTimestamp = block.timestamp;
        }
    }

    // ── Upgrade ───────────────────────────────────────────────────────────────

    function _authorizeUpgrade(address newImplementation)
        internal
        override
        onlyRole(UPGRADER_ROLE)
    {}
}
