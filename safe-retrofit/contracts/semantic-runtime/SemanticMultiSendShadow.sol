// SPDX-License-Identifier: LGPL-3.0-only
pragma solidity >=0.8.20 <0.9.0;

import "./SafeSemanticAdapter.sol";

interface IMultiSend {
    function multiSend(bytes memory transactions) external payable;
}

contract SemanticMultiSendShadow is SafeSemanticAdapter {
    IMultiSend public immutable multiSend;

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
        uint256 length = transactions.length;
        uint256 i = 0x20;
        uint16 operationIndex = 0;

        while (i < length + 0x20) {
            (
                address to,
                uint256 value,
                uint256 dataLength
            ) = _decodeHeader(
                transactions,
                i
            );

            bytes memory payload = _extractPayload(
                transactions,
                i,
                dataLength
            );

            _emitSemanticOperation(
                systemId,
                msg.sender,
                to,
                value,
                payload,
                parentOperationId,
                executionContext,
                operationIndex,
                operationCount
            );

            i = i + 0x55 + dataLength;
            operationIndex++;
        }
    }

    function _decodeHeader(
        bytes memory transactions,
        uint256 i
    )
        internal
        pure
        returns (
            address to,
            uint256 value,
            uint256 dataLength
        )
    {
        assembly {
            to := shr(96, mload(add(transactions, add(i, 0x01))))
            value := mload(add(transactions, add(i, 0x15)))
            dataLength := mload(add(transactions, add(i, 0x35)))
        }
    }

    function _extractPayload(
        bytes memory transactions,
        uint256 i,
        uint256 dataLength
    ) internal pure returns (bytes memory payload) {
        payload = new bytes(dataLength);

        for (uint256 j = 0; j < dataLength; j++) {
            payload[j] = transactions[i + 0x55 + j];
        }
    }

    function _countOperations(
        bytes memory transactions
    ) internal pure returns (uint16 count) {
        uint256 length = transactions.length;
        uint256 i = 0x20;

        while (i < length + 0x20) {
            uint256 dataLength;

            assembly {
                dataLength := mload(add(transactions, add(i, 0x35)))
            }

            i = i + 0x55 + dataLength;
            count++;
        }
    }
}
