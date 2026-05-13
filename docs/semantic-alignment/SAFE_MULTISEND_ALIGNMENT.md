# Safe Multisend Semantic Declaration Alignment

## Canonical Invariant

1 semantic authority action = 1 ProofOfOperation event

## Required Event Shape

event ProofOfOperation(
    bytes32 indexed operationId,
    bytes32 indexed systemId,
    address indexed executor,
    address target,
    uint256 value,
    bytes32 payloadHash,
    bytes32 parentOperationId,
    uint8 executionContext,
    uint16 operationIndex,
    uint16 operationCount
);

## Deterministic Semantic Rules

- Each multisend operation emits one ProofOfOperation event
- All operations within the same batch share parentOperationId
- operationIndex + operationCount preserve deterministic ordering
- Semantic equivalence normalizes using target + payloadHash
- executionContext remains metadata-only

## Prohibited Reconstruction Strategies

- Trace walking
- Delegatecall inference
- Calldata unpacking heuristics
- Protocol-specific parsers

## Deterministic Reconstruction Inputs

- ProofOfOperation events
- parentOperationId
- operationIndex
- operationCount

## Retrofit Requirements

- Preserve Safe execution semantics
- Preserve atomic execution guarantees
- Preserve replay determinism
- Preserve authority semantics
- Additive semantic disclosure only

## Canonical Integration Boundary

Emitters attach at multisend iteration boundaries.

Not transaction settlement boundaries.

## Replay-Stable Parent Derivation

parentOperationId = keccak256(
    abi.encodePacked(
        safeTxHash,
        nonce
    )
);

## Semantic Equivalence

semanticHash = keccak256(
    abi.encodePacked(
        target,
        payloadHash
    )
);
