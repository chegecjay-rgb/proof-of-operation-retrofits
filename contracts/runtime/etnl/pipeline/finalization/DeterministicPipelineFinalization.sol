// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "../envelope/CanonicalExecutionEnvelope.sol";

library DeterministicPipelineFinalization {
    function finalized(CanonicalExecutionEnvelope.ExecutionEnvelope memory envelope) internal pure returns (bool) {
        return (envelope.validationArtifact.normalizationValid && envelope.validationArtifact.continuityValid
                && envelope.validationArtifact.topologyValid && envelope.validationArtifact.graphValid
                && envelope.converged);
    }
}
