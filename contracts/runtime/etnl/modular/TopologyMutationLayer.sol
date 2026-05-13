// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

library TopologyMutationLayer {
    struct TopologyVector {
        bytes32 nodeId;
        bytes32 parentNodeId;
        bytes32 continuityKey;
        uint256 ordering;
    }

    function fragmentTopology(TopologyVector[] memory vectors) internal pure returns (TopologyVector[] memory mutated) {
        mutated = vectors;

        for (uint256 i = 0; i < mutated.length; i++) {
            mutated[i].ordering = uint256(keccak256(abi.encodePacked(mutated[i].nodeId, mutated[i].ordering, i)));
        }
    }

    function reorderTopology(TopologyVector[] memory vectors) internal pure returns (TopologyVector[] memory mutated) {
        mutated = vectors;

        uint256 length = mutated.length;

        for (uint256 i = 0; i < length / 2; i++) {
            TopologyVector memory temp = mutated[i];
            mutated[i] = mutated[length - 1 - i];
            mutated[length - 1 - i] = temp;
        }
    }
}
