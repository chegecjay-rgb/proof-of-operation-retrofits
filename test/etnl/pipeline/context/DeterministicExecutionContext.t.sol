// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "forge-std/Test.sol";

import "../../../../contracts/runtime/etnl/pipeline/context/DeterministicExecutionContext.sol";

contract DeterministicExecutionContextTest is Test {
    function testDeterministicExecutionContextHashing() public pure {
        DeterministicExecutionContext.ExecutionContext memory context = DeterministicExecutionContext.ExecutionContext({
            executionId: keccak256("EXECUTION"),
            priorArtifactRoot: keccak256("PRIOR"),
            currentArtifactRoot: keccak256("CURRENT"),
            lineageRoot: keccak256("LINEAGE"),
            executionIndex: 1,
            deterministic: true
        });

        bytes32 firstHash = DeterministicExecutionContext.contextHash(context);

        bytes32 secondHash = DeterministicExecutionContext.contextHash(context);

        assertEq(firstHash, secondHash);
    }
}
