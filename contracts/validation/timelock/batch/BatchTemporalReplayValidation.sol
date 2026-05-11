pragma solidity ^0.8.20;

import "../../../runtime/timelock/batch/DeterministicBatchTemporalTopology.sol";

contract BatchTemporalReplayValidation {
    using DeterministicBatchTemporalTopology for DeterministicBatchTemporalTopology.TemporalOperation[];

    function validateBatchDeterminism(
        DeterministicBatchTemporalTopology.TemporalOperation[] memory operations
    ) external pure returns (
        bytes32 batchA,
        bytes32 batchB,
        bool deterministic
    ) {
        batchA = operations.deterministicBatchRoot();
        batchB = operations.deterministicBatchRoot();

        deterministic = batchA == batchB;
    }
}
