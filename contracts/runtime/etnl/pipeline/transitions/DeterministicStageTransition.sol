// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

library DeterministicStageTransition {
    function deriveTransition(bytes32 sourceStage, bytes32 targetStage, bytes32 artifactRoot)
        internal
        pure
        returns (bytes32)
    {
        return keccak256(abi.encode(sourceStage, targetStage, artifactRoot));
    }
}
