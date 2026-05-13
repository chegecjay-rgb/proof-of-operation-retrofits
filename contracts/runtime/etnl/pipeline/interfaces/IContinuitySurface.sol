// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

interface IContinuitySurface {
    struct ContinuityArtifact {
        bytes32 continuityRoot;
        bytes32 lineageRoot;
        bytes32 authorityRoot;
    }
}
