// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "../../artifacts/CanonicalPipelineArtifacts.sol";

library CanonicalGraphStage {
    function buildGraphArtifact(CanonicalPipelineArtifacts.TopologyArtifact memory topologyArtifact)
        internal
        pure
        returns (CanonicalPipelineArtifacts.GraphArtifact memory artifact)
    {
        artifact.graphRoot = keccak256(abi.encode(topologyArtifact.topologyRoot, topologyArtifact.topologyHash));

        artifact.canonicalGraphHash = keccak256(abi.encode("GRAPH", artifact.graphRoot));

        artifact.deterministic = true;
    }
}
