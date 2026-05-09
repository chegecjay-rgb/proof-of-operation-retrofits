// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract GovernorReplayValidationVectors {
    struct ValidationVector {
        bytes32 proposalId;
        address target;
        uint256 value;
        bytes payload;
        uint16 operationIndex;
        uint16 operationCount;
    }

    function sampleValidationVector()
        external
        pure
        returns (ValidationVector memory)
    {
        return ValidationVector({
            proposalId: keccak256("PROPOSAL_ALPHA"),
            target: address(0x1234),
            value: 0,
            payload: abi.encodeWithSignature(
                "transfer(address,uint256)",
                address(0x5678),
                100
            ),
            operationIndex: 0,
            operationCount: 1
        });
    }

    function normalizedPayloadHash(
        bytes memory payload
    ) external pure returns (bytes32) {
        return keccak256(payload);
    }

    function normalizedEquivalence(
        address target,
        bytes memory payload
    ) external pure returns (bytes32) {
        return keccak256(
            abi.encode(
                target,
                keccak256(payload)
            )
        );
    }
}
