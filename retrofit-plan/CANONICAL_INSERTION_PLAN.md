# Canonical Safe Semantic Retrofit Insertion Plan

## Objective

Attach deterministic ProofOfOperation emission directly to Safe multisend authority-action execution boundaries.

## Canonical Invariant

1 semantic authority action = 1 ProofOfOperation event

## Required Injection Point

Semantic emitters MUST attach:
- inside multisend execution iteration loops
- before execution dispatch
- after operation decoding
- within deterministic ordering scope

## Prohibited Injection Points

- transaction settlement boundaries
- post-execution aggregation layers
- trace reconstruction systems
- external indexing layers

## Deterministic Metadata Requirements

Each emitted operation MUST expose:
- operationId
- parentOperationId
- operationIndex
- operationCount
- payloadHash

## Topology Reconstruction Inputs

Deterministic replay reconstruction must require only:
- ProofOfOperation events
- ordering metadata
- topology grouping metadata

WITHOUT:
- traces
- calldata unpacking heuristics
- protocol-specific parsers

## Safety Constraints

Retrofit MUST preserve:
- Safe execution semantics
- delegatecall topology
- replay determinism
- execution ordering
- atomicity guarantees

## Required Outcome

Deterministic multisend reconstruction without interpretation.
