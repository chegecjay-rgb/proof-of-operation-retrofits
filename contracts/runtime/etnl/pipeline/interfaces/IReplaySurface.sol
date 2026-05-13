// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

interface IReplaySurface {
    struct ReplayDisclosure {
        bytes32 operationId;
        bytes32 authorityId;
        bytes payload;
        uint256 operationIndex;
    }
}
