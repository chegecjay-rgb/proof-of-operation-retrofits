// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "../artifacts/CanonicalPipelineArtifacts.sol";

library CanonicalGraphPipeline {
    using CanonicalPipelineArtifacts for *;

    function constructGraph(CanonicalPipelineArtifacts.TopologyArtifact memory topologyArtifact)
        internal
        pure
        returns (CanonicalPipelineArtifacts.GraphArtifact memory artifact)
    {
        bytes32 graphHash =
            keccak256(abi.encode("GRAPH_HASH", topologyArtifact.topologyRoot, topologyArtifact.topologyHash));

        artifact = CanonicalPipelineArtifacts.GraphArtifact({
            graphRoot: keccak256(abi.encode("GRAPH_ROOT", graphHash)),
            canonicalGraphHash: graphHash,
            deterministic: true
        });
    }
}
