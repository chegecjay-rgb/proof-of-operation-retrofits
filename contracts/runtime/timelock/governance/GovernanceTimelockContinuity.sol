pragma solidity ^0.8.20;

library GovernanceTimelockContinuity {
    struct GovernanceExecution {
        bytes32 proposalId;
        bytes32 timelockBatchRoot;
        bytes32 parentOperationId;
        uint256 eta;
    }

    function governanceExecutionRoot(GovernanceExecution memory execution) internal pure returns (bytes32) {
        return keccak256(
            abi.encode(execution.proposalId, execution.timelockBatchRoot, execution.parentOperationId, execution.eta)
        );
    }
}
