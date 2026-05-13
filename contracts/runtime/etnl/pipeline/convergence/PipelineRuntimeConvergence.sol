// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

library PipelineRuntimeConvergence {
    struct RuntimeConvergenceState {
        bytes32 runtimeRoot;
        uint256 stageCount;
        bool converged;
    }

    function converge(bytes32 normalizationRoot, bytes32 continuityRoot)
        internal
        pure
        returns (RuntimeConvergenceState memory)
    {
        return RuntimeConvergenceState({
            runtimeRoot: keccak256(abi.encode(normalizationRoot, continuityRoot)), stageCount: 2, converged: true
        });
    }
}
