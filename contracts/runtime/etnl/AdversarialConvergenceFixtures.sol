// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

library AdversarialConvergenceFixtures {
    struct ReplayMutationVector {
        bytes32 replayId;
        bytes32 continuityRoot;
        bytes32 validationRoot;
        bytes32 topologyHash;
        uint256 ordering;
        address origin;
    }

    function reorderReplayInsertion(ReplayMutationVector[] memory vectors)
        internal
        pure
        returns (ReplayMutationVector[] memory mutated)
    {
        mutated = vectors;

        uint256 length = mutated.length;

        for (uint256 i = 0; i < length / 2; i++) {
            ReplayMutationVector memory temp = mutated[i];
            mutated[i] = mutated[length - 1 - i];
            mutated[length - 1 - i] = temp;
        }
    }

    function duplicateReplayOrdering(ReplayMutationVector[] memory vectors)
        internal
        pure
        returns (ReplayMutationVector[] memory mutated)
    {
        uint256 length = vectors.length;

        mutated = new ReplayMutationVector[](length * 2);

        for (uint256 i = 0; i < length; i++) {
            mutated[i] = vectors[i];
            mutated[length + i] = vectors[i];
        }
    }

    function fragmentContinuityDisclosure(ReplayMutationVector[] memory vectors)
        internal
        pure
        returns (ReplayMutationVector[] memory mutated)
    {
        mutated = vectors;

        if (mutated.length > 0) {
            mutated[0].continuityRoot = bytes32(0);
        }
    }

    function perturbReplayOrigins(ReplayMutationVector[] memory vectors)
        internal
        pure
        returns (ReplayMutationVector[] memory mutated)
    {
        mutated = vectors;

        for (uint256 i = 0; i < mutated.length; i++) {
            mutated[i].origin =
                address(uint160(uint256(keccak256(abi.encode(mutated[i].origin, mutated[i].replayId, i)))));
        }
    }

    function fragmentTopology(ReplayMutationVector[] memory vectors)
        internal
        pure
        returns (ReplayMutationVector[] memory mutated)
    {
        mutated = vectors;

        for (uint256 i = 0; i < mutated.length; i++) {
            mutated[i].ordering = uint256(keccak256(abi.encode(mutated[i].ordering, mutated[i].topologyHash, i)));
        }
    }
}
