// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "../lib/OperationLib.sol";
import "../interfaces/IOperationEvents.sol";

contract PoOVault is IOperationEvents {
    using OperationLib for bytes32;

    uint256 public nonce;

    receive() external payable {}

    function execute(
        address target,
        uint256 value,
        bytes calldata data
    ) external returns (bytes memory result) {
        bytes32 payloadHash = keccak256(data);
        bytes32 opType = OperationLib.OP_VAULT_EXEC;

        bytes32 operationId = OperationLib.computeOperationId(
            opType,
            target,
            payloadHash,
            nonce
        );

        nonce++;

        (bool success, bytes memory res) = target.call{value: value}(data);
        require(success, "VAULT_EXEC_FAILED");

        emit OperationExecuted(
            OperationLib.VAULT_SYSTEM,
            operationId,
            opType,
            target,
            payloadHash,
            block.timestamp
        );

        return res;
    }
}
