# Timelock Retrofit

## Purpose

This retrofit extends Timelock execution scheduling with the
Proof-of-Operation (PoO) standard.

## Retrofit Objective

Create deterministic execution identities for scheduled operations.

operationId = keccak256(
    abi.encode(opType, target, payloadHash, nonce)
)

## PoO Integration

Scheduled execution emits:

OperationExecuted(
    systemId,
    operationId,
    opType,
    target,
    payloadHash,
    timestamp
)

## Ecosystem Position

Safe → Governor → Timelock → Vault

This retrofit allows scheduled operations to participate in
cross-system replay and execution verification.

## Implementation Anchors

src/TimelockControllerPoO.sol

src/poo/PoOEmitter.sol

## Verification

forge test
