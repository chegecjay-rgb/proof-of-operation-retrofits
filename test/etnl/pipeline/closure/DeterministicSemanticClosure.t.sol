// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "forge-std/Test.sol";

import "../../../../contracts/runtime/etnl/pipeline/execution/CanonicalPipelineExecutor.sol";

contract DeterministicSemanticClosureTest is Test {
    CanonicalPipelineExecutor executor;

    function setUp() public {
        executor = new CanonicalPipelineExecutor();
    }

    function testDeterministicSemanticClosure() public {
        CanonicalPipelineExecutor.ExecutionResult memory result =
            executor.execute(keccak256("EQUIVALENCE"), keccak256("CONTINUITY"), keccak256("ORDERING"));

        assertTrue(result.graphArtifact.deterministic);

        assertTrue(result.validationArtifact.graphValid);
    }
}
