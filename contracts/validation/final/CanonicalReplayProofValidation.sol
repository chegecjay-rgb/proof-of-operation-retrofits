pragma solidity ^0.8.20;

contract CanonicalReplayProofValidation {
    function deterministicReplayProof(bytes32 semanticRootA, bytes32 semanticRootB) external pure returns (bool) {
        return semanticRootA == semanticRootB;
    }

    function deterministicOrderingProof(uint256 operationIndexA, uint256 operationIndexB) external pure returns (bool) {
        return operationIndexA == operationIndexB;
    }

    function deterministicParentContinuityProof(bytes32 parentOperationIdA, bytes32 parentOperationIdB)
        external
        pure
        returns (bool)
    {
        return parentOperationIdA == parentOperationIdB;
    }
}
