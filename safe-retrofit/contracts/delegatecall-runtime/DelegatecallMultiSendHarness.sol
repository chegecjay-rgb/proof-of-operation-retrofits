// SPDX-License-Identifier: LGPL-3.0-only
pragma solidity >=0.8.20 <0.9.0;

import "../semantic-runtime/SemanticMultiSendShadow.sol";

contract DelegatecallMultiSendHarness is SemanticMultiSendShadow {
    address public immutable multiSendLibrary;

    constructor(address multiSendAddress)
        SemanticMultiSendShadow(multiSendAddress)
    {
        multiSendLibrary = multiSendAddress;
    }

    function executeDelegatecallReplay(
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

        _emitSemanticBatch(
            systemId,
            executionContext,
            parentOperationId,
            operationCount,
            transactions
        );

        (bool success, bytes memory returndata) = multiSendLibrary.delegatecall(
            abi.encodeWithSignature(
                "multiSend(bytes)",
                transactions
            )
        );

        if (!success) {
            assembly {
                revert(add(returndata, 32), mload(returndata))
            }
        }
    }
}
