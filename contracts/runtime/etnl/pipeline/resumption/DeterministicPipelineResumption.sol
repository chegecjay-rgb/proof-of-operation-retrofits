// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "../state/PipelineStateTransition.sol";

library DeterministicPipelineResumption {
    function resume(
        PipelineStateTransition.PipelineState memory priorState,
        bytes32 resumedStage,
        bytes32 resumedArtifact
    ) internal pure returns (PipelineStateTransition.PipelineState memory) {
        return PipelineStateTransition.transition(priorState, resumedStage, resumedArtifact);
    }
}
