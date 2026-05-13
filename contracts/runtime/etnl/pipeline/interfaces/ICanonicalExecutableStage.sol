// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

interface ICanonicalExecutableStage {
    function stageId() external pure returns (bytes32);

    function stageVersion() external pure returns (uint256);

    function upstreamStage() external pure returns (bytes32);

    function deterministic() external pure returns (bool);

    function executable() external pure returns (bool);
}
