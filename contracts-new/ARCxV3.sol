// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

import "@openzeppelin/contracts-upgradeable/token/ERC20/ERC20Upgradeable.sol";
import "@openzeppelin/contracts-upgradeable/token/ERC20/extensions/ERC20BurnableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/token/ERC20/extensions/ERC20VotesUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/token/ERC20/extensions/ERC20PermitUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/access/AccessControlUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/security/PausableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/security/ReentrancyGuardUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol";

/**
 * @title ARCxV3 — ARC Exchange Token
 * @author Artifact Virtual
 * @notice Core utility and governance token for the ARC ecosystem.
 *         V3 is a clean-slate redesign: correct by construction.
 *
 * @dev Design principles:
 *      - Simplicity first. Complexity is earned, not assumed.
 *      - No flash loans (V1). Adds attack surface, not value yet.
 *      - No transfer fees (V1). Complicates LP integration.
 *      - No auto-yield (V1). Yield is ONLY via ARCStakingVault.
 *      - No blacklist. Replaced with pause. Simpler, less centralisation risk.
 *      - UUPS upgradeable. Admin = Gnosis Treasury Safe.
 *
 * @custom:security-contact security@artifactvirtual.com
 * @custom:version 3.0.0
 * @custom:network Base L2 Mainnet (Chain ID: 8453)
 *
 * ROLES:
 *   DEFAULT_ADMIN_ROLE — Treasury Safe (Gnosis multisig). Full admin.
 *   MINTER_ROLE        — Deployer only for genesis mint, then revoked.
 *   UPGRADER_ROLE      — Ecosystem Safe (Gnosis multisig). Contract upgrades.
 *   PAUSER_ROLE        — Treasury Safe. Emergency pause.
 */
contract ARCxV3 is
    Initializable,
    ERC20Upgradeable,
    ERC20BurnableUpgradeable,
    ERC20PermitUpgradeable,
    ERC20VotesUpgradeable,
    AccessControlUpgradeable,
    PausableUpgradeable,
    ReentrancyGuardUpgradeable,
    UUPSUpgradeable
{
    // ── Roles ─────────────────────────────────────────────────────────────────
    bytes32 public constant MINTER_ROLE   = keccak256("MINTER_ROLE");
    bytes32 public constant UPGRADER_ROLE = keccak256("UPGRADER_ROLE");
    bytes32 public constant PAUSER_ROLE   = keccak256("PAUSER_ROLE");

    // ── Supply ────────────────────────────────────────────────────────────────
    /// @notice Hard cap. 10M tokens. Chosen to support agent staking,
    ///         LP depth, and ecosystem growth without hyperinflation.
    uint256 public constant MAX_SUPPLY = 10_000_000 * 10 ** 18;

    /// @notice Once supply is finalized, no more minting ever.
    bool public supplyFinalized;

    // ── Storage gap ───────────────────────────────────────────────────────────
    uint256[50] private __gap;

    // ── Events ────────────────────────────────────────────────────────────────
    event SupplyFinalized(uint256 totalSupply, uint256 timestamp);

    // ── Errors ────────────────────────────────────────────────────────────────
    error ZeroAddress();
    error ExceedsMaxSupply(uint256 requested, uint256 available);
    error SupplyAlreadyFinalized();
    error TransferWhilePaused();

    // ── Initializer ───────────────────────────────────────────────────────────

    /// @custom:oz-upgrades-unsafe-allow constructor
    constructor() {
        _disableInitializers();
    }

    /**
     * @notice Initialize the ARCxV3 token.
     * @param admin     Treasury Safe address. Receives DEFAULT_ADMIN_ROLE + PAUSER_ROLE.
     * @param upgrader  Ecosystem Safe address. Receives UPGRADER_ROLE.
     * @param minter    Deployer address. Receives MINTER_ROLE for genesis mint only.
     */
    function initialize(
        address admin,
        address upgrader,
        address minter
    ) external initializer {
        if (admin == address(0))   revert ZeroAddress();
        if (upgrader == address(0)) revert ZeroAddress();
        if (minter == address(0))  revert ZeroAddress();

        __ERC20_init("ARC Exchange", "ARCx");
        __ERC20Burnable_init();
        __ERC20Votes_init();
        __ERC20Permit_init("ARC Exchange");
        __AccessControl_init();
        __Pausable_init();
        __ReentrancyGuard_init();
        __UUPSUpgradeable_init();

        _grantRole(DEFAULT_ADMIN_ROLE, admin);
        _grantRole(PAUSER_ROLE,        admin);
        _grantRole(UPGRADER_ROLE,      upgrader);
        _grantRole(MINTER_ROLE,        minter);
    }

    // ── Mint ──────────────────────────────────────────────────────────────────

    /**
     * @notice Mint tokens. Only callable by MINTER_ROLE (deployer for genesis, then revoked).
     * @param to     Recipient address.
     * @param amount Amount to mint (in wei, 18 decimals).
     */
    function mint(address to, uint256 amount) external onlyRole(MINTER_ROLE) {
        if (supplyFinalized) revert SupplyAlreadyFinalized();
        if (to == address(0)) revert ZeroAddress();
        uint256 available = MAX_SUPPLY - totalSupply();
        if (amount > available) revert ExceedsMaxSupply(amount, available);
        _mint(to, amount);
    }

    /**
     * @notice Permanently lock the supply. No more minting after this call.
     *         Call after genesis distribution is complete.
     */
    function finalizeSupply() external onlyRole(DEFAULT_ADMIN_ROLE) {
        if (supplyFinalized) revert SupplyAlreadyFinalized();
        supplyFinalized = true;
        emit SupplyFinalized(totalSupply(), block.timestamp);
    }

    // ── Pause ─────────────────────────────────────────────────────────────────

    /// @notice Pause all transfers. Emergency use only.
    function pause() external onlyRole(PAUSER_ROLE) {
        _pause();
    }

    /// @notice Unpause transfers.
    function unpause() external onlyRole(PAUSER_ROLE) {
        _unpause();
    }

    // ── Transfer overrides ────────────────────────────────────────────────────

    /**
     * @dev Block transfers when paused. Override required by multiple base contracts.
     *      OZ v4 uses _afterTokenTransfer, not _update.
     */
    function _afterTokenTransfer(
        address from,
        address to,
        uint256 amount
    ) internal override(ERC20Upgradeable, ERC20VotesUpgradeable) {
        super._afterTokenTransfer(from, to, amount);
    }

    function _mint(address to, uint256 amount)
        internal
        override(ERC20Upgradeable, ERC20VotesUpgradeable)
    {
        super._mint(to, amount);
    }

    function _burn(address account, uint256 amount)
        internal
        override(ERC20Upgradeable, ERC20VotesUpgradeable)
    {
        super._burn(account, amount);
    }

    /**
     * @dev Block transfers when paused.
     */
    function _beforeTokenTransfer(
        address from,
        address to,
        uint256 amount
    ) internal override whenNotPaused {
        super._beforeTokenTransfer(from, to, amount);
    }

    // ── Upgrade ───────────────────────────────────────────────────────────────

    /**
     * @dev Only UPGRADER_ROLE (Ecosystem Safe) can authorize upgrades.
     */
    function _authorizeUpgrade(address newImplementation)
        internal
        override
        onlyRole(UPGRADER_ROLE)
    {}

    // ── View helpers ──────────────────────────────────────────────────────────

    /// @notice Remaining mintable supply.
    function remainingSupply() external view returns (uint256) {
        if (supplyFinalized) return 0;
        return MAX_SUPPLY - totalSupply();
    }

    /// @notice Returns true if the address holds voting power (has tokens).
    function isVoter(address account) external view returns (bool) {
        return balanceOf(account) > 0;
    }
}
