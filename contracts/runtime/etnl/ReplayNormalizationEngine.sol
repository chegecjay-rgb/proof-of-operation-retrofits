// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

library ReplayNormalizationTypes {
    struct ReplayDescriptor {
        bytes32 authorityId;
        bytes32 operationId;
        bytes32 parentOperationId;
        address target;
        bytes32 payloadHash;
        uint256 operationIndex;
        uint256 scheduledAt;
        bytes32 executionContext;
    }

    struct NormalizedReplay {
        bytes32 replayId;
        bytes32 equivalenceKey;
        bytes32 continuityKey;
        bytes32 orderingKey;
        bytes32 normalizationRoot;
    }
}

interface IReplayNormalizationEngine {
    function replayEquivalenceKey(address target, bytes32 payloadHash) external pure returns (bytes32);

    function continuityNormalizationKey(bytes32 authorityId, bytes32 parentOperationId) external pure returns (bytes32);

    function orderingNormalizationKey(uint256 operationIndex, bytes32 operationId) external pure returns (bytes32);

    function normalizationRoot(bytes32 equivalenceKey, bytes32 continuityKey, bytes32 orderingKey)
        external
        pure
        returns (bytes32);

    function normalizeReplay(ReplayNormalizationTypes.ReplayDescriptor calldata descriptor)
        external
        pure
        returns (ReplayNormalizationTypes.NormalizedReplay memory);
}

contract ReplayNormalizationEngine is IReplayNormalizationEngine {
    function replayEquivalenceKey(address target, bytes32 payloadHash) public pure returns (bytes32) {
        return keccak256(abi.encodePacked("REPLAY_EQUIVALENCE", target, payloadHash));
    }

    function continuityNormalizationKey(bytes32 authorityId, bytes32 parentOperationId) public pure returns (bytes32) {
        return keccak256(abi.encodePacked("CONTINUITY_NORMALIZATION", authorityId, parentOperationId));
    }

    function orderingNormalizationKey(uint256 operationIndex, bytes32 operationId) public pure returns (bytes32) {
        return keccak256(abi.encodePacked("ORDERING_NORMALIZATION", operationIndex, operationId));
    }

    function normalizationRoot(bytes32 equivalenceKey, bytes32 continuityKey, bytes32 orderingKey)
        public
        pure
        returns (bytes32)
    {
        return keccak256(abi.encodePacked("NORMALIZATION_ROOT", equivalenceKey, continuityKey, orderingKey));
    }

    function normalizeReplay(ReplayNormalizationTypes.ReplayDescriptor calldata descriptor)
        external
        pure
        returns (ReplayNormalizationTypes.NormalizedReplay memory)
    {
        bytes32 equivalenceKeyValue = replayEquivalenceKey(descriptor.target, descriptor.payloadHash);

        bytes32 continuityKeyValue = continuityNormalizationKey(descriptor.authorityId, descriptor.parentOperationId);

        bytes32 orderingKeyValue = orderingNormalizationKey(descriptor.operationIndex, descriptor.operationId);

        bytes32 normalizationRootValue = normalizationRoot(equivalenceKeyValue, continuityKeyValue, orderingKeyValue);

        return ReplayNormalizationTypes.NormalizedReplay({
            replayId: descriptor.operationId,
            equivalenceKey: equivalenceKeyValue,
            continuityKey: continuityKeyValue,
            orderingKey: orderingKeyValue,
            normalizationRoot: normalizationRootValue
        });
    }
}
