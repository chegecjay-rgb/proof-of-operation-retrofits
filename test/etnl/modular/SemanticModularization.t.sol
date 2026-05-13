// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "forge-std/Test.sol";
import "../../../contracts/runtime/etnl/modular/ConvergenceProfiles.sol";
import "../../../contracts/runtime/etnl/modular/TopologyMutationLayer.sol";
import "../../../contracts/runtime/etnl/modular/NormalizationLayer.sol";
import "../../../contracts/runtime/etnl/modular/AssertionDomains.sol";

contract SemanticModularizationTest is Test {
    function testConvergenceProfileIsolation() public pure {
        ConvergenceProfiles.ProfileConfiguration memory config =
            ConvergenceProfiles.profileConfiguration(ConvergenceProfiles.ConvergenceProfile.SCP_FRAGMENTED_DISCLOSURE);

        assertTrue(config.fragmentedDisclosure);
    }

    function testNormalizationLayerDeterminism() public pure {
        NormalizationLayer.NormalizationVector memory vector = NormalizationLayer.NormalizationVector({
            equivalenceKey: keccak256("EQ"), continuityKey: keccak256("CONTINUITY"), topologyHash: keccak256("TOPOLOGY")
        });

        bytes32 rootA = NormalizationLayer.normalizationRoot(vector);
        bytes32 rootB = NormalizationLayer.normalizationRoot(vector);

        AssertionDomains.assertNormalizationEquivalence(rootA, rootB);
    }

    function testTopologyMutationIsolation() public pure {
        TopologyMutationLayer.TopologyVector[] memory vectors = new TopologyMutationLayer.TopologyVector[](2);

        vectors[0] = TopologyMutationLayer.TopologyVector({
            nodeId: keccak256("NODE_A"), parentNodeId: bytes32(0), continuityKey: keccak256("CONTINUITY_A"), ordering: 1
        });

        vectors[1] = TopologyMutationLayer.TopologyVector({
            nodeId: keccak256("NODE_B"),
            parentNodeId: keccak256("NODE_A"),
            continuityKey: keccak256("CONTINUITY_B"),
            ordering: 2
        });

        TopologyMutationLayer.TopologyVector[] memory reordered = TopologyMutationLayer.reorderTopology(vectors);

        assertEq(reordered.length, 2);
    }
}
