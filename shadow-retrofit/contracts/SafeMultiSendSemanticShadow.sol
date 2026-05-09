pragma solidity ^0.8.20;

import "../../live-semantic-adapter/contracts/SafeSemanticAdapter.sol";

abstract contract SafeMultiSendSemanticShadow is SafeSemanticAdapter {
    function _executeSemanticMultiSend(
        bytes32 systemId,
        bytes32 safeTxHash,
        uint256 nonce,
        address executor,
        address[] memory targets,
        uint256[] memory values,
        bytes[] memory payloads,
        uint8 executionContext
    ) internal {
        bytes32 parentOperationId = _deriveParentOperationId(
            safeTxHash,
            nonce
        );

        uint16 operationCount = uint16(targets.length);

        for (uint16 operationIndex = 0; operationIndex < operationCount; operationIndex++) {
            _emitSemanticOperation(
                systemId,
                executor,
                targets[operationIndex],
                values[operationIndex],
                payloads[operationIndex],
                parentOperationId,
                executionContext,
                operationIndex,
                operationCount
            );

            _executeOriginalOperation(
                targets[operationIndex],
                values[operationIndex],
                payloads[operationIndex]
            );
        }
    }

    function _executeOriginalOperation(
        address target,
        uint256 value,
        bytes memory payload
    ) internal virtual;
}
