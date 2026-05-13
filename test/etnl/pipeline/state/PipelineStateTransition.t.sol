// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "forge-std/Test.sol";

import "../../../../contracts/runtime/etnl/pipeline/state/PipelineStateTransition.sol";

contract PipelineStateTransitionTest is Test {
    function testDeterministicStateTransition() public {
        PipelineStateTransition.PipelineState memory initialState = PipelineStateTransition.PipelineState({
            currentStage: keccak256("NORMALIZATION"),
            artifactRoot: keccak256("ROOT_A"),
            executionIndex: 0,
            deterministic: true
        });

        PipelineStateTransition.PipelineState memory nextState =
            PipelineStateTransition.transition(initialState, keccak256("CONTINUITY"), keccak256("ROOT_B"));

        assertEq(nextState.executionIndex, 1);

        assertTrue(nextState.deterministic);

        assertTrue(nextState.artifactRoot != bytes32(0));
    }
}
