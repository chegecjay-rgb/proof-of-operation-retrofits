// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

library PipelineCheckpointRuntime {
    struct PipelineCheckpoint {
        bytes32 stageId;
        bytes32 artifactRoot;
        uint256 blockNumber;
        uint256 timestamp;
    }

    function checkpointHash(PipelineCheckpoint memory checkpoint) internal pure returns (bytes32) {
        return keccak256(
            abi.encode(
                "PIPELINE_CHECKPOINT",
                checkpoint.stageId,
                checkpoint.artifactRoot,
                checkpoint.blockNumber,
                checkpoint.timestamp
            )
        );
    }
}
