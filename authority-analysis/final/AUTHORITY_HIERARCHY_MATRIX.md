# AUTHORITY HIERARCHY MATRIX

## Method

This matrix is derived exclusively from:

- README.md
- docs/PUBLICATION_ARCHITECTURE_OVERVIEW.md
- live-semantic-adapter/specs/SAFE_SEMANTIC_ADAPTER_SPEC.md
- pilot-integration/specs/PILOT_INTEGRATION_SPEC.md
- semantic-injection/specs/SEMANTIC_INJECTION_SPEC.md
- semantic-live-binding/specs/SEMANTIC_MULTISEND_SHADOW_SPEC.md
- shadow-retrofit/specs/SHADOW_RETROFIT_SPEC.md

No semantic reconstruction was performed.

No runtime reconstruction was performed.

No certification conclusions were produced.

---

| Document | Purpose | Authority Level | References | Referenced By | Normative? |
|----------|----------|----------------|------------|---------------|------------|
| README.md | Repository charter defining Proof-of-Operation model, architecture, deterministic identity, and ecosystem scope. | L0 Constitutional Root | None explicitly declared | All subsystem specifications derive repository purpose from this document. | Y |
| docs/PUBLICATION_ARCHITECTURE_OVERVIEW.md | Publication-layer architecture, verifier boundaries, ecosystem positioning, constitutional constraints. | L1 Architectural Authority | README.md (implicit repository architecture context) | Retrofit and semantic specifications operating inside publication architecture. | Y |
| SAFE_SEMANTIC_ADAPTER_SPEC.md | Defines semantic adapter behavior and replay-safe metadata derivation. | L2 Implementation Specification | Repository architecture, ProofOfOperation model. | Pilot integrations and semantic retrofit implementations. | Y |
| PILOT_INTEGRATION_SPEC.md | Defines pilot integration behavior attached to Safe execution boundaries. | L2 Implementation Specification | ProofOfOperation model, semantic adapter concepts. | Pilot integration artifacts. | Y |
| SEMANTIC_INJECTION_SPEC.md | Defines canonical injection location and replay requirements. | L2 Implementation Specification | ProofOfOperation model, semantic declaration architecture. | Injection implementations and replay reconstruction logic. | Y |
| SEMANTIC_MULTISEND_SHADOW_SPEC.md | Defines semantic shadow layer behavior without modifying MultiSend engine. | L2 Implementation Specification | ProofOfOperation model, replay reconstruction requirements. | Shadow semantic implementations. | Y |
| SHADOW_RETROFIT_SPEC.md | Defines production-safe retrofit convergence layer and operational constraints. | L2 Implementation Specification | ProofOfOperation model, replay requirements, Safe topology preservation. | Production retrofit implementations. | Y |

---

## Preliminary Hierarchy

L0
└── README.md

L1
└── docs/PUBLICATION_ARCHITECTURE_OVERVIEW.md

L2
├── SAFE_SEMANTIC_ADAPTER_SPEC.md
├── PILOT_INTEGRATION_SPEC.md
├── SEMANTIC_INJECTION_SPEC.md
├── SEMANTIC_MULTISEND_SHADOW_SPEC.md
└── SHADOW_RETROFIT_SPEC.md

---

## Observed Constitutional Invariants

Repeated across multiple normative specifications:

- 1 semantic authority action = 1 ProofOfOperation event
- replay determinism
- preservation of authority semantics
- preservation of execution ordering
- preservation of delegatecall topology
- reconstruction without traces
- additive semantic declaration
- prohibition on interpretive execution analysis

---

## Analyst Notes

The specifications exhibit strong semantic convergence.

All implementation specifications inherit a common ProofOfOperation model.

No conflicting authority sources were observed within the harvested evidence.

Topology reconstruction remains OUT OF SCOPE for TASK-L1-001.

