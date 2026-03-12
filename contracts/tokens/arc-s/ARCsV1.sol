// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

import "@openzeppelin/contracts-upgradeable/token/ERC20/ERC20Upgradeable.sol";
import "@openzeppelin/contracts-upgradeable/access/AccessControlUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol";

/**
 * @title ARCsV1 — ARC Staked Token (Compute Fuel)
 * @author Artifact Virtual
 * @notice Non-transferable compute fuel token for the ARC ecosystem.
 *         Earned by staking ARCx. Burned to purchase inference compute.
 *         Net supply reflects active compute demand — uncapped by design.
 *
 * @dev Design principles:
 *      - Non-transferable in V1. No secondary market. Earn it. Spend it.
 *      - Minted ONLY by ARCStakingVault (VAULT_ROLE).
 *      - Burned ONLY by ComputeGateway (GATEWAY_ROLE).
 *      - UUPS upgradeable. Admin = Gnosis Treasury Safe.
 *      - Storage gap for safe future upgrades.
 *
 * @custom:security-contact security@artifactvirtual.com
 * @custom:version 1.0.0
 * @custom:network Base L2 Mainnet (Chain ID: 8453)
 *
 * ROLES:
 *   DEFAULT_ADMIN_ROLE — Treasury Safe. Full admin.
 *   VAULT_ROLE         — ARCStakingVault. Can mint tokens.
 *   GATEWAY_ROLE       — ComputeGateway. Can burn tokens.
 *   UPGRADER_ROLE      — Ecosystem Safe. Contract upgrades.
 */
contract ARCsV1 is
    Initializable,
    ERC20Upgradeable,
    AccessControlUpgradeable,
    UUPSUpgradeable
{
    // ── Roles ─────────────────────────────────────────────────────────────────
    bytes32 public constant VAULT_ROLE    = keccak256("VAULT_ROLE");
    bytes32 public constant GATEWAY_ROLE  = keccak256("GATEWAY_ROLE");
    bytes32 public constant UPGRADER_ROLE = keccak256("UPGRADER_ROLE");

    // ── Storage gap ───────────────────────────────────────────────────────────
    uint256[50] private __gap;

    // ── Events ────────────────────────────────────────────────────────────────
    event ComputeFuelMinted(address indexed to, uint256 amount, uint256 timestamp);
    event ComputeFuelBurned(address indexed from, uint256 amount, uint256 timestamp);

    // ── Errors ────────────────────────────────────────────────────────────────
    error ZeroAddress();
    error ZeroAmount();
    error TransferNotAllowed();
    error InsufficientBalance(uint256 have, uint256 need);

    // ── Initializer ───────────────────────────────────────────────────────────

    /// @custom:oz-upgrades-unsafe-allow constructor
    constructor() {
        _disableInitializers();
    }

    /**
     * @notice Initialize ARCsV1.
     * @param admin     Treasury Safe. Receives DEFAULT_ADMIN_ROLE.
     * @param upgrader  Ecosystem Safe. Receives UPGRADER_ROLE.
     * @dev VAULT_ROLE and GATEWAY_ROLE are NOT assigned here.
     *      They are granted after StakingVault and ComputeGateway are deployed
     *      via the wire_roles.ts script. This prevents zero-address role grants.
     */
    function initialize(
        address admin,
        address upgrader
    ) external initializer {
        if (admin == address(0))    revert ZeroAddress();
        if (upgrader == address(0)) revert ZeroAddress();

        __ERC20_init("ARC Staked", "ARCs");
        __AccessControl_init();
        __UUPSUpgradeable_init();

        _grantRole(DEFAULT_ADMIN_ROLE, admin);
        _grantRole(UPGRADER_ROLE,      upgrader);
    }

    // ── Mint ──────────────────────────────────────────────────────────────────

    /**
     * @notice Mint ARCs to an address. Only callable by VAULT_ROLE (ARCStakingVault).
     * @param to     Recipient. Must not be zero address.
     * @param amount Amount to mint (18 decimals).
     */
    function mint(address to, uint256 amount) external onlyRole(VAULT_ROLE) {
        if (to == address(0)) revert ZeroAddress();
        if (amount == 0)      revert ZeroAmount();
        _mint(to, amount);
        emit ComputeFuelMinted(to, amount, block.timestamp);
    }

    // ── Burn ──────────────────────────────────────────────────────────────────

    /**
     * @notice Burn ARCs from an address. Only callable by GATEWAY_ROLE (ComputeGateway).
     * @dev Gateway must have been approved or hold the tokens. In V1, the gateway
     *      burns from msg.sender (the agent calling requestCompute), not from itself.
     *      This requires the agent to approve the gateway before calling.
     * @param from   Address to burn from.
     * @param amount Amount to burn.
     */
    function burn(address from, uint256 amount) external onlyRole(GATEWAY_ROLE) {
        if (from == address(0)) revert ZeroAddress();
        if (amount == 0)        revert ZeroAmount();
        uint256 balance = balanceOf(from);
        if (balance < amount)   revert InsufficientBalance(balance, amount);
        _burn(from, amount);
        emit ComputeFuelBurned(from, amount, block.timestamp);
    }

    // ── Non-transferable override ─────────────────────────────────────────────

    /**
     * @dev Block all transfers in V1. ARCs is non-transferable.
     *      Only minting (from=0) and burning (to=0) are allowed.
     *      OZ v4 uses _beforeTokenTransfer.
     */
    function _beforeTokenTransfer(
        address from,
        address to,
        uint256 amount
    ) internal override {
        // Allow mint (from == 0) and burn (to == 0)
        bool isMint = (from == address(0));
        bool isBurn = (to == address(0));

        if (!isMint && !isBurn) {
            revert TransferNotAllowed();
        }

        super._beforeTokenTransfer(from, to, amount);
    }

    // ── Upgrade ───────────────────────────────────────────────────────────────

    function _authorizeUpgrade(address newImplementation)
        internal
        override
        onlyRole(UPGRADER_ROLE)
    {}

    // ── View helpers ──────────────────────────────────────────────────────────

    /// @notice Check if an address can currently mint (has VAULT_ROLE).
    function isVault(address account) external view returns (bool) {
        return hasRole(VAULT_ROLE, account);
    }

    /// @notice Check if an address can currently burn (has GATEWAY_ROLE).
    function isGateway(address account) external view returns (bool) {
        return hasRole(GATEWAY_ROLE, account);
    }
}
