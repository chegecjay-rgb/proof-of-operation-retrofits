// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

library OperationLib {
    // =========================
    // SYSTEM IDS
    // =========================
    bytes32 internal constant SAFE_SYSTEM = keccak256("SAFE");
    bytes32 internal constant GOVERNOR_SYSTEM = keccak256("GOVERNOR");

    // =========================
    // OP TYPES
    // =========================
    bytes32 internal constant OP_SAFE_EXEC = keccak256("OP_SAFE_EXEC");
    bytes32 internal constant OP_GOV_EXEC  = keccak256("OP_GOV_EXEC");
    bytes32 internal constant OP_CANCEL    = keccak256("OP_CANCEL");

    // =========================
    // OPERATION ID BUILDER
    // =========================
    function computeOperationId(
        bytes32 opType,
        address target,
        bytes32 payloadHash,
        uint256 nonce
    ) internal pure returns (bytes32) {
        return keccak256(
            abi.encode(
                opType,
                target,
                payloadHash,
                nonce
            )
        );
    }
}
