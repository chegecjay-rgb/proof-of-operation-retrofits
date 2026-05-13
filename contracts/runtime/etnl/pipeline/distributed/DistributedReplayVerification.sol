// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

library DistributedReplayVerification {
    struct VerificationShard {
        bytes32 shardRoot;
        bytes32 verificationRoot;
        uint256 shardIndex;
        bool verified;
    }

    function verificationHash(VerificationShard memory shard) internal pure returns (bytes32) {
        return keccak256(
            abi.encode(
                "DISTRIBUTED_VERIFICATION", shard.shardRoot, shard.verificationRoot, shard.shardIndex, shard.verified
            )
        );
    }
}
