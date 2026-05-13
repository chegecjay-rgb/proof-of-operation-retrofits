// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

library DeterministicExecutionContext {
    struct ExecutionContext {
        bytes32 executionId;
        bytes32 priorArtifactRoot;
        bytes32 currentArtifactRoot;
        bytes32 lineageRoot;
        uint256 executionIndex;
        bool deterministic;
    }

    function contextHash(ExecutionContext memory context) internal pure returns (bytes32) {
        return keccak256(
            abi.encode(
                context.executionId,
                context.priorArtifactRoot,
                context.currentArtifactRoot,
                context.lineageRoot,
                context.executionIndex,
                context.deterministic
            )
        );
    }
}
