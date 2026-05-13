pragma solidity ^0.8.20;

library CanonicalETNLGraph {
    struct SemanticNode {
        bytes32 nodeId;
        bytes32 parentNodeId;
        bytes32 semanticRoot;
        uint256 operationIndex;
    }

    function semanticNodeHash(SemanticNode memory node) internal pure returns (bytes32) {
        return keccak256(abi.encode(node.nodeId, node.parentNodeId, node.semanticRoot, node.operationIndex));
    }

    function graphRoot(SemanticNode[] memory nodes) internal pure returns (bytes32 root) {
        bytes memory normalized;

        for (uint256 i = 0; i < nodes.length; i++) {
            normalized = abi.encodePacked(normalized, semanticNodeHash(nodes[i]));
        }

        root = keccak256(normalized);
    }
}
