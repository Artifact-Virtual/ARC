// SPDX-License-Identifier: AGPL-3.0
pragma solidity ^0.8.21;

import "../dao/governance/interfaces/IEligibility.sol";

/**
 * @title MockEligibility - Mock contract for testing
 * @dev Updated to match IEligibility interface exactly.
 */
contract MockEligibility is IEligibility {
    mapping(address => bool) private _eligible;
    mapping(address => uint256) private _votingPower;
    uint256 private _totalWeight;

    function setEligible(address account, bool eligible) external {
        _eligible[account] = eligible;
    }

    function setVotingPower(address account, uint256 power) external {
        _votingPower[account] = power;
    }

    function setTotalWeight(uint256 weight) external {
        _totalWeight = weight;
    }

    function isEligible(address who, uint256 /*topicMask*/) external view override returns (bool) {
        return _eligible[who];
    }

    function weightOf(address who, uint256 /*topicMask*/) external view override returns (uint256) {
        return _votingPower[who];
    }

    function totalWeight(uint256 /*topicMask*/) external view override returns (uint256) {
        return _totalWeight;
    }

    // Returns (uint256[] memory components, uint256 total) — matches IEligibility
    function getEligibilityComponents(address who, uint256 /*topicMask*/) external view override returns (
        uint256[] memory components,
        uint256 total
    ) {
        components = new uint256[](1);
        components[0] = _votingPower[who];
        total = _totalWeight;
    }

    function hasQuorum(uint256 /*topicMask*/, uint256 /*votes*/) external pure override returns (bool) {
        return true;
    }

    function hasSupermajority(uint256 /*topicMask*/, uint256 /*votes*/) external pure override returns (bool) {
        return true;
    }

    // Returns (quorumWad, supermajorityWad, votingDays, timelockDays) — matches IEligibility
    function getTopicConfig(uint256 /*topicId*/) external pure override returns (
        uint256 quorumWad,
        uint256 supermajorityWad,
        uint256 votingDays,
        uint256 timelockDays
    ) {
        // 50% quorum, 67% supermajority, 7 day voting, 2 day timelock
        return (0.5e18, 0.67e18, 7, 2);
    }
}
