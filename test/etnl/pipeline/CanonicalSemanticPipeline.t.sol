// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "forge-std/Test.sol";

import "../../../contracts/runtime/etnl/pipeline/artifacts/CanonicalPipelineArtifacts.sol";
import "../../../contracts/runtime/etnl/pipeline/normalization/CanonicalNormalizationPipeline.sol";
import "../../../contracts/runtime/etnl/pipeline/continuity/CanonicalContinuityPipeline.sol";
import "../../../contracts/runtime/etnl/pipeline/topology/DeterministicTopologyPipeline.sol";
import "../../../contracts/runtime/etnl/pipeline/graph/CanonicalGraphPipeline.sol";
import "../../../contracts/runtime/etnl/pipeline/validation/ValidationProofPipeline.sol";

contract CanonicalSemanticPipelineTest is Test {
    using CanonicalNormalizationPipeline for bytes32;
    using CanonicalContinuityPipeline for CanonicalPipelineArtifacts.NormalizationArtifact;
    using DeterministicTopologyPipeline for CanonicalPipelineArtifacts.ContinuityArtifact;
    using CanonicalGraphPipeline for CanonicalPipelineArtifacts.TopologyArtifact;

    function testCanonicalSemanticPipelineDeterminism() public {
        bytes32 equivalenceKey = keccak256("EQUIVALENCE");
        bytes32 continuityKey = keccak256("CONTINUITY");
        bytes32 orderingKey = keccak256("ORDERING");

        CanonicalPipelineArtifacts.NormalizationArtifact memory normalizationArtifact =
            CanonicalNormalizationPipeline.normalizeReplay(equivalenceKey, continuityKey, orderingKey);

        CanonicalPipelineArtifacts.ContinuityArtifact memory continuityArtifact =
            CanonicalContinuityPipeline.synthesizeContinuity(normalizationArtifact);

        CanonicalPipelineArtifacts.TopologyArtifact memory topologyArtifact =
            DeterministicTopologyPipeline.assembleTopology(continuityArtifact);

        CanonicalPipelineArtifacts.GraphArtifact memory graphArtifact =
            CanonicalGraphPipeline.constructGraph(topologyArtifact);

        CanonicalPipelineArtifacts.ValidationArtifact memory validationArtifact =
            ValidationProofPipeline.validatePipeline(
                normalizationArtifact, continuityArtifact, topologyArtifact, graphArtifact
            );

        assertTrue(validationArtifact.normalizationValid);
        assertTrue(validationArtifact.continuityValid);
        assertTrue(validationArtifact.topologyValid);
        assertTrue(validationArtifact.graphValid);

        assertTrue(graphArtifact.deterministic);

        assertEq(topologyArtifact.nodeCount, 1);
        assertEq(topologyArtifact.edgeCount, 1);

        assertTrue(validationArtifact.validationRoot != bytes32(0));
    }
}
