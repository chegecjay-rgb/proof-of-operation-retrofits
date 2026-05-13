pragma solidity ^0.8.20;

import "../../interfaces/timelock/ITimelockSemanticEvents.sol";
import "./DeterministicTemporalReplay.sol";

contract TimelockSemanticRuntime is ITimelockSemanticEvents {
    using DeterministicTemporalReplay for address;

    function derivePayloadHash(address target, uint256 value, bytes memory payload) public pure returns (bytes32) {
        return DeterministicTemporalReplay.payloadHash(target, value, payload);
    }

    function deriveOperationId(address target, uint256 value, bytes memory payload, uint256 eta)
        public
        pure
        returns (bytes32)
    {
        return DeterministicTemporalReplay.operationId(target, value, payload, eta);
    }

    function deriveParentOperationId(bytes32[] memory operationIds) public pure returns (bytes32) {
        return DeterministicTemporalReplay.parentOperationId(operationIds);
    }

    function emitScheduledOperation(
        bytes32 parentId,
        address target,
        uint256 value,
        bytes memory payload,
        uint256 eta,
        uint256 operationIndex
    ) external returns (bytes32) {
        bytes32 payloadHashValue = derivePayloadHash(target, value, payload);

        bytes32 operationIdValue = deriveOperationId(target, value, payload, eta);

        emit TimelockOperationScheduled(
            operationIdValue, parentId, target, payloadHashValue, value, eta, operationIndex
        );

        return operationIdValue;
    }

    function emitExecutedOperation(
        bytes32 parentId,
        address target,
        uint256 value,
        bytes memory payload,
        uint256 eta,
        uint256 operationIndex
    ) external returns (bytes32) {
        bytes32 payloadHashValue = derivePayloadHash(target, value, payload);

        bytes32 operationIdValue = deriveOperationId(target, value, payload, eta);

        emit TimelockOperationExecuted(
            operationIdValue, parentId, target, payloadHashValue, value, block.timestamp, operationIndex
        );

        return operationIdValue;
    }
}
