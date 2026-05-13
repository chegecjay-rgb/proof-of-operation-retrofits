// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

library CanonicalReplayGraphTypes {
    enum NodeKind {
        Operation,
        Authority,
        Continuity,
        Temporal,
        Batch,
        ReplayEquivalence
    }

    struct ReplayDescriptor {
        bytes32 authorityId;
        bytes32 operationId;
        address target;
        bytes32 payloadHash;
        bytes32 parentOperationId;
        bytes32 continuityId;
        bytes32 temporalId;
        bytes32 batchId;
        uint256 operationIndex;
        uint256 scheduledAt;
        bytes32 executionContext;
    }

    struct GraphNode {
        bytes32 nodeId;
        NodeKind kind;
        bytes32 canonicalKey;
        bytes32 parentNodeId;
        bytes32 continuityKey;
        uint256 ordering;
    }
}

interface ICanonicalReplayGraphRuntime {
    function replayEquivalenceKey(address target, bytes32 payloadHash) external pure returns (bytes32);
    function operationNodeId(bytes32 operationId) external pure returns (bytes32);
    function authorityNodeId(bytes32 authorityId) external pure returns (bytes32);
    function continuityNodeId(bytes32 authorityId, bytes32 parentOperationId) external pure returns (bytes32);
    function temporalNodeId(bytes32 continuityId, uint256 scheduledAt) external pure returns (bytes32);
    function batchNodeId(bytes32 parentOperationId, uint256 operationIndex) external pure returns (bytes32);
    function replayOrderKey(uint256 operationIndex, bytes32 operationId) external pure returns (bytes32);
    function stitchContinuity(bytes32 sourceNodeId, bytes32 targetNodeId, bytes32 continuityType)
        external
        pure
        returns (bytes32);
    function buildOperationNode(CanonicalReplayGraphTypes.ReplayDescriptor calldata descriptor)
        external
        pure
        returns (CanonicalReplayGraphTypes.GraphNode memory);
    function buildAuthorityNode(bytes32 authorityId) external pure returns (CanonicalReplayGraphTypes.GraphNode memory);
    function buildReplayEquivalenceNode(address target, bytes32 payloadHash)
        external
        pure
        returns (CanonicalReplayGraphTypes.GraphNode memory);
}

library CanonicalReplayGraphPrimitives {
    function replayEquivalenceKey(address target, bytes32 payloadHash) internal pure returns (bytes32) {
        return keccak256(abi.encodePacked(target, payloadHash));
    }

    function operationNodeId(bytes32 operationId) internal pure returns (bytes32) {
        return keccak256(abi.encodePacked("OPERATION_NODE", operationId));
    }

    function authorityNodeId(bytes32 authorityId) internal pure returns (bytes32) {
        return keccak256(abi.encodePacked("AUTHORITY_NODE", authorityId));
    }

    function continuityNodeId(bytes32 authorityId, bytes32 parentOperationId) internal pure returns (bytes32) {
        return keccak256(abi.encodePacked("CONTINUITY_NODE", authorityId, parentOperationId));
    }

    function temporalNodeId(bytes32 continuityId, uint256 scheduledAt) internal pure returns (bytes32) {
        return keccak256(abi.encodePacked("TEMPORAL_NODE", continuityId, scheduledAt));
    }

    function batchNodeId(bytes32 parentOperationId, uint256 operationIndex) internal pure returns (bytes32) {
        return keccak256(abi.encodePacked("BATCH_NODE", parentOperationId, operationIndex));
    }

    function replayOrderKey(uint256 operationIndex, bytes32 operationId) internal pure returns (bytes32) {
        return keccak256(abi.encodePacked("REPLAY_ORDER", operationIndex, operationId));
    }

    function stitchContinuity(bytes32 sourceNodeId, bytes32 targetNodeId, bytes32 continuityType)
        internal
        pure
        returns (bytes32)
    {
        return keccak256(abi.encodePacked("CONTINUITY_EDGE", sourceNodeId, targetNodeId, continuityType));
    }

    function graphNode(
        bytes32 nodeId,
        CanonicalReplayGraphTypes.NodeKind kind,
        bytes32 canonicalKey,
        bytes32 parentNodeId,
        bytes32 continuityKey,
        uint256 ordering
    ) internal pure returns (CanonicalReplayGraphTypes.GraphNode memory) {
        return CanonicalReplayGraphTypes.GraphNode({
            nodeId: nodeId,
            kind: kind,
            canonicalKey: canonicalKey,
            parentNodeId: parentNodeId,
            continuityKey: continuityKey,
            ordering: ordering
        });
    }
}

contract CanonicalReplayGraphRuntime is ICanonicalReplayGraphRuntime {
    function replayEquivalenceKey(address target, bytes32 payloadHash) external pure returns (bytes32) {
        return CanonicalReplayGraphPrimitives.replayEquivalenceKey(target, payloadHash);
    }

    function operationNodeId(bytes32 operationId) external pure returns (bytes32) {
        return CanonicalReplayGraphPrimitives.operationNodeId(operationId);
    }

    function authorityNodeId(bytes32 authorityId) external pure returns (bytes32) {
        return CanonicalReplayGraphPrimitives.authorityNodeId(authorityId);
    }

    function continuityNodeId(bytes32 authorityId, bytes32 parentOperationId) external pure returns (bytes32) {
        return CanonicalReplayGraphPrimitives.continuityNodeId(authorityId, parentOperationId);
    }

    function temporalNodeId(bytes32 continuityId, uint256 scheduledAt) external pure returns (bytes32) {
        return CanonicalReplayGraphPrimitives.temporalNodeId(continuityId, scheduledAt);
    }

    function batchNodeId(bytes32 parentOperationId, uint256 operationIndex) external pure returns (bytes32) {
        return CanonicalReplayGraphPrimitives.batchNodeId(parentOperationId, operationIndex);
    }

    function replayOrderKey(uint256 operationIndex, bytes32 operationId) external pure returns (bytes32) {
        return CanonicalReplayGraphPrimitives.replayOrderKey(operationIndex, operationId);
    }

    function stitchContinuity(bytes32 sourceNodeId, bytes32 targetNodeId, bytes32 continuityType)
        external
        pure
        returns (bytes32)
    {
        return CanonicalReplayGraphPrimitives.stitchContinuity(sourceNodeId, targetNodeId, continuityType);
    }

    function buildOperationNode(CanonicalReplayGraphTypes.ReplayDescriptor calldata descriptor)
        external
        pure
        returns (CanonicalReplayGraphTypes.GraphNode memory)
    {
        bytes32 equivalenceKey =
            CanonicalReplayGraphPrimitives.replayEquivalenceKey(descriptor.target, descriptor.payloadHash);
        bytes32 nodeId = CanonicalReplayGraphPrimitives.operationNodeId(descriptor.operationId);
        bytes32 continuityKey =
            CanonicalReplayGraphPrimitives.continuityNodeId(descriptor.authorityId, descriptor.parentOperationId);
        bytes32 batchKey =
            CanonicalReplayGraphPrimitives.batchNodeId(descriptor.parentOperationId, descriptor.operationIndex);
        bytes32 orderingKey =
            CanonicalReplayGraphPrimitives.replayOrderKey(descriptor.operationIndex, descriptor.operationId);
        bytes32 canonicalKey =
            keccak256(abi.encodePacked("CANONICAL_OPERATION", equivalenceKey, continuityKey, batchKey, orderingKey));
        return CanonicalReplayGraphPrimitives.graphNode(
            nodeId,
            CanonicalReplayGraphTypes.NodeKind.Operation,
            canonicalKey,
            descriptor.parentOperationId,
            continuityKey,
            descriptor.operationIndex
        );
    }

    function buildAuthorityNode(bytes32 authorityId)
        external
        pure
        returns (CanonicalReplayGraphTypes.GraphNode memory)
    {
        bytes32 nodeId = CanonicalReplayGraphPrimitives.authorityNodeId(authorityId);
        bytes32 canonicalKey = keccak256(abi.encodePacked("CANONICAL_AUTHORITY", authorityId));
        return CanonicalReplayGraphPrimitives.graphNode(
            nodeId, CanonicalReplayGraphTypes.NodeKind.Authority, canonicalKey, bytes32(0), bytes32(0), 0
        );
    }

    function buildReplayEquivalenceNode(address target, bytes32 payloadHash)
        external
        pure
        returns (CanonicalReplayGraphTypes.GraphNode memory)
    {
        bytes32 nodeId = CanonicalReplayGraphPrimitives.replayEquivalenceKey(target, payloadHash);
        bytes32 canonicalKey = keccak256(abi.encodePacked("CANONICAL_REPLAY_EQUIVALENCE", target, payloadHash));
        return CanonicalReplayGraphPrimitives.graphNode(
            nodeId, CanonicalReplayGraphTypes.NodeKind.ReplayEquivalence, canonicalKey, bytes32(0), bytes32(0), 0
        );
    }
}
