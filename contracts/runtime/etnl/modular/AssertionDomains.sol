// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

library AssertionDomains {
    function assertValidationRoot(bytes32 expected, bytes32 actual) internal pure {
        require(expected == actual, "validation-root-divergence");
    }

    function assertTopologyConvergence(bytes32 expected, bytes32 actual) internal pure {
        require(expected == actual, "topology-convergence-divergence");
    }

    function assertNormalizationEquivalence(bytes32 expected, bytes32 actual) internal pure {
        require(expected == actual, "normalization-equivalence-divergence");
    }

    function assertCanonicalGraphDeterminism(bytes32 expected, bytes32 actual) internal pure {
        require(expected == actual, "canonical-graph-divergence");
    }
}
