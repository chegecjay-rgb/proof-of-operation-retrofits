// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "forge-std/Test.sol";

import "../../../../contracts/runtime/etnl/pipeline/envelope/CanonicalExecutionEnvelope.sol";

contract CanonicalExecutionEnvelopeTest is Test {
    function testDeterministicEnvelopeRoot() public pure {
        CanonicalExecutionEnvelope.ExecutionEnvelope memory envelope;

        envelope.executionRoot = keccak256("EXECUTION_ROOT");
        envelope.converged = true;

        bytes32 firstRoot = CanonicalExecutionEnvelope.envelopeRoot(envelope);

        bytes32 secondRoot = CanonicalExecutionEnvelope.envelopeRoot(envelope);

        assertEq(firstRoot, secondRoot);
    }
}
