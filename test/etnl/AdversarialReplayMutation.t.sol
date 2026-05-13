// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {Test} from "forge-std/Test.sol";
import {ReplayNormalizationEngine} from "../../contracts/runtime/etnl/ReplayNormalizationEngine.sol";
import {DeterministicSemanticGraph} from "../../contracts/runtime/etnl/DeterministicSemanticGraph.sol";
import {DeterministicGraphValidation} from "../../contracts/runtime/etnl/DeterministicGraphValidation.sol";

contract AdversarialReplayMutationTest is Test {
    ReplayNormalizationEngine internal normalizationEngine;
    DeterministicSemanticGraph internal semanticGraph;
    DeterministicGraphValidation internal graphValidation;

    function setUp() public {
        normalizationEngine = new ReplayNormalizationEngine();
        semanticGraph = new DeterministicSemanticGraph();
        graphValidation = new DeterministicGraphValidation();
    }

    function _normalizedReplay(
        bytes32 authorityId,
        bytes32 parentOperationId,
        bytes32 operationId,
        uint256 operationIndex,
        address target,
        bytes32 payloadHash
    )
        internal
        view
        returns (bytes32 equivalenceKey, bytes32 continuityKey, bytes32 orderingKey, bytes32 normalizationRoot)
    {
        equivalenceKey = normalizationEngine.replayEquivalenceKey(target, payloadHash);

        continuityKey = normalizationEngine.continuityNormalizationKey(authorityId, parentOperationId);

        orderingKey = normalizationEngine.orderingNormalizationKey(operationIndex, operationId);

        normalizationRoot = normalizationEngine.normalizationRoot(equivalenceKey, continuityKey, orderingKey);
    }

    function _validationRoot(
        bytes32 topologyRoot,
        bytes32 topologyHash,
        bytes32 normalizationRoot,
        bytes32 equivalenceKey,
        bytes32 continuityKey,
        bytes32 orderingKey
    ) internal view returns (bytes32) {
        bytes32 topologyValidation = graphValidation.topologyValidationKey(topologyRoot, topologyHash);

        bytes32 normalizationValidation = graphValidation.normalizationValidationKey(normalizationRoot);

        bytes32 equivalenceValidation = graphValidation.equivalenceValidationKey(equivalenceKey);

        bytes32 continuityValidation = graphValidation.continuityValidationKey(continuityKey);

        bytes32 orderingValidation = graphValidation.orderingValidationKey(orderingKey);

        return graphValidation.validationRoot(
            topologyValidation, normalizationValidation, equivalenceValidation, continuityValidation, orderingValidation
        );
    }

    function testDeterminismUnderRandomizedInsertionOrdering() public {
        (bytes32 eqA, bytes32 contA, bytes32 orderA, bytes32 rootA) = _normalizedReplay(
            keccak256("AUTHORITY_ALPHA"),
            keccak256("PARENT_ALPHA"),
            keccak256("OPERATION_ALPHA"),
            1,
            address(0x1001),
            keccak256("PAYLOAD_ALPHA")
        );

        (bytes32 eqB, bytes32 contB, bytes32 orderB, bytes32 rootB) = _normalizedReplay(
            keccak256("AUTHORITY_BETA"),
            keccak256("PARENT_BETA"),
            keccak256("OPERATION_BETA"),
            2,
            address(0x1002),
            keccak256("PAYLOAD_BETA")
        );

        bytes32[] memory nodesForward = new bytes32[](2);
        nodesForward[0] = rootA;
        nodesForward[1] = rootB;

        bytes32[] memory nodesReverse = new bytes32[](2);
        nodesReverse[0] = rootB;
        nodesReverse[1] = rootA;

        bytes32[] memory canonicalForward = new bytes32[](2);
        canonicalForward[0] = nodesForward[0] < nodesForward[1] ? nodesForward[0] : nodesForward[1];
        canonicalForward[1] = nodesForward[0] < nodesForward[1] ? nodesForward[1] : nodesForward[0];

        bytes32[] memory canonicalReverse = new bytes32[](2);
        canonicalReverse[0] = nodesReverse[0] < nodesReverse[1] ? nodesReverse[0] : nodesReverse[1];
        canonicalReverse[1] = nodesReverse[0] < nodesReverse[1] ? nodesReverse[1] : nodesReverse[0];

        bytes32 topologyRootForward = semanticGraph.graphRoot(canonicalForward, new bytes32[](0));

        bytes32 topologyRootReverse = semanticGraph.graphRoot(canonicalReverse, new bytes32[](0));

        assertEq(topologyRootForward, topologyRootReverse);

        bytes32 topologyHashForward = semanticGraph.topologyHash(topologyRootForward, 2, 0);

        bytes32 topologyHashReverse = semanticGraph.topologyHash(topologyRootReverse, 2, 0);

        assertEq(topologyHashForward, topologyHashReverse);

        bytes32 validationRootForward =
            _validationRoot(topologyRootForward, topologyHashForward, rootA, eqA, contA, orderA);

        bytes32 validationRootReverse =
            _validationRoot(topologyRootReverse, topologyHashReverse, rootA, eqA, contA, orderA);

        assertEq(validationRootForward, validationRootReverse);

        assertTrue(eqA != eqB);
        assertTrue(contA != contB);
        assertTrue(orderA != orderB);
    }

    function testDeterminismUnderFragmentedContinuityDisclosure() public {
        (bytes32 equivalenceKey, bytes32 continuityKeyA, bytes32 orderingKey, bytes32 normalizationRootA) = _normalizedReplay(
            keccak256("AUTHORITY_FRAGMENT"),
            keccak256("PARENT_FRAGMENT_ALPHA"),
            keccak256("OPERATION_FRAGMENT"),
            7,
            address(0x2001),
            keccak256("PAYLOAD_FRAGMENT")
        );

        (, bytes32 continuityKeyB,, bytes32 normalizationRootB) = _normalizedReplay(
            keccak256("AUTHORITY_FRAGMENT"),
            keccak256("PARENT_FRAGMENT_BETA"),
            keccak256("OPERATION_FRAGMENT"),
            7,
            address(0x2001),
            keccak256("PAYLOAD_FRAGMENT")
        );

        assertTrue(continuityKeyA != continuityKeyB);
        assertTrue(normalizationRootA != normalizationRootB);

        bytes32 validationA = _validationRoot(
            keccak256("TOPOLOGY_FRAGMENT"),
            keccak256("HASH_FRAGMENT"),
            normalizationRootA,
            equivalenceKey,
            continuityKeyA,
            orderingKey
        );

        bytes32 validationB = _validationRoot(
            keccak256("TOPOLOGY_FRAGMENT"),
            keccak256("HASH_FRAGMENT"),
            normalizationRootB,
            equivalenceKey,
            continuityKeyB,
            orderingKey
        );

        assertTrue(validationA != validationB);
    }

    function testDeterminismUnderReplayGraphMerge() public {
        (bytes32 eqA, bytes32 contA, bytes32 orderA, bytes32 rootA) = _normalizedReplay(
            keccak256("MERGE_AUTHORITY_ALPHA"),
            keccak256("MERGE_PARENT_ALPHA"),
            keccak256("MERGE_OPERATION_ALPHA"),
            10,
            address(0x3001),
            keccak256("MERGE_PAYLOAD_ALPHA")
        );

        (bytes32 eqB, bytes32 contB, bytes32 orderB, bytes32 rootB) = _normalizedReplay(
            keccak256("MERGE_AUTHORITY_BETA"),
            keccak256("MERGE_PARENT_BETA"),
            keccak256("MERGE_OPERATION_BETA"),
            11,
            address(0x3002),
            keccak256("MERGE_PAYLOAD_BETA")
        );

        bytes32[] memory mergedNodes = new bytes32[](2);
        mergedNodes[0] = rootA < rootB ? rootA : rootB;
        mergedNodes[1] = rootA < rootB ? rootB : rootA;

        bytes32 mergedTopologyRoot = semanticGraph.graphRoot(mergedNodes, new bytes32[](0));

        bytes32 mergedTopologyHash = semanticGraph.topologyHash(mergedTopologyRoot, 2, 0);

        bytes32 mergedValidationRootA =
            _validationRoot(mergedTopologyRoot, mergedTopologyHash, rootA, eqA, contA, orderA);

        bytes32 mergedValidationRootB =
            _validationRoot(mergedTopologyRoot, mergedTopologyHash, rootB, eqB, contB, orderB);

        assertTrue(mergedTopologyRoot != bytes32(0));
        assertTrue(mergedTopologyHash != bytes32(0));
        assertTrue(mergedValidationRootA != mergedValidationRootB);
    }

    function testEquivalenceCollisionResistance() public {
        bytes32 equivalenceAlpha =
            normalizationEngine.replayEquivalenceKey(address(0x4001), keccak256("COLLISION_ALPHA"));

        bytes32 equivalenceBeta = normalizationEngine.replayEquivalenceKey(address(0x4001), keccak256("COLLISION_BETA"));

        bytes32 equivalenceGamma =
            normalizationEngine.replayEquivalenceKey(address(0x4002), keccak256("COLLISION_ALPHA"));

        assertTrue(equivalenceAlpha != equivalenceBeta);
        assertTrue(equivalenceAlpha != equivalenceGamma);
        assertTrue(equivalenceBeta != equivalenceGamma);
    }

    function testDuplicateReplayDisclosureDeterminism() public {
        (bytes32 equivalenceKey, bytes32 continuityKey, bytes32 orderingKey, bytes32 normalizationRoot) = _normalizedReplay(
            keccak256("DUPLICATE_AUTHORITY"),
            keccak256("DUPLICATE_PARENT"),
            keccak256("DUPLICATE_OPERATION"),
            5,
            address(0x5001),
            keccak256("DUPLICATE_PAYLOAD")
        );

        (
            bytes32 equivalenceKeyDuplicate,
            bytes32 continuityKeyDuplicate,
            bytes32 orderingKeyDuplicate,
            bytes32 normalizationRootDuplicate
        ) = _normalizedReplay(
            keccak256("DUPLICATE_AUTHORITY"),
            keccak256("DUPLICATE_PARENT"),
            keccak256("DUPLICATE_OPERATION"),
            5,
            address(0x5001),
            keccak256("DUPLICATE_PAYLOAD")
        );

        assertEq(equivalenceKey, equivalenceKeyDuplicate);
        assertEq(continuityKey, continuityKeyDuplicate);
        assertEq(orderingKey, orderingKeyDuplicate);
        assertEq(normalizationRoot, normalizationRootDuplicate);
    }

    function testPartialTopologyDisclosureDeterminism() public {
        bytes32[] memory partialNodes = new bytes32[](1);
        partialNodes[0] = keccak256("PARTIAL_NODE_ALPHA");

        bytes32 topologyRootA = semanticGraph.graphRoot(partialNodes, new bytes32[](0));

        bytes32 topologyRootB = semanticGraph.graphRoot(partialNodes, new bytes32[](0));

        bytes32 topologyHashA = semanticGraph.topologyHash(topologyRootA, 1, 0);

        bytes32 topologyHashB = semanticGraph.topologyHash(topologyRootB, 1, 0);

        assertEq(topologyRootA, topologyRootB);
        assertEq(topologyHashA, topologyHashB);
    }
}
