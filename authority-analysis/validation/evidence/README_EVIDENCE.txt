DOCUMENT: README.md

----- TITLE / OPENING -----
# Proof-of-Operation Retrofits

## 🔑 Key Idea

All execution across Ethereum systems can be reduced to:

operationId = keccak256(opType, target, payloadHash, nonce)

This repo enforces that standard across:

Safe → Governor → Timelock → Vault


## Architecture

Safe ──▶ Governor ──▶ Timelock ──▶ Vault

                  │

                  ▼

        OperationExecuted Event


## Determinism Guarantee

Identical inputs across systems produce identical operationIds.

Verified via:

- OperationIdDeterminism.t.sol


## Use Cases

- Execution tracing across protocols

- Indexer / ETL pipelines

- Governance analytics

- Security monitoring


---


## Overview

This repository implements a **canonical execution identity layer** across core Ethereum systems:

- Safe (Multisig)
- Governor (Governance)
- Timelock (Execution Scheduling)
- Vault (Asset Execution)

All systems emit a unified **Proof-of-Operation (PoO)** event.

---

## Canonical Operation Model

operationId = keccak256(
    abi.encode(opType, target, payloadHash, nonce)
)

---

## Unified Event Schema

OperationExecuted(
    bytes32 systemId,
    bytes32 operationId,
    bytes32 opType,
    address target,
    bytes32 payloadHash,
    uint256 timestamp
)

---

----- OBJECTIVE -----

----- ROLE -----
14:## Architecture
82:## Architecture

----- INVARIANTS -----

----- AUTHORITY SIGNALS -----
50:This repository implements a **canonical execution identity layer** across core Ethereum systems:
61:## Canonical Operation Model

----- REFERENCES -----
