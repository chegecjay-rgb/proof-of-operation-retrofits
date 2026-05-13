// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

interface INormalizationSurface {
    struct NormalizationArtifact {
        bytes32 equivalenceKey;
        bytes32 continuityKey;
        bytes32 orderingKey;
        bytes32 normalizationRoot;
    }
}
