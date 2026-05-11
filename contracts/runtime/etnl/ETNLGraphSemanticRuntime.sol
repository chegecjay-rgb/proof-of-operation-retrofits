pragma solidity ^0.8.20;

import "./CanonicalETNLGraph.sol";

contract ETNLGraphSemanticRuntime {
    using CanonicalETNLGraph for CanonicalETNLGraph.SemanticNode[];

    event SemanticGraphConstructed(
        bytes32 indexed graphRoot,
        uint256 nodeCount
    );

    function deriveGraphRoot(
        CanonicalETNLGraph.SemanticNode[] memory nodes
    ) public pure returns (bytes32) {
        return nodes.graphRoot();
    }

    function emitGraphConstruction(
        CanonicalETNLGraph.SemanticNode[] memory nodes
    ) external returns (bytes32) {
        bytes32 root = deriveGraphRoot(nodes);

        emit SemanticGraphConstructed(
            root,
            nodes.length
        );

        return root;
    }
}
