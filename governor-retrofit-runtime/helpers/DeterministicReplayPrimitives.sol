// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

library DeterministicReplayPrimitives {
    function normalizePayload(
        bytes memory payload
    ) internal pure returns (bytes32) {
        return keccak256(payload);
    }

    function normalizeEquivalence(
        address target,
        bytes memory payload
    ) internal pure returns (bytes32) {
        return keccak256(
            abi.encode(
                target,
                keccak256(payload)
            )
        );
    }

    function computeOrderedOperation(
        bytes32 parentOperationId,
        uint16 operationIndex,
        uint16 operationCount
    ) internal pure returns (bytes32) {
        return keccak256(
            abi.encode(
                parentOperationId,
                operationIndex,
                operationCount
            )
        );
    }
}
