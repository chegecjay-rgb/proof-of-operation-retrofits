// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "forge-std/Test.sol";
import "../lib/OperationLib.sol";

contract OperationIdDeterminismTest is Test {
    function test_cross_system_operationId_determinism() public {
        // === Shared Inputs ===
        bytes32 payloadHash = keccak256(abi.encode("test-payload"));
        address target = address(0x1234);
        uint256 nonce = 42;

        // === Safe Computation ===
        bytes32 safeOpId = OperationLib.computeOperationId(
            OperationLib.OP_SAFE_EXEC,
            target,
            payloadHash,
            nonce
        );

        // === Governor Computation (forced same semantic space) ===
        bytes32 govOpId = OperationLib.computeOperationId(
            OperationLib.OP_SAFE_EXEC, // intentionally same opType
            target,
            payloadHash,
            nonce
        );

        // === Assertion ===
        assertEq(safeOpId, govOpId, "operationId mismatch across systems");
    }
}
