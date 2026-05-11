pragma solidity ^0.8.20;

library DeterministicBatchTemporalTopology {
    struct TemporalOperation {
        address target;
        uint256 value;
        bytes payload;
        uint256 eta;
    }

    function operationHash(
        TemporalOperation memory operation
    ) internal pure returns (bytes32) {
        return keccak256(
            abi.encode(
                operation.target,
                operation.value,
                keccak256(operation.payload),
                operation.eta
            )
        );
    }

    function deterministicBatchRoot(
        TemporalOperation[] memory operations
    ) internal pure returns (bytes32 batchRoot) {
        bytes memory normalized;

        for (uint256 i = 0; i < operations.length; i++) {
            normalized = abi.encodePacked(
                normalized,
                operationHash(operations[i])
            );
        }

        batchRoot = keccak256(normalized);
    }
}
