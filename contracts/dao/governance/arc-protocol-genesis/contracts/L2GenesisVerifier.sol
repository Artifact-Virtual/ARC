// SPDX-License-Identifier: AGPL-3.0
pragma solidity ^0.8.26;

/**
 * @title L2GenesisVerifier
 * @notice Cross-chain genesis verification contract for L2 deployments (Base, Optimism, Arbitrum)
 * @dev Stores L1 genesis hash and validates operations against L1 constitutional rules
 * 
 * This contract acts as a lightweight verification layer on L2, allowing L2 contracts
 * to validate operations against the L1 genesis without requiring full L1 state access.
 * 
 * Security Model:
 * - Genesis hash immutably set at deployment
 * - No owner (cannot be manipulated)
 * - No upgrades (permanent verification)
 * - Pure validation functions (deterministic)
 */
contract L2GenesisVerifier {
    // ============================================
    // IMMUTABLE L1 REFERENCE
    // ============================================
    
    bytes32 public immutable L1_GENESIS_HASH;
    address public immutable L1_GENESIS_ADDRESS;
    uint256 public immutable L1_CHAIN_ID;
    uint256 public immutable L1_GENESIS_BLOCK;
    
    // L2 Deployment Info
    uint256 public immutable L2_CHAIN_ID;
    uint256 public immutable L2_DEPLOYMENT_BLOCK;
    uint256 public immutable L2_DEPLOYMENT_TIMESTAMP;
    
    // ============================================
    // CONSTANTS (Mirror from L1 Genesis)
    // ============================================
    
    uint256 public constant MAX_TREASURY_WITHDRAWAL_BPS = 1000; // 10%
    uint256 public constant MIN_TREASURY_RESERVE_BPS = 2000; // 20%
    uint256 public constant MAX_DAILY_TREASURY_SPEND_BPS = 500; // 5%
    
    uint256 public constant MIN_PROPOSAL_THRESHOLD_BPS = 10; // 0.1%
    uint256 public constant MAX_PROPOSAL_THRESHOLD_BPS = 500; // 5%
    uint256 public constant MIN_QUORUM_BPS = 400; // 4%
    uint256 public constant MAX_QUORUM_BPS = 2000; // 20%
    uint256 public constant MIN_VOTING_PERIOD = 1 days;
    uint256 public constant MAX_VOTING_PERIOD = 30 days;
    
    uint256 public constant MAX_TOTAL_SUPPLY = 1_000_000_000 * 1e18; // 1B
    uint256 public constant MAX_INFLATION_RATE_BPS = 500; // 5% per year
    
    uint256 public constant EMERGENCY_PAUSE_DURATION = 7 days;
    
    // ============================================
    // CONSTRUCTOR
    // ============================================
    
    /**
     * @notice Deploys the L2 verifier with L1 genesis reference
     * @param _l1GenesisHash Genesis root hash from L1
     * @param _l1GenesisAddress Address of L1 genesis contract
     * @param _l1ChainId L1 chain ID (should be 1 for Ethereum mainnet)
     * @param _l1GenesisBlock L1 genesis deployment block
     */
    constructor(
        bytes32 _l1GenesisHash,
        address _l1GenesisAddress,
        uint256 _l1ChainId,
        uint256 _l1GenesisBlock
    ) {
        require(_l1GenesisHash != bytes32(0), "Invalid L1 genesis hash");
        require(_l1GenesisAddress != address(0), "Invalid L1 genesis address");
        require(_l1ChainId == 1, "L1 must be Ethereum mainnet");
        
        L1_GENESIS_HASH = _l1GenesisHash;
        L1_GENESIS_ADDRESS = _l1GenesisAddress;
        L1_CHAIN_ID = _l1ChainId;
        L1_GENESIS_BLOCK = _l1GenesisBlock;
        
        L2_CHAIN_ID = block.chainid;
        L2_DEPLOYMENT_BLOCK = block.number;
        L2_DEPLOYMENT_TIMESTAMP = block.timestamp;
    }
    
    // ============================================
    // VALIDATION FUNCTIONS (Mirror from L1)
    // ============================================
    
    /**
     * @notice Validates treasury withdrawal (L2 mirror of L1 logic)
     */
    function validateTreasuryWithdrawal(
        uint256 amount,
        uint256 treasuryBalance,
        uint256 lastWithdrawalTimestamp,
        uint256 dailySpentAmount
    ) external view returns (bool valid, string memory reason) {
        uint256 maxAmount = (treasuryBalance * MAX_TREASURY_WITHDRAWAL_BPS) / 10000;
        if (amount > maxAmount) {
            return (false, "Exceeds max withdrawal per proposal (10%)");
        }
        
        uint256 minReserve = (treasuryBalance * MIN_TREASURY_RESERVE_BPS) / 10000;
        if (treasuryBalance - amount < minReserve) {
            return (false, "Would violate minimum reserve requirement (20%)");
        }
        
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
     * @notice Validates governance parameter (L2 mirror of L1 logic)
     */
    function validateGovernanceParameter(
        bytes32 paramName,
        uint256 newValue
    ) external view returns (bool valid, string memory reason) {
        if (paramName == keccak256("proposalThreshold")) {
            if (newValue < MIN_PROPOSAL_THRESHOLD_BPS || newValue > MAX_PROPOSAL_THRESHOLD_BPS) {
                return (false, "Proposal threshold out of bounds");
            }
            return (true, "");
        }
        
        if (paramName == keccak256("quorum")) {
            if (newValue < MIN_QUORUM_BPS || newValue > MAX_QUORUM_BPS) {
                return (false, "Quorum out of bounds");
            }
            return (true, "");
        }
        
        if (paramName == keccak256("votingPeriod")) {
            if (newValue < MIN_VOTING_PERIOD || newValue > MAX_VOTING_PERIOD) {
                return (false, "Voting period out of bounds");
            }
            return (true, "");
        }
        
        return (false, "Unknown parameter");
    }
    
    /**
     * @notice Validates token mint (L2 mirror of L1 logic)
     */
    function validateTokenMint(
        uint256 currentSupply,
        uint256 mintAmount,
        uint256 lastMintTimestamp
    ) external view returns (bool valid, string memory reason) {
        if (currentSupply + mintAmount > MAX_TOTAL_SUPPLY) {
            return (false, "Would exceed max total supply");
        }
        
        uint256 timeSinceLastMint = block.timestamp - lastMintTimestamp;
        if (timeSinceLastMint < 365 days) {
            uint256 maxAnnualInflation = (currentSupply * MAX_INFLATION_RATE_BPS) / 10000;
            uint256 maxProRatedMint = (maxAnnualInflation * timeSinceLastMint) / 365 days;
            
            if (mintAmount > maxProRatedMint) {
                return (false, "Exceeds maximum inflation rate");
            }
        }
        
        return (true, "");
    }
    
    /**
     * @notice Returns the L1 genesis hash for verification
     */
    function genesisHash() external view returns (bytes32) {
        return L1_GENESIS_HASH;
    }
    
    /**
     * @notice Verifies that a given hash matches the L1 genesis
     */
    function verifyGenesisHash(bytes32 providedHash) external view returns (bool) {
        return providedHash == L1_GENESIS_HASH;
    }
}
