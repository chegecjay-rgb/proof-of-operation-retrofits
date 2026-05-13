// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

interface ICanonicalPipelineStage {
    function stageId() external pure returns (bytes32);

    function stageVersion() external pure returns (uint256);

    function upstreamStage() external pure returns (bytes32);

    function deterministic() external pure returns (bool);
}
