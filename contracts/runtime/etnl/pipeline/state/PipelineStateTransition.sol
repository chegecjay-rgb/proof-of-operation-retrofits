// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

library PipelineStateTransition {
    struct PipelineState {
        bytes32 currentStage;
        bytes32 artifactRoot;
        uint256 executionIndex;
        bool deterministic;
    }

    function transition(PipelineState memory previousState, bytes32 nextStage, bytes32 nextArtifactRoot)
        internal
        pure
        returns (PipelineState memory)
    {
        return PipelineState({
            currentStage: nextStage,
            artifactRoot: keccak256(abi.encode(previousState.artifactRoot, nextArtifactRoot, nextStage)),
            executionIndex: previousState.executionIndex + 1,
            deterministic: true
        });
    }
}
