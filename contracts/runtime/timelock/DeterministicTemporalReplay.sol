pragma solidity ^0.8.20;

library DeterministicTemporalReplay {
    function payloadHash(
        address target,
        uint256 value,
        bytes memory payload
    ) internal pure returns (bytes32) {
        return keccak256(
            abi.encode(
                target,
                value,
                keccak256(payload)
            )
        );
    }

    function operationId(
        address target,
        uint256 value,
        bytes memory payload,
        uint256 eta
    ) internal pure returns (bytes32) {
        return keccak256(
            abi.encode(
                target,
                value,
                keccak256(payload),
                eta
            )
        );
    }

    function parentOperationId(
        bytes32[] memory operationIds
    ) internal pure returns (bytes32) {
        return keccak256(
            abi.encode(operationIds)
        );
    }
}
