pragma solidity ^0.8.20;

abstract contract CanonicalMultiSendSemanticInjection {
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

    function _executeSemanticBatch(
        bytes32 systemId,
        bytes32 safeTxHash,
        uint256 nonce,
        address executor,
        address[] memory targets,
        uint256[] memory values,
        bytes[] memory payloads,
        uint8 executionContext
    ) internal {
        bytes32 parentOperationId = keccak256(
            abi.encodePacked(
                safeTxHash,
                nonce
            )
        );

        uint16 operationCount = uint16(targets.length);

        for (uint16 operationIndex = 0; operationIndex < operationCount; operationIndex++) {
            bytes32 payloadHash = keccak256(payloads[operationIndex]);

            bytes32 operationId = keccak256(
                abi.encodePacked(
                    targets[operationIndex],
                    payloadHash,
                    operationIndex,
                    parentOperationId
                )
            );

            emit ProofOfOperation(
                operationId,
                systemId,
                executor,
                targets[operationIndex],
                values[operationIndex],
                payloadHash,
                parentOperationId,
                executionContext,
                operationIndex,
                operationCount
            );

            _executeOperation(
                targets[operationIndex],
                values[operationIndex],
                payloads[operationIndex]
            );
        }
    }

    function _executeOperation(
        address target,
        uint256 value,
        bytes memory payload
    ) internal virtual;
}
