// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "../contracts/GovernorSemanticRuntime.sol";

abstract contract GovernorExecutionAdapter is GovernorSemanticRuntime {
    function _beforeGovernanceExecution(
        bytes32 systemId,
        bytes32 proposalId
    ) internal view returns (bytes32) {
        return _generateParentOperationId(
            systemId,
            msg.sender,
            proposalId
        );
    }

    function _declareGovernanceOperation(
        bytes32 systemId,
        address target,
        uint256 value,
        bytes memory payload,
        bytes32 parentOperationId,
        uint16 operationIndex,
        uint16 operationCount
    ) internal {
        _emitProofOfOperation(
            systemId,
            msg.sender,
            target,
            value,
            payload,
            parentOperationId,
            0,
            operationIndex,
            operationCount
        );
    }
}
