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
    ) external payable {
        bytes32 parentOperationId = _deriveParentOperationId(
            safeTxHash,
            nonce
        );

        uint16 operationCount = _countOperations(transactions);

        uint256 length = transactions.length;
        uint256 i = 0x20;
        uint16 operationIndex = 0;

        while (i < length + 0x20) {
            uint8 operation;
            address to;
            uint256 value;
            uint256 dataLength;
            bytes memory payload;

            assembly {
                operation := shr(248, mload(add(transactions, i)))
                to := shr(96, mload(add(transactions, add(i, 0x01))))
                value := mload(add(transactions, add(i, 0x15)))
                dataLength := mload(add(transactions, add(i, 0x35)))
            }

            payload = new bytes(dataLength);

            for (uint256 j = 0; j < dataLength; j++) {
                payload[j] = transactions[i + 0x55 + j];
            }

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

            operation;

            i = i + 0x55 + dataLength;
            operationIndex++;
        }

        multiSend.multiSend{value: msg.value}(transactions);
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
