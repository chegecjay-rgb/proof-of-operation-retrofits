// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "../artifacts/CanonicalPipelineArtifacts.sol";
import "../stages/CanonicalNormalizationStage.sol";
import "../stages/CanonicalContinuityStage.sol";

contract DeterministicPipelineExecutor {
    struct ExecutionResult {
        CanonicalPipelineArtifacts.NormalizationArtifact normalizationArtifact;
        CanonicalPipelineArtifacts.ContinuityArtifact continuityArtifact;
    }

    function execute(bytes32 equivalenceKey, bytes32 continuityKey, bytes32 orderingKey)
        external
        pure
        returns (ExecutionResult memory result)
    {
        result.normalizationArtifact =
            CanonicalNormalizationStage.buildNormalizationArtifact(equivalenceKey, continuityKey, orderingKey);

        result.continuityArtifact = CanonicalContinuityStage.buildContinuityArtifact(result.normalizationArtifact);
    }
}
