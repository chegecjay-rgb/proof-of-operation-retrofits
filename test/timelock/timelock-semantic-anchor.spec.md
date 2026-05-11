# Timelock Semantic Continuity Anchor

## Canonical Runtime Targets

- DeterministicTemporalReplay.sol
- TimelockSemanticRuntime.sol
- ITimelockSemanticEvents.sol

## Deterministic Replay Guarantees

same scheduled execution
-> same operationId
-> same parentOperationId
-> same payloadHash
-> same replay topology

## Canonical Invariants

- trace independence
- deterministic ordering
- metadata-only execution continuity
- replay-stable payload normalization
- additive semantic declaration only

## Canonical Integration Surfaces

- queueTransaction
- executeTransaction
- schedule
- scheduleBatch
- executeBatch

## Canonical Replay Equivalence

target + value + keccak256(payload)

## Canonical Parent Continuity

keccak256(operationIds)

