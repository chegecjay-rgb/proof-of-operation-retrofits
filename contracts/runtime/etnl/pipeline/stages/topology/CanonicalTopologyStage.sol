// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "../../artifacts/CanonicalPipelineArtifacts.sol";

library CanonicalTopologyStage {
    function buildTopologyArtifact(CanonicalPipelineArtifacts.ContinuityArtifact memory continuityArtifact)
        internal
        pure
        returns (CanonicalPipelineArtifacts.TopologyArtifact memory artifact)
    {
        artifact.topologyRoot = keccak256(abi.encode(continuityArtifact.continuityRoot, continuityArtifact.lineageKey));

        artifact.topologyHash = keccak256(abi.encode("TOPOLOGY", artifact.topologyRoot));

        artifact.nodeCount = 1;
        artifact.edgeCount = 1;
    }
}
