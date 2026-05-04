// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "@openzeppelin/contracts/governance/Governor.sol";
import "./PoOMixin.sol";

abstract contract PoOGovernor is Governor, PoOMixin {
    constructor(string memory name_) Governor(name_) {}

    function _executeOperations(
        uint256 proposalId,
        address[] memory targets,
        uint256[] memory values,
        bytes[] memory calldatas,
        bytes32 descriptionHash
    ) internal virtual override {
        super._executeOperations(proposalId, targets, values, calldatas, descriptionHash);
        _emitPoO(keccak256("GOV_EXECUTE"));
    }

    function _cancel(
        address[] memory targets,
        uint256[] memory values,
        bytes[] memory calldatas,
        bytes32 descriptionHash
    ) internal virtual override returns (uint256) {
        uint256 pid = super._cancel(targets, values, calldatas, descriptionHash);
        _emitPoO(keccak256("GOV_CANCEL"));
        return pid;
    }
}
