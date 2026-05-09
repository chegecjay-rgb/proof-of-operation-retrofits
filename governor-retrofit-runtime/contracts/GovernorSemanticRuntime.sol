// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

abstract contract GovernorSemanticRuntime {
    event ProofOfOperation(
        bytes32 indexed operationId,
        bytes32 indexed systemId,
        address indexed executor,
        address target,
        uint256 value,
        bytes32 payloadHash,
        bytes32 parentOperationId,
        uint8 executionContext,
        uint16 operationIndex,
        uint16 operationCount
    );

    function _generateParentOperationId(
        bytes32 systemId,
        address executor,
        bytes32 proposalId
    ) internal pure returns (bytes32) {
        return keccak256(
            abi.encode(
                systemId,
                executor,
                proposalId
            )
        );
    }

    function _generateOperationId(
        bytes32 parentOperationId,
        uint16 operationIndex,
        address target,
        bytes32 payloadHash
    ) internal pure returns (bytes32) {
        return keccak256(
            abi.encode(
                parentOperationId,
                operationIndex,
                target,
                payloadHash
            )
        );
    }

    function _normalizePayloadHash(
        bytes memory payload
    ) internal pure returns (bytes32) {
        return keccak256(payload);
    }

    function _emitProofOfOperation(
        bytes32 systemId,
        address executor,
        address target,
        uint256 value,
        bytes memory payload,
        bytes32 parentOperationId,
        uint8 executionContext,
        uint16 operationIndex,
        uint16 operationCount
    ) internal {
        bytes32 payloadHash = _normalizePayloadHash(payload);

        bytes32 operationId = _generateOperationId(
            parentOperationId,
            operationIndex,
            target,
            payloadHash
        );

        emit ProofOfOperation(
            operationId,
            systemId,
            executor,
            target,
            value,
            payloadHash,
            parentOperationId,
            executionContext,
            operationIndex,
            operationCount
        );
    }
}
