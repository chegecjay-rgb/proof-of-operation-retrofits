// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

interface IOperationEvents {
    event OperationExecuted(
        bytes32 systemId,
        bytes32 operationId,
        bytes32 opType,
        address target,
        bytes32 payloadHash,
        uint256 timestamp
    );
}
