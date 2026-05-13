// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "../context/DeterministicExecutionContext.sol";

library ExecutionPropagationRuntime {
    function propagate(
        DeterministicExecutionContext.ExecutionContext memory previousContext,
        bytes32 nextArtifactRoot,
        bytes32 nextLineageRoot
    ) internal pure returns (DeterministicExecutionContext.ExecutionContext memory) {
        return DeterministicExecutionContext.ExecutionContext({
            executionId: keccak256(abi.encode(previousContext.executionId, nextArtifactRoot)),
            priorArtifactRoot: previousContext.currentArtifactRoot,
            currentArtifactRoot: nextArtifactRoot,
            lineageRoot: nextLineageRoot,
            executionIndex: previousContext.executionIndex + 1,
            deterministic: true
        });
    }
}
