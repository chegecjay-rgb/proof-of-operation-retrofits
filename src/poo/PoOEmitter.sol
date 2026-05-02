// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

abstract contract PoOEmitter {
    event OperationExecuted(
        bytes32 authorityId,
        bytes32 operationId,
        address target,
        bytes32 dataHash,
        uint256 timestamp
    );

    function _emitPoO(
        bytes32 authorityId,
        bytes32 operationId,
        address target,
        bytes memory data
    ) internal {
        emit OperationExecuted(
            authorityId,
            operationId,
            target,
            keccak256(data),
            block.timestamp
        );
    }
}
