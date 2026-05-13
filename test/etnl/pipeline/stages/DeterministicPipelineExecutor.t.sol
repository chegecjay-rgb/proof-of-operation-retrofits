// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "forge-std/Test.sol";

import "../../../../contracts/runtime/etnl/pipeline/executor/DeterministicPipelineExecutor.sol";

contract DeterministicPipelineExecutorTest is Test {
    DeterministicPipelineExecutor executor;

    function setUp() public {
        executor = new DeterministicPipelineExecutor();
    }

    function testDeterministicPipelineExecution() public {
        bytes32 equivalenceKey = keccak256("EQUIVALENCE");
        bytes32 continuityKey = keccak256("CONTINUITY");
        bytes32 orderingKey = keccak256("ORDERING");

        DeterministicPipelineExecutor.ExecutionResult memory result =
            executor.execute(equivalenceKey, continuityKey, orderingKey);

        assertTrue(result.normalizationArtifact.normalizationRoot != bytes32(0));

        assertTrue(result.continuityArtifact.continuityVerified);
    }
}
