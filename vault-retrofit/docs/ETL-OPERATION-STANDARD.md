# ETL Operation Standard Library v1

## Overview

Defines a canonical execution identity model across smart contract systems.

## Operation Identity

operationId = keccak256(
    abi.encode(opType, target, payloadHash, nonce)
)

## Systems

- SAFE
- GOVERNOR
- TIMELOCK
- VAULT

## OP Types

- OP_SAFE_EXEC
- OP_GOV_EXEC
- OP_CANCEL
- OP_TIMELOCK_EXEC
- OP_VAULT_EXEC

## Event Schema

OperationExecuted(
    bytes32 systemId,
    bytes32 operationId,
    bytes32 opType,
    address target,
    bytes32 payloadHash,
    uint256 timestamp
)

## Purpose

- Cross-protocol traceability
- Deterministic execution identity
- ETL indexing compatibility
- Execution graph construction
