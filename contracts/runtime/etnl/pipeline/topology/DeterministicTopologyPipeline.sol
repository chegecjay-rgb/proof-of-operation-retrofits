// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "../artifacts/CanonicalPipelineArtifacts.sol";

library DeterministicTopologyPipeline {
    using CanonicalPipelineArtifacts for *;

    function assembleTopology(CanonicalPipelineArtifacts.ContinuityArtifact memory continuityArtifact)
        internal
        pure
        returns (CanonicalPipelineArtifacts.TopologyArtifact memory artifact)
    {
        bytes32 topologyHash = keccak256(
            abi.encode("TOPOLOGY_HASH", continuityArtifact.continuityRoot, continuityArtifact.lineageKey)
        );

        artifact = CanonicalPipelineArtifacts.TopologyArtifact({
            topologyRoot: keccak256(abi.encode("TOPOLOGY_ROOT", topologyHash)),
            topologyHash: topologyHash,
            nodeCount: 1,
            edgeCount: 1
        });
    }
}
