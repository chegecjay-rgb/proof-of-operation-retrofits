// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

contract PoOMixin {
    event OperationExecuted(
        bytes32 authorityId,
        bytes32 operationId,
        address target,
        bytes32 dataHash,
        uint256 timestamp
    );

    function _emitPoO(bytes32 operationId) internal {
        emit OperationExecuted(
            bytes32(uint256(uint160(msg.sender))),
            operationId,
            address(this),
            keccak256(msg.data),
            block.timestamp
        );
    }
}
