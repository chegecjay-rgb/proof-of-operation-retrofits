// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "forge-std/Test.sol";

import "../../../../contracts/runtime/etnl/pipeline/stagegraph/CanonicalStageGraph.sol";

contract CanonicalStageGraphTest is Test {
    function testDeterministicStageGraphHashing() public pure {
        CanonicalStageGraph.StageNode memory node = CanonicalStageGraph.StageNode({
            stageId: keccak256("NORMALIZATION"),
            artifactRoot: keccak256("ARTIFACT"),
            executionIndex: 1,
            deterministic: true
        });

        bytes32 firstHash = CanonicalStageGraph.stageNodeHash(node);

        bytes32 secondHash = CanonicalStageGraph.stageNodeHash(node);

        assertEq(firstHash, secondHash);
    }
}
