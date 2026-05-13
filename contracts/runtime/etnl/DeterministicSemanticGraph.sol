// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

library DeterministicSemanticGraphTypes {
    struct GraphNode {
        bytes32 nodeId;
        bytes32 canonicalKey;
        bytes32 continuityKey;
        uint256 ordering;
    }

    struct GraphEdge {
        bytes32 edgeId;
        bytes32 sourceNodeId;
        bytes32 targetNodeId;
        bytes32 continuityKey;
        uint256 ordering;
    }

    struct GraphTopology {
        bytes32 graphRoot;
        bytes32 topologyHash;
        uint256 nodeCount;
        uint256 edgeCount;
    }
}

interface IDeterministicSemanticGraph {
    function graphNodeKey(bytes32 nodeId, bytes32 canonicalKey, bytes32 continuityKey, uint256 ordering)
        external
        pure
        returns (bytes32);

    function graphEdgeKey(
        bytes32 edgeId,
        bytes32 sourceNodeId,
        bytes32 targetNodeId,
        bytes32 continuityKey,
        uint256 ordering
    ) external pure returns (bytes32);

    function graphRoot(bytes32[] memory normalizedNodes, bytes32[] memory normalizedEdges)
        external
        pure
        returns (bytes32);

    function topologyHash(bytes32 graphRootValue, uint256 nodeCount, uint256 edgeCount) external pure returns (bytes32);

    function assembleTopology(
        DeterministicSemanticGraphTypes.GraphNode[] memory normalizedNodes,
        DeterministicSemanticGraphTypes.GraphEdge[] memory normalizedEdges
    ) external pure returns (DeterministicSemanticGraphTypes.GraphTopology memory);
}

contract DeterministicSemanticGraph is IDeterministicSemanticGraph {
    function graphNodeKey(bytes32 nodeId, bytes32 canonicalKey, bytes32 continuityKey, uint256 ordering)
        public
        pure
        returns (bytes32)
    {
        return keccak256(abi.encode("GRAPH_NODE", nodeId, canonicalKey, continuityKey, ordering));
    }

    function graphEdgeKey(
        bytes32 edgeId,
        bytes32 sourceNodeId,
        bytes32 targetNodeId,
        bytes32 continuityKey,
        uint256 ordering
    ) public pure returns (bytes32) {
        return keccak256(abi.encode("GRAPH_EDGE", edgeId, sourceNodeId, targetNodeId, continuityKey, ordering));
    }

    function graphRoot(bytes32[] memory normalizedNodes, bytes32[] memory normalizedEdges)
        public
        pure
        returns (bytes32)
    {
        bytes32 nodesAccumulator;
        bytes32 edgesAccumulator;

        for (uint256 i = 0; i < normalizedNodes.length; i++) {
            nodesAccumulator = keccak256(abi.encode(nodesAccumulator, normalizedNodes[i]));
        }

        for (uint256 i = 0; i < normalizedEdges.length; i++) {
            edgesAccumulator = keccak256(abi.encode(edgesAccumulator, normalizedEdges[i]));
        }

        return keccak256(abi.encode("GRAPH_ROOT", nodesAccumulator, edgesAccumulator));
    }

    function topologyHash(bytes32 graphRootValue, uint256 nodeCount, uint256 edgeCount) public pure returns (bytes32) {
        return keccak256(abi.encode("TOPOLOGY_HASH", graphRootValue, nodeCount, edgeCount));
    }

    function assembleTopology(
        DeterministicSemanticGraphTypes.GraphNode[] memory normalizedNodes,
        DeterministicSemanticGraphTypes.GraphEdge[] memory normalizedEdges
    ) public pure returns (DeterministicSemanticGraphTypes.GraphTopology memory) {
        bytes32[] memory nodeKeys = new bytes32[](normalizedNodes.length);

        bytes32[] memory edgeKeys = new bytes32[](normalizedEdges.length);

        for (uint256 i = 0; i < normalizedNodes.length; i++) {
            nodeKeys[i] = graphNodeKey(
                normalizedNodes[i].nodeId,
                normalizedNodes[i].canonicalKey,
                normalizedNodes[i].continuityKey,
                normalizedNodes[i].ordering
            );
        }

        for (uint256 i = 0; i < normalizedEdges.length; i++) {
            edgeKeys[i] = graphEdgeKey(
                normalizedEdges[i].edgeId,
                normalizedEdges[i].sourceNodeId,
                normalizedEdges[i].targetNodeId,
                normalizedEdges[i].continuityKey,
                normalizedEdges[i].ordering
            );
        }

        bytes32 graphRootValue = graphRoot(nodeKeys, edgeKeys);

        bytes32 topologyHashValue = topologyHash(graphRootValue, normalizedNodes.length, normalizedEdges.length);

        return DeterministicSemanticGraphTypes.GraphTopology({
            graphRoot: graphRootValue,
            topologyHash: topologyHashValue,
            nodeCount: normalizedNodes.length,
            edgeCount: normalizedEdges.length
        });
    }
}
