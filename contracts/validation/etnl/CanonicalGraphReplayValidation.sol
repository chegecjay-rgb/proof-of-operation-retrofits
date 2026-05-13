pragma solidity ^0.8.20;

import "../../runtime/etnl/CanonicalETNLGraph.sol";

contract CanonicalGraphReplayValidation {
    using CanonicalETNLGraph for CanonicalETNLGraph.SemanticNode[];

    function validateGraphDeterminism(CanonicalETNLGraph.SemanticNode[] memory nodes)
        external
        pure
        returns (bytes32 rootA, bytes32 rootB, bool deterministic)
    {
        rootA = nodes.graphRoot();
        rootB = nodes.graphRoot();

        deterministic = rootA == rootB;
    }
}
