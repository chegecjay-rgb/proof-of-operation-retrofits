// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

library IncrementalReplayReconstruction {
    struct ReconstructionWindow {
        bytes32 checkpointRoot;
        bytes32 reconstructionRoot;
        uint256 replayCount;
        bool deterministic;
    }

    function reconstructionHash(ReconstructionWindow memory window) internal pure returns (bytes32) {
        return keccak256(
            abi.encode(
                "INCREMENTAL_RECONSTRUCTION",
                window.checkpointRoot,
                window.reconstructionRoot,
                window.replayCount,
                window.deterministic
            )
        );
    }
}
