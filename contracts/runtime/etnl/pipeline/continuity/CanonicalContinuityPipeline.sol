// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "../artifacts/CanonicalPipelineArtifacts.sol";

library CanonicalContinuityPipeline {
    using CanonicalPipelineArtifacts for *;

    function synthesizeContinuity(CanonicalPipelineArtifacts.NormalizationArtifact memory normalizationArtifact)
        internal
        pure
        returns (CanonicalPipelineArtifacts.ContinuityArtifact memory artifact)
    {
        bytes32 lineageKey =
            keccak256(abi.encode(normalizationArtifact.equivalenceKey, normalizationArtifact.continuityKey));

        artifact = CanonicalPipelineArtifacts.ContinuityArtifact({
            continuityRoot: keccak256(
                abi.encode("CONTINUITY_ROOT", normalizationArtifact.normalizationRoot, lineageKey)
            ),
            lineageKey: lineageKey,
            continuityVerified: true
        });
    }
}
