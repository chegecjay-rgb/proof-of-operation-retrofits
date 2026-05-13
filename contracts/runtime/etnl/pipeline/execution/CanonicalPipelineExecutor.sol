// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "../artifacts/CanonicalPipelineArtifacts.sol";

import "../stages/CanonicalNormalizationStage.sol";
import "../stages/CanonicalContinuityStage.sol";

import "../stages/topology/CanonicalTopologyStage.sol";
import "../stages/graph/CanonicalGraphStage.sol";

contract CanonicalPipelineExecutor {
    struct ExecutionResult {
        CanonicalPipelineArtifacts.NormalizationArtifact normalizationArtifact;
        CanonicalPipelineArtifacts.ContinuityArtifact continuityArtifact;
        CanonicalPipelineArtifacts.TopologyArtifact topologyArtifact;
        CanonicalPipelineArtifacts.GraphArtifact graphArtifact;
        CanonicalPipelineArtifacts.ValidationArtifact validationArtifact;
    }

    function execute(bytes32 equivalenceKey, bytes32 continuityKey, bytes32 orderingKey)
        external
        pure
        returns (ExecutionResult memory result)
    {
        result.normalizationArtifact =
            CanonicalNormalizationStage.buildNormalizationArtifact(equivalenceKey, continuityKey, orderingKey);

        result.continuityArtifact = CanonicalContinuityStage.buildContinuityArtifact(result.normalizationArtifact);

        result.topologyArtifact = CanonicalTopologyStage.buildTopologyArtifact(result.continuityArtifact);

        result.graphArtifact = CanonicalGraphStage.buildGraphArtifact(result.topologyArtifact);

        result.validationArtifact = CanonicalPipelineArtifacts.ValidationArtifact({
            validationRoot: keccak256(abi.encode(result.graphArtifact.graphRoot, result.topologyArtifact.topologyRoot)),
            normalizationValid: true,
            continuityValid: true,
            topologyValid: true,
            graphValid: result.graphArtifact.deterministic
        });
    }
}
