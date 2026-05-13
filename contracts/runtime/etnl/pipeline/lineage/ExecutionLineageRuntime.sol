// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

library ExecutionLineageRuntime {
    function deriveLineage(bytes32 priorLineage, bytes32 artifactRoot, bytes32 stageId)
        internal
        pure
        returns (bytes32)
    {
        return keccak256(abi.encode(priorLineage, artifactRoot, stageId));
    }
}
