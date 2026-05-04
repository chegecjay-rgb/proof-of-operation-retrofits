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

## Architecture

Safe → Governor → Timelock → Vault  
                 ↓  
        Unified Operation Identity

---

## Why This Matters

- Cross-protocol execution tracing  
- Deterministic execution identity  
- ETL indexing compatibility  
- Execution graph construction  

---

## Running

cd safe-retrofit && forge test  
cd governor-retrofit && forge test  
cd timelock-retrofit && forge build  
cd vault-retrofit && forge build  

---

## Status

All systems compliant with **ETL Operation Standard Library v1**

