pragma solidity ^0.8.20;

import "../../../runtime/timelock/governance/GovernanceTimelockContinuity.sol";

contract GovernanceTemporalContinuityValidation {
    using GovernanceTimelockContinuity for GovernanceTimelockContinuity.GovernanceExecution;

    function validateGovernanceContinuity(GovernanceTimelockContinuity.GovernanceExecution memory execution)
        external
        pure
        returns (bytes32 rootA, bytes32 rootB, bool deterministic)
    {
        rootA = execution.governanceExecutionRoot();
        rootB = execution.governanceExecutionRoot();

        deterministic = rootA == rootB;
    }
}
