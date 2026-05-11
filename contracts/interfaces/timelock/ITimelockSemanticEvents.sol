pragma solidity ^0.8.20;

interface ITimelockSemanticEvents {
    event TimelockOperationScheduled(
        bytes32 indexed operationId,
        bytes32 indexed parentOperationId,
        address indexed target,
        bytes32 payloadHash,
        uint256 value,
        uint256 eta,
        uint256 operationIndex
    );

    event TimelockOperationExecuted(
        bytes32 indexed operationId,
        bytes32 indexed parentOperationId,
        address indexed target,
        bytes32 payloadHash,
        uint256 value,
        uint256 executedAt,
        uint256 operationIndex
    );
}
