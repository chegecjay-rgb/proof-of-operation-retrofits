# Canonical Semantic Injection Specification

## Objective

Attach deterministic semantic declaration directly to multisend iteration boundaries.

## Canonical Invariant

1 semantic authority action = 1 ProofOfOperation event

## Required Injection Boundary

Emitters MUST attach:
- inside operation iteration loops
- before operation execution
- within deterministic ordering scope

Emitters MUST NOT attach:
- after transaction settlement
- after aggregate execution
- within trace reconstruction systems

## Deterministic Replay Inputs

Replay reconstruction must require only:
- ProofOfOperation events
- parentOperationId
- operationIndex
- operationCount

## Semantic Equivalence

Equivalence normalization:
- target
- payloadHash

Independent of:
- batching topology
- delegatecall structure
- transaction envelope

## Safety Constraints

Retrofit MUST preserve:
- Safe execution semantics
- atomicity guarantees
- replay determinism
- authority semantics
- delegatecall topology

## Architectural Goal

Deterministic execution reconstruction without interpretation.
