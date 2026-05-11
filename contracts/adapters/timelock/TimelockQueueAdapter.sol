pragma solidity ^0.8.20;

import "../../runtime/timelock/TimelockSemanticRuntime.sol";

contract TimelockQueueAdapter {
    TimelockSemanticRuntime public immutable semanticRuntime;

    constructor(address runtimeAddress) {
        semanticRuntime = TimelockSemanticRuntime(runtimeAddress);
    }

    function semanticQueueTransaction(
        address target,
        uint256 value,
        bytes calldata payload,
        uint256 eta,
        uint256 operationIndex,
        bytes32 parentOperationId
    ) external returns (bytes32) {
        return semanticRuntime.emitScheduledOperation(
            parentOperationId,
            target,
            value,
            payload,
            eta,
            operationIndex
        );
    }
}
