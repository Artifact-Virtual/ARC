// SPDX-License-Identifier: AGPL-3.0
pragma solidity ^0.8.26;

/**
 * @title IARCProtocolGenesis
 * @notice Interface for the immutable L1 constitutional anchor
 * @dev All ARC subsystems MUST call genesis validation before critical operations
 */
interface IARCProtocolGenesis {
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
    ) external view returns (bool valid, string memory reason);
    
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
    ) external view returns (bool valid, string memory reason);
    
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
    ) external view returns (bool valid, string memory reason);
    
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
    ) external view returns (bool valid, string memory reason);
    
    /**
     * @notice Validates chain ID for cross-chain operations
     * @param chainId Chain ID to validate
     * @return valid True if chain ID is recognized
     */
    function validateChainId(uint256 chainId) external pure returns (bool valid);
    
    /**
     * @notice Gets the genesis hash (immutable protocol reference)
     * @return bytes32 The genesis root hash
     */
    function genesisHash() external view returns (bytes32);
    
    /**
     * @notice Gets the constitutional hash (immutable reference to founding documents)
     * @return bytes32 The constitutional hash
     */
    function constitutionalHash() external pure returns (bytes32);
    
    /**
     * @notice Verifies if address is a canonical subsystem
     * @param subsystem Address to check
     * @return valid True if address is in the subsystem registry
     */
    function isCanonicalSubsystem(address subsystem) external view returns (bool valid);
}
