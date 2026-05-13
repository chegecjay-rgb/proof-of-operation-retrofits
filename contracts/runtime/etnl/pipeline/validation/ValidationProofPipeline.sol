// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "../artifacts/CanonicalPipelineArtifacts.sol";

library ValidationProofPipeline {
    using CanonicalPipelineArtifacts for *;

    function validatePipeline(
        CanonicalPipelineArtifacts.NormalizationArtifact memory normalizationArtifact,
        CanonicalPipelineArtifacts.ContinuityArtifact memory continuityArtifact,
        CanonicalPipelineArtifacts.TopologyArtifact memory topologyArtifact,
        CanonicalPipelineArtifacts.GraphArtifact memory graphArtifact
    ) internal pure returns (CanonicalPipelineArtifacts.ValidationArtifact memory artifact) {
        artifact = CanonicalPipelineArtifacts.ValidationArtifact({
            validationRoot: keccak256(
                abi.encode(
                    "VALIDATION_ROOT",
                    normalizationArtifact.normalizationRoot,
                    continuityArtifact.continuityRoot,
                    topologyArtifact.topologyRoot,
                    graphArtifact.graphRoot
                )
            ),
            normalizationValid: true,
            continuityValid: continuityArtifact.continuityVerified,
            topologyValid: topologyArtifact.nodeCount > 0,
            graphValid: graphArtifact.deterministic
        });
    }
}
