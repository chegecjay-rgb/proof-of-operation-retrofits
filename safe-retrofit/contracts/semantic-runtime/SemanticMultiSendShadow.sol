// SPDX-License-Identifier: LGPL-3.0-only
pragma solidity >=0.8.20 <0.9.0;

import "./SafeSemanticAdapter.sol";

interface IMultiSend {
    function multiSend(bytes memory transactions) external payable;
}

contract SemanticMultiSendShadow is SafeSemanticAdapter {
    IMultiSend public immutable multiSend;

    event SemanticBoundaryTrace(
        uint256 cursor,
        uint256 length,
        uint256 dataOffset,
        uint256 dataLength,
        uint16 operationIndex
    );

    constructor(address multiSendAddress) {
        multiSend = IMultiSend(multiSendAddress);
    }

    function semanticMultiSend(
        bytes32 systemId,
        bytes32 safeTxHash,
        uint256 nonce,
        uint8 executionContext,
        bytes memory transactions
    ) public payable {
        bytes32 parentOperationId = _deriveParentOperationId(
            safeTxHash,
            nonce
        );

        uint16 operationCount = _countOperations(transactions);

        _emitSemanticBatch(
            systemId,
            executionContext,
            parentOperationId,
            operationCount,
            transactions
        );

        multiSend.multiSend{value: msg.value}(transactions);
    }

    function _emitSemanticBatch(
        bytes32 systemId,
        uint8 executionContext,
        bytes32 parentOperationId,
        uint16 operationCount,
        bytes memory transactions
    ) internal {
        uint256 cursor = 0;

        for (uint16 operationIndex = 0; operationIndex < operationCount; operationIndex++) {
            (
                address target,
                uint256 value,
                uint256 dataLength,
                bytes memory payload,
                uint256 nextCursor
            ) = _decodeOperation(
                transactions,
                cursor
            );

            emit SemanticBoundaryTrace(
                cursor,
                transactions.length,
                cursor + 85,
                dataLength,
                operationIndex
            );

            SemanticOperation memory operation = SemanticOperation({
                target: target,
                value: value,
                payload: payload,
                parentOperationId: parentOperationId,
                executionContext: executionContext,
                operationIndex: operationIndex,
                operationCount: operationCount
            });

            _emitSemanticOperationStruct(
                systemId,
                msg.sender,
                operation
            );

            cursor = nextCursor;
        }
    }

    function _decodeOperation(
        bytes memory transactions,
        uint256 cursor
    )
        internal
        pure
        returns (
            address target,
            uint256 value,
            uint256 dataLength,
            bytes memory payload,
            uint256 nextCursor
        )
    {
        uint256 base = cursor;

        require(
            transactions.length >= base + 85,
            "INVALID_OPERATION_HEADER"
        );

        assembly {
            target := shr(96, mload(add(add(transactions, 0x20), add(base, 1))))
            value := mload(add(add(transactions, 0x20), add(base, 21)))
            dataLength := mload(add(add(transactions, 0x20), add(base, 53)))
        }

        uint256 payloadOffset = base + 85;

        require(
            transactions.length >= payloadOffset + dataLength,
            "INVALID_PAYLOAD_BOUNDARY"
        );

        payload = new bytes(dataLength);

        for (uint256 j = 0; j < dataLength; j++) {
            payload[j] = transactions[payloadOffset + j];
        }

        nextCursor = payloadOffset + dataLength;
    }

    function _countOperations(
        bytes memory transactions
    ) internal pure returns (uint16 count) {
        uint256 cursor = 0;

        while (cursor < transactions.length) {
            require(
                transactions.length >= cursor + 85,
                "INVALID_COUNT_HEADER"
            );

            uint256 dataLength;

            assembly {
                dataLength := mload(add(add(transactions, 0x20), add(cursor, 53)))
            }

            uint256 nextCursor = cursor + 85 + dataLength;

            require(
                nextCursor <= transactions.length,
                "INVALID_COUNT_BOUNDARY"
            );

            cursor = nextCursor;

            count++;
        }
    }
}
