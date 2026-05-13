// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

library CanonicalStageGraph {
    struct StageNode {
        bytes32 stageId;
        bytes32 artifactRoot;
        uint256 executionIndex;
        bool deterministic;
    }

    struct StageTransition {
        bytes32 sourceStage;
        bytes32 targetStage;
        bytes32 transitionHash;
    }

    function stageNodeHash(StageNode memory node) internal pure returns (bytes32) {
        return keccak256(abi.encode(node.stageId, node.artifactRoot, node.executionIndex, node.deterministic));
    }

    function transitionHash(StageTransition memory transition) internal pure returns (bytes32) {
        return keccak256(abi.encode(transition.sourceStage, transition.targetStage, transition.transitionHash));
    }
}
