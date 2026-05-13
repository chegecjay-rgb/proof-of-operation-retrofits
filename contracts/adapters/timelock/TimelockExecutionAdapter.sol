pragma solidity ^0.8.20;

import "../../runtime/timelock/TimelockSemanticRuntime.sol";

contract TimelockExecutionAdapter {
    TimelockSemanticRuntime public immutable semanticRuntime;

    constructor(address runtimeAddress) {
        semanticRuntime = TimelockSemanticRuntime(runtimeAddress);
    }

    function semanticExecuteTransaction(
        address target,
        uint256 value,
        bytes calldata payload,
        uint256 eta,
        uint256 operationIndex,
        bytes32 parentOperationId
    ) external returns (bytes32) {
        return semanticRuntime.emitExecutedOperation(parentOperationId, target, value, payload, eta, operationIndex);
    }
}
