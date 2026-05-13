// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

library CanonicalPipelineArtifacts {
    struct NormalizationArtifact {
        bytes32 equivalenceKey;
        bytes32 continuityKey;
        bytes32 orderingKey;
        bytes32 normalizationRoot;
    }

    struct ContinuityArtifact {
        bytes32 continuityRoot;
        bytes32 lineageKey;
        bool continuityVerified;
    }

    struct TopologyArtifact {
        bytes32 topologyRoot;
        bytes32 topologyHash;
        uint256 nodeCount;
        uint256 edgeCount;
    }

    struct GraphArtifact {
        bytes32 graphRoot;
        bytes32 canonicalGraphHash;
        bool deterministic;
    }

    struct ValidationArtifact {
        bytes32 validationRoot;
        bool normalizationValid;
        bool continuityValid;
        bool topologyValid;
        bool graphValid;
    }
}
