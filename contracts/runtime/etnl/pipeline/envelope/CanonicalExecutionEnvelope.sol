// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "../artifacts/CanonicalPipelineArtifacts.sol";

library CanonicalExecutionEnvelope {
    struct ExecutionEnvelope {
        CanonicalPipelineArtifacts.NormalizationArtifact normalizationArtifact;
        CanonicalPipelineArtifacts.ContinuityArtifact continuityArtifact;
        CanonicalPipelineArtifacts.TopologyArtifact topologyArtifact;
        CanonicalPipelineArtifacts.GraphArtifact graphArtifact;
        CanonicalPipelineArtifacts.ValidationArtifact validationArtifact;

        bytes32 executionRoot;
        bool converged;
    }

    function envelopeRoot(ExecutionEnvelope memory envelope) internal pure returns (bytes32) {
        return keccak256(
            abi.encode(
                envelope.normalizationArtifact.normalizationRoot,
                envelope.continuityArtifact.continuityRoot,
                envelope.topologyArtifact.topologyRoot,
                envelope.graphArtifact.graphRoot,
                envelope.validationArtifact.validationRoot
            )
        );
    }
}
