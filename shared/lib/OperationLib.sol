// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

library OperationLib {
    bytes32 internal constant SAFE_SYSTEM      = keccak256("SAFE");
    bytes32 internal constant GOVERNOR_SYSTEM  = keccak256("GOVERNOR");
    bytes32 internal constant TIMELOCK_SYSTEM  = keccak256("TIMELOCK");
    bytes32 internal constant VAULT_SYSTEM     = keccak256("VAULT");

    bytes32 internal constant OP_SAFE_EXEC     = keccak256("OP_SAFE_EXEC");
    bytes32 internal constant OP_GOV_EXEC      = keccak256("OP_GOV_EXEC");
    bytes32 internal constant OP_CANCEL        = keccak256("OP_CANCEL");
    bytes32 internal constant OP_TIMELOCK_EXEC = keccak256("OP_TIMELOCK_EXEC");
    bytes32 internal constant OP_VAULT_EXEC    = keccak256("OP_VAULT_EXEC");

    function computeOperationId(
        bytes32 opType,
        address target,
        bytes32 payloadHash,
        uint256 nonce
    ) internal pure returns (bytes32) {
        return keccak256(
            abi.encode(opType, target, payloadHash, nonce)
        );
    }
}
