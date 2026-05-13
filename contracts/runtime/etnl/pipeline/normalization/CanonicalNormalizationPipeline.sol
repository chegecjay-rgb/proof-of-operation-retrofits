// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "../artifacts/CanonicalPipelineArtifacts.sol";

library CanonicalNormalizationPipeline {
    using CanonicalPipelineArtifacts for *;

    function normalizeReplay(bytes32 equivalenceKey, bytes32 continuityKey, bytes32 orderingKey)
        internal
        pure
        returns (CanonicalPipelineArtifacts.NormalizationArtifact memory artifact)
    {
        artifact = CanonicalPipelineArtifacts.NormalizationArtifact({
            equivalenceKey: equivalenceKey,
            continuityKey: continuityKey,
            orderingKey: orderingKey,
            normalizationRoot: keccak256(abi.encode("NORMALIZATION_ROOT", equivalenceKey, continuityKey, orderingKey))
        });
    }
}
