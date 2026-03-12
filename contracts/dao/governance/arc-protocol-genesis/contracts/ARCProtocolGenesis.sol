// SPDX-License-Identifier: AGPL-3.0
pragma solidity ^0.8.26;

import {IARCProtocolGenesis} from "./IARCProtocolGenesis.sol";

/**
 * @title ARCProtocolGenesis
 * @notice The immutable L1 constitutional anchor for the ARC Protocol
 * @dev Pure functions only - no storage, no owner, no upgrades, deterministic forever
 * 
 * This contract defines the fundamental rules that even governance cannot violate:
 * - Protocol constants (chain IDs, deployment info)
 * - Governance bounds (min/max limits on parameters)
 * - Treasury limits (withdrawal caps, reserve requirements)
 * - Token economics (max supply, inflation caps)
 * - Emergency powers (pause duration, multisig requirements)
 * 
 * All ARC subsystems MUST call genesis validation before critical operations.
 * 
 * Security Model:
 * - Cannot be corrupted (pure functions, no state)
 * - Cannot be upgraded (no upgrade path)
 * - Cannot be controlled (no owner, no admin)
 * - Deterministic forever (same inputs → same outputs)
 */
contract ARCProtocolGenesis is IARCProtocolGenesis {
    // ============================================
    // FUNDAMENTAL IDENTITY
    // ============================================
    
    bytes32 public constant PROTOCOL_NAME = keccak256("ARC_PROTOCOL");
    bytes32 public constant PROTOCOL_VERSION = keccak256("1.0.0");
    bytes32 public constant CONSTITUTIONAL_HASH = keccak256("ARC::CONSTITUTION::v1.0.0");
    
    // ============================================
    // CHAIN IDENTITY (L1 Ethereum Mainnet)
    // ============================================
    
    uint256 public constant GENESIS_CHAIN_ID = 1; // Ethereum mainnet
    uint256 public immutable GENESIS_BLOCK;
    uint256 public immutable GENESIS_TIMESTAMP;
    
    // ============================================
    // SECONDARY CHAINS (L2s)
    // ============================================
    
    uint256 public constant BASE_CHAIN_ID = 8453; // Base mainnet
    uint256 public constant OPTIMISM_CHAIN_ID = 10; // Optimism (future)
    uint256 public constant ARBITRUM_CHAIN_ID = 42161; // Arbitrum (future)
    
    // ============================================
    // CRYPTOGRAPHIC ANCHORS
    // ============================================
    
    bytes32 public immutable DOMAIN_SEPARATOR; // EIP-712 domain
    bytes32 public immutable GENESIS_ROOT_HASH; // Merkle root of all genesis data
    
    // ============================================
    // TREASURY LIMITS (per proposal)
    // ============================================
    
    uint256 public constant MAX_TREASURY_WITHDRAWAL_BPS = 1000; // 10% max per proposal
    uint256 public constant MIN_TREASURY_RESERVE_BPS = 2000; // 20% must always remain
    uint256 public constant MAX_DAILY_TREASURY_SPEND_BPS = 500; // 5% max per day
    
    // ============================================
    // GOVERNANCE PARAMETERS (limits on Governor)
    // ============================================
    
    uint256 public constant MIN_PROPOSAL_THRESHOLD_BPS = 10; // 0.1% min to propose
    uint256 public constant MAX_PROPOSAL_THRESHOLD_BPS = 500; // 5% max to propose
    uint256 public constant MIN_QUORUM_BPS = 400; // 4% minimum quorum
    uint256 public constant MAX_QUORUM_BPS = 2000; // 20% maximum quorum
    uint256 public constant MIN_VOTING_PERIOD = 1 days;
    uint256 public constant MAX_VOTING_PERIOD = 30 days;
    uint256 public constant MIN_TIMELOCK_DELAY = 2 days;
    uint256 public constant MAX_TIMELOCK_DELAY = 30 days;
    
    // ============================================
    // TOKEN ECONOMICS (limits on ARCx)
    // ============================================
    
    uint256 public constant MAX_TOTAL_SUPPLY = 1_000_000_000 * 1e18; // 1 billion max
    uint256 public constant MIN_INFLATION_RATE_BPS = 0; // 0% min inflation
    uint256 public constant MAX_INFLATION_RATE_BPS = 500; // 5% max inflation per year
    
    // ============================================
    // EMERGENCY POWERS
    // ============================================
    
    uint256 public constant EMERGENCY_PAUSE_DURATION = 7 days; // Max pause duration
    uint256 public constant EMERGENCY_COUNCIL_SIZE_MIN = 3; // Min signers
    uint256 public constant EMERGENCY_COUNCIL_SIZE_MAX = 9; // Max signers
    
    // ============================================
    // SUBSYSTEM REGISTRY (Canonical Addresses)
    // ============================================
    
    // Core Governance (L1)
    address public immutable TREASURY_ADDRESS;
    address public immutable TIMELOCK_ADDRESS;
    address public immutable GOVERNOR_ADDRESS;
    address public immutable TOKEN_ADDRESS; // ARCx
    
    // Constitutional Engine (L1)
    address public immutable ADAM_HOST_ADDRESS;
    address public immutable ADAM_REGISTRY_ADDRESS;
    
    // AI Identity System (L1)
    address public immutable AI_GENESIS_ADDRESS;
    address public immutable AI_REGISTRY_ADDRESS;
    address public immutable AI_SBT_ADDRESS;
    
    // Cross-Chain Infrastructure
    address public immutable L1_L2_MESSENGER_ADDRESS;
    address public immutable L2_GENESIS_VERIFIER_ADDRESS;
    
    // Emergency Multisig
    address public immutable EMERGENCY_COUNCIL_ADDRESS;
    
    // ============================================
    // CONSTRUCTOR (One-Time Setup)
    // ============================================
    
    /**
     * @notice Deploys the genesis contract with all canonical addresses
     * @param _treasury Treasury contract address
     * @param _timelock Timelock contract address
     * @param _governor Governor contract address
     * @param _token ARCx token address
     * @param _adamHost ADAM host contract address
     * @param _adamRegistry ADAM registry address
     * @param _aiGenesis AI Genesis contract address
     * @param _aiRegistry AI Registry contract address
     * @param _aiSBT AI SBT contract address
     * @param _l1l2Messenger Cross-chain messenger address
     * @param _l2Verifier L2 verifier address
     * @param _emergencyCouncil Emergency multisig address
     */
    constructor(
        address _treasury,
        address _timelock,
        address _governor,
        address _token,
        address _adamHost,
        address _adamRegistry,
        address _aiGenesis,
        address _aiRegistry,
        address _aiSBT,
        address _l1l2Messenger,
        address _l2Verifier,
        address _emergencyCouncil
    ) {
        require(_treasury != address(0), "Invalid treasury");
        require(_timelock != address(0), "Invalid timelock");
        require(_governor != address(0), "Invalid governor");
        require(_token != address(0), "Invalid token");
        require(_adamHost != address(0), "Invalid ADAM host");
        require(_adamRegistry != address(0), "Invalid ADAM registry");
        require(_aiGenesis != address(0), "Invalid AI genesis");
        require(_aiRegistry != address(0), "Invalid AI registry");
        require(_aiSBT != address(0), "Invalid AI SBT");
        require(_emergencyCouncil != address(0), "Invalid emergency council");
        
        // Set immutable addresses
        TREASURY_ADDRESS = _treasury;
        TIMELOCK_ADDRESS = _timelock;
        GOVERNOR_ADDRESS = _governor;
        TOKEN_ADDRESS = _token;
        ADAM_HOST_ADDRESS = _adamHost;
        ADAM_REGISTRY_ADDRESS = _adamRegistry;
        AI_GENESIS_ADDRESS = _aiGenesis;
        AI_REGISTRY_ADDRESS = _aiRegistry;
        AI_SBT_ADDRESS = _aiSBT;
        L1_L2_MESSENGER_ADDRESS = _l1l2Messenger;
        L2_GENESIS_VERIFIER_ADDRESS = _l2Verifier;
        EMERGENCY_COUNCIL_ADDRESS = _emergencyCouncil;
        
        // Set deployment metadata
        GENESIS_BLOCK = block.number;
        GENESIS_TIMESTAMP = block.timestamp;
        
        // Compute EIP-712 domain separator
        DOMAIN_SEPARATOR = keccak256(
            abi.encode(
                keccak256("EIP712Domain(string name,string version,uint256 chainId,address verifyingContract)"),
                PROTOCOL_NAME,
                PROTOCOL_VERSION,
                block.chainid,
                address(this)
            )
        );
        
        // Compute genesis root hash (merkle root of all genesis data)
        GENESIS_ROOT_HASH = keccak256(
            abi.encodePacked(
                PROTOCOL_NAME,
                PROTOCOL_VERSION,
                CONSTITUTIONAL_HASH,
                GENESIS_CHAIN_ID,
                block.number,
                block.timestamp,
                _treasury,
                _timelock,
                _governor,
                _token,
                _adamHost,
                _adamRegistry,
                _aiGenesis,
                _aiRegistry,
                _aiSBT,
                _emergencyCouncil
            )
        );
    }
    
    // ============================================
    // VALIDATION FUNCTIONS
    // ============================================
    
    /**
     * @notice Validates treasury withdrawal against genesis bounds
     * @param amount Amount to withdraw (in wei)
     * @param treasuryBalance Current treasury balance
     * @param lastWithdrawalTimestamp Timestamp of last withdrawal
     * @param dailySpentAmount Amount already spent today
     * @return valid True if withdrawal is genesis-compliant
     * @return reason Human-readable reason if invalid
     */
    function validateTreasuryWithdrawal(
        uint256 amount,
        uint256 treasuryBalance,
        uint256 lastWithdrawalTimestamp,
        uint256 dailySpentAmount
    ) external view override returns (bool valid, string memory reason) {
        // Check: Amount doesn't exceed max per proposal
        uint256 maxAmount = (treasuryBalance * MAX_TREASURY_WITHDRAWAL_BPS) / 10000;
        if (amount > maxAmount) {
            return (false, "Exceeds max withdrawal per proposal (10%)");
        }
        
        // Check: Remaining balance meets minimum reserve requirement
        uint256 minReserve = (treasuryBalance * MIN_TREASURY_RESERVE_BPS) / 10000;
        if (treasuryBalance - amount < minReserve) {
            return (false, "Would violate minimum reserve requirement (20%)");
        }
        
        // Check: Daily spending limit
        uint256 maxDaily = (treasuryBalance * MAX_DAILY_TREASURY_SPEND_BPS) / 10000;
        uint256 todaySpent = block.timestamp - lastWithdrawalTimestamp < 1 days 
            ? dailySpentAmount 
            : 0;
            
        if (todaySpent + amount > maxDaily) {
            return (false, "Exceeds daily spending limit (5%)");
        }
        
        return (true, "");
    }
    
    /**
     * @notice Validates proposed governance parameter change
     * @param paramName Parameter being changed
     * @param newValue Proposed new value
     * @return valid True if parameter change is genesis-compliant
     * @return reason Human-readable reason if invalid
     */
    function validateGovernanceParameter(
        bytes32 paramName,
        uint256 newValue
    ) external view override returns (bool valid, string memory reason) {
        if (paramName == keccak256("proposalThreshold")) {
            if (newValue < MIN_PROPOSAL_THRESHOLD_BPS) {
                return (false, "Proposal threshold below minimum (0.1%)");
            }
            if (newValue > MAX_PROPOSAL_THRESHOLD_BPS) {
                return (false, "Proposal threshold above maximum (5%)");
            }
            return (true, "");
        }
        
        if (paramName == keccak256("quorum")) {
            if (newValue < MIN_QUORUM_BPS) {
                return (false, "Quorum below minimum (4%)");
            }
            if (newValue > MAX_QUORUM_BPS) {
                return (false, "Quorum above maximum (20%)");
            }
            return (true, "");
        }
        
        if (paramName == keccak256("votingPeriod")) {
            if (newValue < MIN_VOTING_PERIOD) {
                return (false, "Voting period below minimum (1 day)");
            }
            if (newValue > MAX_VOTING_PERIOD) {
                return (false, "Voting period above maximum (30 days)");
            }
            return (true, "");
        }
        
        if (paramName == keccak256("timelockDelay")) {
            if (newValue < MIN_TIMELOCK_DELAY) {
                return (false, "Timelock delay below minimum (2 days)");
            }
            if (newValue > MAX_TIMELOCK_DELAY) {
                return (false, "Timelock delay above maximum (30 days)");
            }
            return (true, "");
        }
        
        return (false, "Unknown parameter");
    }
    
    /**
     * @notice Validates token minting against max supply and inflation limits
     * @param currentSupply Current total supply
     * @param mintAmount Amount to mint
     * @param lastMintTimestamp Timestamp of last mint
     * @return valid True if mint is genesis-compliant
     * @return reason Human-readable reason if invalid
     */
    function validateTokenMint(
        uint256 currentSupply,
        uint256 mintAmount,
        uint256 lastMintTimestamp
    ) external view override returns (bool valid, string memory reason) {
        // Check: Would not exceed max total supply
        if (currentSupply + mintAmount > MAX_TOTAL_SUPPLY) {
            return (false, "Would exceed max total supply (1 billion)");
        }
        
        // Check: Annual inflation rate within bounds
        uint256 timeSinceLastMint = block.timestamp - lastMintTimestamp;
        if (timeSinceLastMint < 365 days) {
            // Pro-rate the inflation check
            uint256 maxAnnualInflation = (currentSupply * MAX_INFLATION_RATE_BPS) / 10000;
            uint256 maxProRatedMint = (maxAnnualInflation * timeSinceLastMint) / 365 days;
            
            if (mintAmount > maxProRatedMint) {
                return (false, "Exceeds maximum inflation rate (5% per year)");
            }
        }
        
        return (true, "");
    }
    
    /**
     * @notice Validates emergency pause action
     * @param pauseDuration Duration of proposed pause (in seconds)
     * @param councilSigners Number of council signers
     * @return valid True if pause action is genesis-compliant
     * @return reason Human-readable reason if invalid
     */
    function validateEmergencyPause(
        uint256 pauseDuration,
        uint256 councilSigners
    ) external pure override returns (bool valid, string memory reason) {
        if (pauseDuration > EMERGENCY_PAUSE_DURATION) {
            return (false, "Pause duration exceeds maximum (7 days)");
        }
        
        if (councilSigners < EMERGENCY_COUNCIL_SIZE_MIN) {
            return (false, "Insufficient council signers (minimum 3)");
        }
        
        if (councilSigners > EMERGENCY_COUNCIL_SIZE_MAX) {
            return (false, "Too many council signers (maximum 9)");
        }
        
        return (true, "");
    }
    
    /**
     * @notice Validates chain ID for cross-chain operations
     * @param chainId Chain ID to validate
     * @return valid True if chain ID is recognized
     */
    function validateChainId(uint256 chainId) external pure override returns (bool valid) {
        return chainId == GENESIS_CHAIN_ID ||
               chainId == BASE_CHAIN_ID ||
               chainId == OPTIMISM_CHAIN_ID ||
               chainId == ARBITRUM_CHAIN_ID;
    }
    
    /**
     * @notice Gets the genesis hash (immutable protocol reference)
     * @return bytes32 The genesis root hash
     */
    function genesisHash() external view override returns (bytes32) {
        return GENESIS_ROOT_HASH;
    }
    
    /**
     * @notice Gets the constitutional hash (immutable reference to founding documents)
     * @return bytes32 The constitutional hash
     */
    function constitutionalHash() external pure override returns (bytes32) {
        return CONSTITUTIONAL_HASH;
    }
    
    /**
     * @notice Verifies if address is a canonical subsystem
     * @param subsystem Address to check
     * @return valid True if address is in the subsystem registry
     */
    function isCanonicalSubsystem(address subsystem) external view override returns (bool valid) {
        return subsystem == TREASURY_ADDRESS ||
               subsystem == TIMELOCK_ADDRESS ||
               subsystem == GOVERNOR_ADDRESS ||
               subsystem == TOKEN_ADDRESS ||
               subsystem == ADAM_HOST_ADDRESS ||
               subsystem == ADAM_REGISTRY_ADDRESS ||
               subsystem == AI_GENESIS_ADDRESS ||
               subsystem == AI_REGISTRY_ADDRESS ||
               subsystem == AI_SBT_ADDRESS ||
               subsystem == L1_L2_MESSENGER_ADDRESS ||
               subsystem == L2_GENESIS_VERIFIER_ADDRESS ||
               subsystem == EMERGENCY_COUNCIL_ADDRESS;
    }
}
