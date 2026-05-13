// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

library StreamingReplayIngestion {
    struct ReplayIngress {
        bytes32 ingressRoot;
        bytes32 replayRoot;
        uint256 ingressSequence;
        bool canonical;
    }

    function ingressHash(ReplayIngress memory ingress) internal pure returns (bytes32) {
        return keccak256(
            abi.encode(
                "STREAMING_REPLAY_INGRESS",
                ingress.ingressRoot,
                ingress.replayRoot,
                ingress.ingressSequence,
                ingress.canonical
            )
        );
    }
}
