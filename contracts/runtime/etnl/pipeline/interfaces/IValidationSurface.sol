// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

interface IValidationSurface {
    struct ValidationArtifact {
        bytes32 validationRoot;
        bool deterministic;
        bool continuityVerified;
        bool topologyVerified;
    }
}
