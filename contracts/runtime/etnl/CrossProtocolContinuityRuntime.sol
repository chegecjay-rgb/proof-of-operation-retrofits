// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

library CrossProtocolContinuityTypes {
    enum ContinuityKind {
        Governance,
        Timelock,
        Batch,
        DelayedExecution,
        ExecutionLineage
    }

    struct ContinuityDescriptor {
        bytes32 sourceNodeId;
        bytes32 targetNodeId;
        bytes32 sourceOperationId;
        bytes32 targetOperationId;
        bytes32 parentOperationId;
        bytes32 authorityId;
        uint256 operationIndex;
        uint256 scheduledAt;
    }

    struct ContinuityEdge {
        bytes32 edgeId;
        ContinuityKind kind;
        bytes32 sourceNodeId;
        bytes32 targetNodeId;
        bytes32 continuityKey;
        uint256 ordering;
    }
}

interface ICrossProtocolContinuityRuntime {
    function governanceContinuityKey(bytes32 authorityId, bytes32 sourceOperationId, bytes32 targetOperationId)
        external
        pure
        returns (bytes32);

    function timelockContinuityKey(bytes32 sourceOperationId, bytes32 targetOperationId, uint256 scheduledAt)
        external
        pure
        returns (bytes32);

    function batchContinuityKey(bytes32 parentOperationId, uint256 operationIndex) external pure returns (bytes32);

    function delayedExecutionContinuityKey(bytes32 targetOperationId, uint256 scheduledAt)
        external
        pure
        returns (bytes32);

    function executionLineageContinuityKey(bytes32 sourceOperationId, bytes32 targetOperationId)
        external
        pure
        returns (bytes32);

    function buildGovernanceEdge(CrossProtocolContinuityTypes.ContinuityDescriptor calldata descriptor)
        external
        pure
        returns (CrossProtocolContinuityTypes.ContinuityEdge memory);

    function buildTimelockEdge(CrossProtocolContinuityTypes.ContinuityDescriptor calldata descriptor)
        external
        pure
        returns (CrossProtocolContinuityTypes.ContinuityEdge memory);

    function buildBatchEdge(CrossProtocolContinuityTypes.ContinuityDescriptor calldata descriptor)
        external
        pure
        returns (CrossProtocolContinuityTypes.ContinuityEdge memory);

    function buildDelayedExecutionEdge(CrossProtocolContinuityTypes.ContinuityDescriptor calldata descriptor)
        external
        pure
        returns (CrossProtocolContinuityTypes.ContinuityEdge memory);

    function buildExecutionLineageEdge(CrossProtocolContinuityTypes.ContinuityDescriptor calldata descriptor)
        external
        pure
        returns (CrossProtocolContinuityTypes.ContinuityEdge memory);
}

library CrossProtocolContinuityPrimitives {
    function governanceContinuityKey(bytes32 authorityId, bytes32 sourceOperationId, bytes32 targetOperationId)
        internal
        pure
        returns (bytes32)
    {
        return keccak256(abi.encodePacked("GOVERNANCE_CONTINUITY", authorityId, sourceOperationId, targetOperationId));
    }

    function timelockContinuityKey(bytes32 sourceOperationId, bytes32 targetOperationId, uint256 scheduledAt)
        internal
        pure
        returns (bytes32)
    {
        return keccak256(abi.encodePacked("TIMELOCK_CONTINUITY", sourceOperationId, targetOperationId, scheduledAt));
    }

    function batchContinuityKey(bytes32 parentOperationId, uint256 operationIndex) internal pure returns (bytes32) {
        return keccak256(abi.encodePacked("BATCH_CONTINUITY", parentOperationId, operationIndex));
    }

    function delayedExecutionContinuityKey(bytes32 targetOperationId, uint256 scheduledAt)
        internal
        pure
        returns (bytes32)
    {
        return keccak256(abi.encodePacked("DELAYED_EXECUTION_CONTINUITY", targetOperationId, scheduledAt));
    }

    function executionLineageContinuityKey(bytes32 sourceOperationId, bytes32 targetOperationId)
        internal
        pure
        returns (bytes32)
    {
        return keccak256(abi.encodePacked("EXECUTION_LINEAGE_CONTINUITY", sourceOperationId, targetOperationId));
    }

    function edgeId(bytes32 continuityKey, bytes32 sourceNodeId, bytes32 targetNodeId) internal pure returns (bytes32) {
        return keccak256(abi.encodePacked("CONTINUITY_EDGE", continuityKey, sourceNodeId, targetNodeId));
    }

    function continuityEdge(
        CrossProtocolContinuityTypes.ContinuityKind kind,
        bytes32 sourceNodeId,
        bytes32 targetNodeId,
        bytes32 continuityKey,
        uint256 ordering
    ) internal pure returns (CrossProtocolContinuityTypes.ContinuityEdge memory) {
        return CrossProtocolContinuityTypes.ContinuityEdge({
            edgeId: edgeId(continuityKey, sourceNodeId, targetNodeId),
            kind: kind,
            sourceNodeId: sourceNodeId,
            targetNodeId: targetNodeId,
            continuityKey: continuityKey,
            ordering: ordering
        });
    }
}

contract CrossProtocolContinuityRuntime is ICrossProtocolContinuityRuntime {
    function governanceContinuityKey(bytes32 authorityId, bytes32 sourceOperationId, bytes32 targetOperationId)
        external
        pure
        returns (bytes32)
    {
        return CrossProtocolContinuityPrimitives.governanceContinuityKey(
            authorityId, sourceOperationId, targetOperationId
        );
    }

    function timelockContinuityKey(bytes32 sourceOperationId, bytes32 targetOperationId, uint256 scheduledAt)
        external
        pure
        returns (bytes32)
    {
        return CrossProtocolContinuityPrimitives.timelockContinuityKey(
            sourceOperationId, targetOperationId, scheduledAt
        );
    }

    function batchContinuityKey(bytes32 parentOperationId, uint256 operationIndex) external pure returns (bytes32) {
        return CrossProtocolContinuityPrimitives.batchContinuityKey(parentOperationId, operationIndex);
    }

    function delayedExecutionContinuityKey(bytes32 targetOperationId, uint256 scheduledAt)
        external
        pure
        returns (bytes32)
    {
        return CrossProtocolContinuityPrimitives.delayedExecutionContinuityKey(targetOperationId, scheduledAt);
    }

    function executionLineageContinuityKey(bytes32 sourceOperationId, bytes32 targetOperationId)
        external
        pure
        returns (bytes32)
    {
        return CrossProtocolContinuityPrimitives.executionLineageContinuityKey(sourceOperationId, targetOperationId);
    }

    function buildGovernanceEdge(CrossProtocolContinuityTypes.ContinuityDescriptor calldata descriptor)
        external
        pure
        returns (CrossProtocolContinuityTypes.ContinuityEdge memory)
    {
        return CrossProtocolContinuityPrimitives.continuityEdge(
            CrossProtocolContinuityTypes.ContinuityKind.Governance,
            descriptor.sourceNodeId,
            descriptor.targetNodeId,
            CrossProtocolContinuityPrimitives.governanceContinuityKey(
                descriptor.authorityId, descriptor.sourceOperationId, descriptor.targetOperationId
            ),
            descriptor.operationIndex
        );
    }

    function buildTimelockEdge(CrossProtocolContinuityTypes.ContinuityDescriptor calldata descriptor)
        external
        pure
        returns (CrossProtocolContinuityTypes.ContinuityEdge memory)
    {
        return CrossProtocolContinuityPrimitives.continuityEdge(
            CrossProtocolContinuityTypes.ContinuityKind.Timelock,
            descriptor.sourceNodeId,
            descriptor.targetNodeId,
            CrossProtocolContinuityPrimitives.timelockContinuityKey(
                descriptor.sourceOperationId, descriptor.targetOperationId, descriptor.scheduledAt
            ),
            descriptor.operationIndex
        );
    }

    function buildBatchEdge(CrossProtocolContinuityTypes.ContinuityDescriptor calldata descriptor)
        external
        pure
        returns (CrossProtocolContinuityTypes.ContinuityEdge memory)
    {
        return CrossProtocolContinuityPrimitives.continuityEdge(
            CrossProtocolContinuityTypes.ContinuityKind.Batch,
            descriptor.sourceNodeId,
            descriptor.targetNodeId,
            CrossProtocolContinuityPrimitives.batchContinuityKey(
                descriptor.parentOperationId, descriptor.operationIndex
            ),
            descriptor.operationIndex
        );
    }

    function buildDelayedExecutionEdge(CrossProtocolContinuityTypes.ContinuityDescriptor calldata descriptor)
        external
        pure
        returns (CrossProtocolContinuityTypes.ContinuityEdge memory)
    {
        return CrossProtocolContinuityPrimitives.continuityEdge(
            CrossProtocolContinuityTypes.ContinuityKind.DelayedExecution,
            descriptor.sourceNodeId,
            descriptor.targetNodeId,
            CrossProtocolContinuityPrimitives.delayedExecutionContinuityKey(
                descriptor.targetOperationId, descriptor.scheduledAt
            ),
            descriptor.operationIndex
        );
    }

    function buildExecutionLineageEdge(CrossProtocolContinuityTypes.ContinuityDescriptor calldata descriptor)
        external
        pure
        returns (CrossProtocolContinuityTypes.ContinuityEdge memory)
    {
        return CrossProtocolContinuityPrimitives.continuityEdge(
            CrossProtocolContinuityTypes.ContinuityKind.ExecutionLineage,
            descriptor.sourceNodeId,
            descriptor.targetNodeId,
            CrossProtocolContinuityPrimitives.executionLineageContinuityKey(
                descriptor.sourceOperationId, descriptor.targetOperationId
            ),
            descriptor.operationIndex
        );
    }
}
