// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

interface IGraphSurface {
    struct GraphArtifact {
        bytes32 graphRoot;
        bytes32 canonicalGraphHash;
        bytes32 semanticRoot;
    }
}
