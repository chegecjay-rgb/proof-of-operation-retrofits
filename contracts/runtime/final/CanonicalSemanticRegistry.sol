pragma solidity ^0.8.20;

contract CanonicalSemanticRegistry {
    struct SemanticCheckpoint {
        bytes32 semanticRoot;
        bytes32 parentRoot;
        uint256 operationIndex;
        uint256 timestamp;
    }

    mapping(bytes32 => SemanticCheckpoint) public checkpoints;

    event SemanticCheckpointRegistered(
        bytes32 indexed semanticRoot,
        bytes32 indexed parentRoot,
        uint256 operationIndex,
        uint256 timestamp
    );

    function registerCheckpoint(
        bytes32 semanticRoot,
        bytes32 parentRoot,
        uint256 operationIndex
    ) external {
        checkpoints[semanticRoot] = SemanticCheckpoint({
            semanticRoot: semanticRoot,
            parentRoot: parentRoot,
            operationIndex: operationIndex,
            timestamp: block.timestamp
        });

        emit SemanticCheckpointRegistered(
            semanticRoot,
            parentRoot,
            operationIndex,
            block.timestamp
        );
    }
}
