pragma solidity ^0.8.20;

import "./DeterministicBatchTemporalTopology.sol";

contract TimelockBatchSemanticRuntime {
    using DeterministicBatchTemporalTopology for DeterministicBatchTemporalTopology.TemporalOperation[];

    event TimelockBatchScheduled(bytes32 indexed batchRoot, uint256 operationCount, uint256 eta);

    event TimelockBatchExecuted(bytes32 indexed batchRoot, uint256 operationCount, uint256 executedAt);

    function deriveBatchRoot(DeterministicBatchTemporalTopology.TemporalOperation[] memory operations)
        public
        pure
        returns (bytes32)
    {
        return operations.deterministicBatchRoot();
    }

    function emitBatchScheduled(DeterministicBatchTemporalTopology.TemporalOperation[] memory operations, uint256 eta)
        external
        returns (bytes32)
    {
        bytes32 batchRoot = deriveBatchRoot(operations);

        emit TimelockBatchScheduled(batchRoot, operations.length, eta);

        return batchRoot;
    }

    function emitBatchExecuted(DeterministicBatchTemporalTopology.TemporalOperation[] memory operations)
        external
        returns (bytes32)
    {
        bytes32 batchRoot = deriveBatchRoot(operations);

        emit TimelockBatchExecuted(batchRoot, operations.length, block.timestamp);

        return batchRoot;
    }
}
