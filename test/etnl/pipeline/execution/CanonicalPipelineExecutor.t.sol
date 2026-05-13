// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "forge-std/Test.sol";

import "../../../../contracts/runtime/etnl/pipeline/execution/CanonicalPipelineExecutor.sol";

contract CanonicalPipelineExecutorTest is Test {
    CanonicalPipelineExecutor internal executor;

    function setUp() public {
        executor = new CanonicalPipelineExecutor();
    }

    function testDeterministicPipelineExecution() public view {
        bytes32 equivalenceKey = keccak256("EQUIVALENCE");
        bytes32 continuityKey = keccak256("CONTINUITY");
        bytes32 orderingKey = keccak256("ORDERING");

        CanonicalPipelineExecutor.ExecutionResult memory result =
            executor.execute(equivalenceKey, continuityKey, orderingKey);

        assertTrue(result.validationArtifact.normalizationValid);

        assertTrue(result.validationArtifact.continuityValid);

        assertTrue(result.validationArtifact.topologyValid);

        assertTrue(result.validationArtifact.graphValid);

        assertTrue(result.graphArtifact.deterministic);

        assertTrue(result.graphArtifact.graphRoot != bytes32(0));
    }
}
