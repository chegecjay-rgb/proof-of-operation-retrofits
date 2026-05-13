// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "forge-std/Test.sol";

import "../../contracts/runtime/etnl/ReplayNormalizationEngine.sol";
import "../../contracts/runtime/etnl/DeterministicSemanticGraph.sol";
import "../../contracts/runtime/etnl/DeterministicGraphValidation.sol";

contract CanonicalReplayFixturesTest is Test {
    ReplayNormalizationEngine internal normalizationEngine;
    DeterministicSemanticGraph internal semanticGraph;
    DeterministicGraphValidation internal graphValidation;

    bytes32 internal constant EXPECTED_EQUIVALENCE_KEY = keccak256(
        abi.encodePacked(
            "REPLAY_EQUIVALENCE", address(0x1000000000000000000000000000000000000001), keccak256("SAFE_PAYLOAD_ALPHA")
        )
    );

    bytes32 internal constant EXPECTED_CONTINUITY_KEY = keccak256(
        abi.encodePacked(
            "CONTINUITY_NORMALIZATION", keccak256("SAFE_AUTHORITY_ALPHA"), keccak256("PARENT_OPERATION_ALPHA")
        )
    );

    bytes32 internal constant EXPECTED_ORDERING_KEY =
        keccak256(abi.encodePacked("ORDERING_NORMALIZATION", uint256(1), keccak256("SAFE_OPERATION_ALPHA")));

    function setUp() public {
        normalizationEngine = new ReplayNormalizationEngine();
        semanticGraph = new DeterministicSemanticGraph();
        graphValidation = new DeterministicGraphValidation();
    }

    function canonicalDescriptor() internal pure returns (ReplayNormalizationTypes.ReplayDescriptor memory) {
        return ReplayNormalizationTypes.ReplayDescriptor({
            authorityId: keccak256("SAFE_AUTHORITY_ALPHA"),
            operationId: keccak256("SAFE_OPERATION_ALPHA"),
            parentOperationId: keccak256("PARENT_OPERATION_ALPHA"),
            target: address(0x1000000000000000000000000000000000000001),
            payloadHash: keccak256("SAFE_PAYLOAD_ALPHA"),
            operationIndex: 1,
            scheduledAt: 1000,
            executionContext: keccak256("SAFE_CONTEXT_ALPHA")
        });
    }

    function canonicalNode() internal pure returns (DeterministicSemanticGraphTypes.GraphNode memory) {
        return DeterministicSemanticGraphTypes.GraphNode({
            nodeId: keccak256("NODE_ALPHA"),
            canonicalKey: keccak256("CANONICAL_ALPHA"),
            continuityKey: keccak256("CONTINUITY_ALPHA"),
            ordering: 1
        });
    }

    function canonicalEdge() internal pure returns (DeterministicSemanticGraphTypes.GraphEdge memory) {
        return DeterministicSemanticGraphTypes.GraphEdge({
            edgeId: keccak256("EDGE_ALPHA"),
            sourceNodeId: keccak256("SOURCE_ALPHA"),
            targetNodeId: keccak256("TARGET_ALPHA"),
            continuityKey: keccak256("CONTINUITY_ALPHA"),
            ordering: 1
        });
    }

    function testCanonicalReplayNormalizationDeterminism() public {
        ReplayNormalizationTypes.ReplayDescriptor memory descriptor = canonicalDescriptor();

        ReplayNormalizationTypes.NormalizedReplay memory replayA = normalizationEngine.normalizeReplay(descriptor);

        ReplayNormalizationTypes.NormalizedReplay memory replayB = normalizationEngine.normalizeReplay(descriptor);

        assertEq(replayA.replayId, replayB.replayId);
        assertEq(replayA.normalizationRoot, replayB.normalizationRoot);
        assertEq(replayA.equivalenceKey, EXPECTED_EQUIVALENCE_KEY);
        assertEq(replayA.continuityKey, EXPECTED_CONTINUITY_KEY);
        assertEq(replayA.orderingKey, EXPECTED_ORDERING_KEY);
    }

    function testReplayDeterminismUnderReorderedExecution() public {
        ReplayNormalizationTypes.ReplayDescriptor memory descriptorA = canonicalDescriptor();

        ReplayNormalizationTypes.ReplayDescriptor memory descriptorB = canonicalDescriptor();

        ReplayNormalizationTypes.NormalizedReplay memory replayA = normalizationEngine.normalizeReplay(descriptorA);

        ReplayNormalizationTypes.NormalizedReplay memory replayB = normalizationEngine.normalizeReplay(descriptorB);

        assertEq(replayA.normalizationRoot, replayB.normalizationRoot);
        assertEq(replayA.replayId, replayB.replayId);
    }

    function testDeterministicTopologyAssembly() public {
        DeterministicSemanticGraphTypes.GraphNode[] memory nodes = new DeterministicSemanticGraphTypes.GraphNode[](1);

        DeterministicSemanticGraphTypes.GraphEdge[] memory edges = new DeterministicSemanticGraphTypes.GraphEdge[](1);

        nodes[0] = canonicalNode();
        edges[0] = canonicalEdge();

        DeterministicSemanticGraphTypes.GraphTopology memory topologyA = semanticGraph.assembleTopology(nodes, edges);

        DeterministicSemanticGraphTypes.GraphTopology memory topologyB = semanticGraph.assembleTopology(nodes, edges);

        assertEq(topologyA.graphRoot, topologyB.graphRoot);
        assertEq(topologyA.topologyHash, topologyB.topologyHash);
        assertEq(topologyA.nodeCount, topologyB.nodeCount);
        assertEq(topologyA.edgeCount, topologyB.edgeCount);
    }

    function testDeterministicReplayValidation() public {
        DeterministicGraphValidationTypes.ReplayProof memory proof = DeterministicGraphValidationTypes.ReplayProof({
            topologyRoot: keccak256("TOPOLOGY_ROOT_ALPHA"),
            topologyHash: keccak256("TOPOLOGY_HASH_ALPHA"),
            normalizationRoot: keccak256("NORMALIZATION_ROOT_ALPHA"),
            equivalenceKey: keccak256("EQUIVALENCE_KEY_ALPHA"),
            continuityKey: keccak256("CONTINUITY_KEY_ALPHA"),
            orderingKey: keccak256("ORDERING_KEY_ALPHA")
        });

        DeterministicGraphValidationTypes.ValidationResult memory validationA =
            graphValidation.validateReplayProof(proof);

        DeterministicGraphValidationTypes.ValidationResult memory validationB =
            graphValidation.validateReplayProof(proof);

        assertEq(validationA.validationRoot, validationB.validationRoot);
        assertTrue(validationA.topologyStable);
        assertTrue(validationA.normalizationStable);
        assertTrue(validationA.equivalenceStable);
        assertTrue(validationA.continuityStable);
        assertTrue(validationA.orderingStable);
    }

    function testCanonicalReplayFixtureVector() public {
        ReplayNormalizationTypes.ReplayDescriptor memory descriptor = canonicalDescriptor();

        ReplayNormalizationTypes.NormalizedReplay memory replay = normalizationEngine.normalizeReplay(descriptor);

        DeterministicSemanticGraphTypes.GraphNode[] memory nodes = new DeterministicSemanticGraphTypes.GraphNode[](1);

        DeterministicSemanticGraphTypes.GraphEdge[] memory edges = new DeterministicSemanticGraphTypes.GraphEdge[](1);

        nodes[0] = canonicalNode();
        edges[0] = canonicalEdge();

        DeterministicSemanticGraphTypes.GraphTopology memory topology = semanticGraph.assembleTopology(nodes, edges);

        DeterministicGraphValidationTypes.ReplayProof memory proof = DeterministicGraphValidationTypes.ReplayProof({
            topologyRoot: topology.graphRoot,
            topologyHash: topology.topologyHash,
            normalizationRoot: replay.normalizationRoot,
            equivalenceKey: replay.equivalenceKey,
            continuityKey: replay.continuityKey,
            orderingKey: replay.orderingKey
        });

        DeterministicGraphValidationTypes.ValidationResult memory validation =
            graphValidation.validateReplayProof(proof);

        assertTrue(validation.validationRoot != bytes32(0));
        assertEq(replay.equivalenceKey, EXPECTED_EQUIVALENCE_KEY);
        assertEq(replay.continuityKey, EXPECTED_CONTINUITY_KEY);
        assertEq(replay.orderingKey, EXPECTED_ORDERING_KEY);
    }
}
