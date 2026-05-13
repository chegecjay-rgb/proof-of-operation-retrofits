// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

library DeterministicGraphValidationTypes {
    struct ReplayProof {
        bytes32 topologyRoot;
        bytes32 topologyHash;
        bytes32 normalizationRoot;
        bytes32 equivalenceKey;
        bytes32 continuityKey;
        bytes32 orderingKey;
    }

    struct ValidationResult {
        bool topologyStable;
        bool normalizationStable;
        bool equivalenceStable;
        bool continuityStable;
        bool orderingStable;
        bytes32 validationRoot;
    }
}

interface IDeterministicGraphValidation {
    function topologyValidationKey(bytes32 topologyRoot, bytes32 topologyHash) external pure returns (bytes32);

    function normalizationValidationKey(bytes32 normalizationRoot) external pure returns (bytes32);

    function equivalenceValidationKey(bytes32 equivalenceKey) external pure returns (bytes32);

    function continuityValidationKey(bytes32 continuityKey) external pure returns (bytes32);

    function orderingValidationKey(bytes32 orderingKey) external pure returns (bytes32);

    function validationRoot(
        bytes32 topologyValidation,
        bytes32 normalizationValidation,
        bytes32 equivalenceValidation,
        bytes32 continuityValidation,
        bytes32 orderingValidation
    ) external pure returns (bytes32);

    function validateReplayProof(DeterministicGraphValidationTypes.ReplayProof calldata proof)
        external
        pure
        returns (DeterministicGraphValidationTypes.ValidationResult memory);
}

library DeterministicGraphValidationPrimitives {
    function topologyValidationKey(bytes32 topologyRoot, bytes32 topologyHash) internal pure returns (bytes32) {
        return keccak256(abi.encodePacked("TOPOLOGY_VALIDATION", topologyRoot, topologyHash));
    }

    function normalizationValidationKey(bytes32 normalizationRoot) internal pure returns (bytes32) {
        return keccak256(abi.encodePacked("NORMALIZATION_VALIDATION", normalizationRoot));
    }

    function equivalenceValidationKey(bytes32 equivalenceKey) internal pure returns (bytes32) {
        return keccak256(abi.encodePacked("EQUIVALENCE_VALIDATION", equivalenceKey));
    }

    function continuityValidationKey(bytes32 continuityKey) internal pure returns (bytes32) {
        return keccak256(abi.encodePacked("CONTINUITY_VALIDATION", continuityKey));
    }

    function orderingValidationKey(bytes32 orderingKey) internal pure returns (bytes32) {
        return keccak256(abi.encodePacked("ORDERING_VALIDATION", orderingKey));
    }

    function validationRoot(
        bytes32 topologyValidation,
        bytes32 normalizationValidation,
        bytes32 equivalenceValidation,
        bytes32 continuityValidation,
        bytes32 orderingValidation
    ) internal pure returns (bytes32) {
        return keccak256(
            abi.encodePacked(
                "VALIDATION_ROOT",
                topologyValidation,
                normalizationValidation,
                equivalenceValidation,
                continuityValidation,
                orderingValidation
            )
        );
    }
}

contract DeterministicGraphValidation is IDeterministicGraphValidation {
    function topologyValidationKey(bytes32 topologyRoot, bytes32 topologyHash) external pure returns (bytes32) {
        return DeterministicGraphValidationPrimitives.topologyValidationKey(topologyRoot, topologyHash);
    }

    function normalizationValidationKey(bytes32 normalizationRoot) external pure returns (bytes32) {
        return DeterministicGraphValidationPrimitives.normalizationValidationKey(normalizationRoot);
    }

    function equivalenceValidationKey(bytes32 equivalenceKey) external pure returns (bytes32) {
        return DeterministicGraphValidationPrimitives.equivalenceValidationKey(equivalenceKey);
    }

    function continuityValidationKey(bytes32 continuityKey) external pure returns (bytes32) {
        return DeterministicGraphValidationPrimitives.continuityValidationKey(continuityKey);
    }

    function orderingValidationKey(bytes32 orderingKey) external pure returns (bytes32) {
        return DeterministicGraphValidationPrimitives.orderingValidationKey(orderingKey);
    }

    function validationRoot(
        bytes32 topologyValidation,
        bytes32 normalizationValidation,
        bytes32 equivalenceValidation,
        bytes32 continuityValidation,
        bytes32 orderingValidation
    ) external pure returns (bytes32) {
        return DeterministicGraphValidationPrimitives.validationRoot(
            topologyValidation, normalizationValidation, equivalenceValidation, continuityValidation, orderingValidation
        );
    }

    function validateReplayProof(DeterministicGraphValidationTypes.ReplayProof calldata proof)
        external
        pure
        returns (DeterministicGraphValidationTypes.ValidationResult memory)
    {
        bytes32 topologyValidation =
            DeterministicGraphValidationPrimitives.topologyValidationKey(proof.topologyRoot, proof.topologyHash);

        bytes32 normalizationValidation =
            DeterministicGraphValidationPrimitives.normalizationValidationKey(proof.normalizationRoot);

        bytes32 equivalenceValidation =
            DeterministicGraphValidationPrimitives.equivalenceValidationKey(proof.equivalenceKey);

        bytes32 continuityValidation =
            DeterministicGraphValidationPrimitives.continuityValidationKey(proof.continuityKey);

        bytes32 orderingValidation = DeterministicGraphValidationPrimitives.orderingValidationKey(proof.orderingKey);

        bytes32 validationRootValue = DeterministicGraphValidationPrimitives.validationRoot(
            topologyValidation, normalizationValidation, equivalenceValidation, continuityValidation, orderingValidation
        );

        return DeterministicGraphValidationTypes.ValidationResult({
            topologyStable: topologyValidation != bytes32(0),
            normalizationStable: normalizationValidation != bytes32(0),
            equivalenceStable: equivalenceValidation != bytes32(0),
            continuityStable: continuityValidation != bytes32(0),
            orderingStable: orderingValidation != bytes32(0),
            validationRoot: validationRootValue
        });
    }
}
