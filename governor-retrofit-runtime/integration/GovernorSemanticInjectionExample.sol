// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "../adapters/GovernorExecutionAdapter.sol";

abstract contract GovernorSemanticInjectionExample is GovernorExecutionAdapter {
    bytes32 internal constant SYSTEM_ID =
        keccak256("PROOF_OF_OPERATION_GOVERNOR_RUNTIME");

    function executeProposal(
        bytes32 proposalId,
        address[] memory targets,
        uint256[] memory values,
        bytes[] memory payloads
    ) internal {
        require(
            targets.length == payloads.length &&
            targets.length == values.length,
            "governance topology mismatch"
        );

        bytes32 parentOperationId =
            _beforeGovernanceExecution(
                SYSTEM_ID,
                proposalId
            );

        uint16 operationCount =
            uint16(targets.length);

        for (uint16 i = 0; i < operationCount; i++) {
            _declareGovernanceOperation(
                SYSTEM_ID,
                targets[i],
                values[i],
                payloads[i],
                parentOperationId,
                i,
                operationCount
            );

            (bool success, ) =
                targets[i].call{value: values[i]}(
                    payloads[i]
                );

            require(
                success,
                "governance execution failed"
            );
        }
    }
}
