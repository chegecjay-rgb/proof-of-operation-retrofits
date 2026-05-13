pragma solidity ^0.8.20;

import "./GovernanceTimelockContinuity.sol";

contract GovernanceTimelockSemanticRuntime {
    using GovernanceTimelockContinuity for GovernanceTimelockContinuity.GovernanceExecution;

    event GovernanceTimelockQueued(
        bytes32 indexed governanceExecutionRoot,
        bytes32 indexed proposalId,
        bytes32 indexed timelockBatchRoot,
        bytes32 parentOperationId,
        uint256 eta
    );

    event GovernanceTimelockExecuted(
        bytes32 indexed governanceExecutionRoot,
        bytes32 indexed proposalId,
        bytes32 indexed timelockBatchRoot,
        bytes32 parentOperationId,
        uint256 executedAt
    );

    function deriveGovernanceExecutionRoot(GovernanceTimelockContinuity.GovernanceExecution memory execution)
        public
        pure
        returns (bytes32)
    {
        return execution.governanceExecutionRoot();
    }

    function emitGovernanceQueued(GovernanceTimelockContinuity.GovernanceExecution memory execution)
        external
        returns (bytes32)
    {
        bytes32 root = deriveGovernanceExecutionRoot(execution);

        emit GovernanceTimelockQueued(
            root, execution.proposalId, execution.timelockBatchRoot, execution.parentOperationId, execution.eta
        );

        return root;
    }

    function emitGovernanceExecuted(GovernanceTimelockContinuity.GovernanceExecution memory execution)
        external
        returns (bytes32)
    {
        bytes32 root = deriveGovernanceExecutionRoot(execution);

        emit GovernanceTimelockExecuted(
            root, execution.proposalId, execution.timelockBatchRoot, execution.parentOperationId, block.timestamp
        );

        return root;
    }
}
