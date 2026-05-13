// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

library NormalizationLayer {
    struct NormalizationVector {
        bytes32 equivalenceKey;
        bytes32 continuityKey;
        bytes32 topologyHash;
    }

    function normalizationRoot(NormalizationVector memory vector) internal pure returns (bytes32) {
        return keccak256(
            abi.encodePacked("NORMALIZATION_ROOT", vector.equivalenceKey, vector.continuityKey, vector.topologyHash)
        );
    }

    function equivalenceRoot(bytes32 target, bytes32 payload) internal pure returns (bytes32) {
        return keccak256(abi.encodePacked("REPLAY_EQUIVALENCE", target, payload));
    }
}
