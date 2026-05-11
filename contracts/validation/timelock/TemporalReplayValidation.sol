pragma solidity ^0.8.20;

import "../../runtime/timelock/DeterministicTemporalReplay.sol";

contract TemporalReplayValidation {
    function validateDeterministicReplay(
        address target,
        uint256 value,
        bytes calldata payload,
        uint256 eta
    ) external pure returns (
        bytes32 operationA,
        bytes32 operationB,
        bool deterministic
    ) {
        operationA = DeterministicTemporalReplay.operationId(
            target,
            value,
            payload,
            eta
        );

        operationB = DeterministicTemporalReplay.operationId(
            target,
            value,
            payload,
            eta
        );

        deterministic = operationA == operationB;
    }

    function validatePayloadNormalization(
        address target,
        uint256 value,
        bytes calldata payload
    ) external pure returns (bytes32) {
        return DeterministicTemporalReplay.payloadHash(
            target,
            value,
            payload
        );
    }
}
