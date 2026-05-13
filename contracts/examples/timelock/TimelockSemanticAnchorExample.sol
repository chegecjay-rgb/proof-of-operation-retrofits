pragma solidity ^0.8.20;

import "../../runtime/timelock/TimelockSemanticRuntime.sol";

contract TimelockSemanticAnchorExample {
    TimelockSemanticRuntime public immutable runtime;

    constructor(address runtimeAddress) {
        runtime = TimelockSemanticRuntime(runtimeAddress);
    }

    function semanticQueueAnchor(address target, uint256 value, bytes calldata payload, uint256 eta)
        external
        returns (bytes32)
    {
        bytes32[] memory operationIds = new bytes32[](1);

        operationIds[0] = runtime.deriveOperationId(target, value, payload, eta);

        bytes32 parentId = runtime.deriveParentOperationId(operationIds);

        return runtime.emitScheduledOperation(parentId, target, value, payload, eta, 0);
    }

    function semanticExecutionAnchor(address target, uint256 value, bytes calldata payload, uint256 eta)
        external
        returns (bytes32)
    {
        bytes32[] memory operationIds = new bytes32[](1);

        operationIds[0] = runtime.deriveOperationId(target, value, payload, eta);

        bytes32 parentId = runtime.deriveParentOperationId(operationIds);

        return runtime.emitExecutedOperation(parentId, target, value, payload, eta, 0);
    }
}
