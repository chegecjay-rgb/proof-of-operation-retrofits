pragma solidity ^0.8.20;

abstract contract SafeSemanticAdapter {
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

    function _deriveParentOperationId(
        bytes32 safeTxHash,
        uint256 nonce
    ) internal pure returns (bytes32) {
        return keccak256(
            abi.encodePacked(
                safeTxHash,
                nonce
            )
        );
    }

    function _derivePayloadHash(
        bytes memory payload
    ) internal pure returns (bytes32) {
        return keccak256(payload);
    }

    function _deriveOperationId(
        address target,
        bytes32 payloadHash,
        uint16 operationIndex,
        bytes32 parentOperationId
    ) internal pure returns (bytes32) {
        return keccak256(
            abi.encodePacked(
                target,
                payloadHash,
                operationIndex,
                parentOperationId
            )
        );
    }

    function _emitSemanticOperation(
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
        bytes32 payloadHash = _derivePayloadHash(payload);

        bytes32 operationId = _deriveOperationId(
            target,
            payloadHash,
            operationIndex,
            parentOperationId
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
