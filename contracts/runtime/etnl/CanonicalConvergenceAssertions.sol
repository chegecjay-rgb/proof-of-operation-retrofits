// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

library CanonicalConvergenceAssertions {
    function assertValidationRootStable(bytes32 expected, bytes32 actual) internal pure {
        require(expected == actual, "validationRoot instability");
    }

    function assertGraphRootConverged(bytes32 expected, bytes32 actual) internal pure {
        require(expected == actual, "graphRoot divergence");
    }

    function assertTopologyHashDeterministic(bytes32 expected, bytes32 actual) internal pure {
        require(expected == actual, "topologyHash divergence");
    }

    function assertNormalizationRootEquivalent(bytes32 expected, bytes32 actual) internal pure {
        require(expected == actual, "normalizationRoot divergence");
    }
}
