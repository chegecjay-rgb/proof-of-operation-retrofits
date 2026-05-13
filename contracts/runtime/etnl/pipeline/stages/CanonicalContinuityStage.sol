// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "../artifacts/CanonicalPipelineArtifacts.sol";

library CanonicalContinuityStage {
    function buildContinuityArtifact(CanonicalPipelineArtifacts.NormalizationArtifact memory normalizationArtifact)
        internal
        pure
        returns (CanonicalPipelineArtifacts.ContinuityArtifact memory artifact)
    {
        bytes32 continuityRoot =
            keccak256(abi.encode(normalizationArtifact.equivalenceKey, normalizationArtifact.continuityKey));

        artifact = CanonicalPipelineArtifacts.ContinuityArtifact({
            continuityRoot: continuityRoot,
            lineageKey: keccak256(abi.encode("LINEAGE_KEY", continuityRoot)),
            continuityVerified: true
        });
    }
}
