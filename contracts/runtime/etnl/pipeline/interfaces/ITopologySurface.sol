// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

interface ITopologySurface {
    struct TopologyArtifact {
        bytes32 topologyRoot;
        bytes32 nodeRoot;
        bytes32 edgeRoot;
        uint256 nodeCount;
        uint256 edgeCount;
    }
}
