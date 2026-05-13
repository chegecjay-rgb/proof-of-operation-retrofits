// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "forge-std/Test.sol";

import "../../../../contracts/runtime/etnl/pipeline/execution/CanonicalPipelineExecutor.sol";

import "../../../../contracts/runtime/etnl/pipeline/convergence/PipelineRuntimeConvergence.sol";

contract PipelineRuntimeConvergenceTest is Test {
    CanonicalPipelineExecutor executor;

    function setUp() public {
        executor = new CanonicalPipelineExecutor();
    }

    function testPipelineRuntimeConvergence() public {
        bytes32 equivalenceKey = keccak256("EQ");
        bytes32 continuityKey = keccak256("CONT");
        bytes32 orderingKey = keccak256("ORDER");

        CanonicalPipelineExecutor.ExecutionResult memory result =
            executor.execute(equivalenceKey, continuityKey, orderingKey);

        PipelineRuntimeConvergence.RuntimeConvergenceState memory state = PipelineRuntimeConvergence.converge(
            result.normalizationArtifact.normalizationRoot, result.continuityArtifact.continuityRoot
        );

        assertTrue(state.converged);

        assertEq(state.stageCount, 2);

        assertTrue(state.runtimeRoot != bytes32(0));
    }
}
