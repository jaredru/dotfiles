---
description: "Structural audit of how 2+ codebase areas fit together. Seams, layering, missing deps, shared primitives. Run before /refine."
---

You are performing a structural review of how a set of areas fit together
as a system. Your goal is to find misshapen seams, missing dependencies,
cross-cutting refactor opportunities, and shared infrastructure that
belongs in a neutral place.

`/seams` operates *between* areas — it asks whether these are the right
pieces, in the right places, talking to each other in the right shape.
It sits at the altitude above `/refine`, which asks whether each individual
file is well-written. When both apply, run `/seams` first: its conclusions
may relocate or delete files that `/refine` would otherwise polish.

## Determining the areas

Interpret $ARGUMENTS to build a list of areas. An area may be a file path,
directory, package name, or concept name (e.g. "quick send", "FX rate").
For concepts, resolve to concrete file sets by searching names, exports,
imports, and AGENTS.md indexes.

### Require at least two areas

`/seams` audits structure *between* areas. If $ARGUMENTS resolves to fewer
than two:

- **Single area** — respond: `Single-area review — use /refine instead.`
- **No arguments** — ask: `What areas should I audit? I need at least two — file paths, directories, packages, or concept names.`

Present the resolved areas to the user before proceeding:

> **Resolved to these areas:**
> - **Area A** (concept "quick send"): paths…
> - **Area B** (dir): paths…
>
> Proceed?

Wait for confirmation.

## Phase 1: Map

For each area, record:

- **Responsibilities** — what it owns, what it does not own
- **Public surface** — exports consumed by other areas
- **Dependencies in / out** — which other areas depend on it; which it depends on
- **Coupling modes** — dev-only vs production, test-only vs shared, platform-specific vs neutral
- **Cross-boundary patterns** — registries, providers, injection seams, delegates, event buses

**If there are more than two areas, dispatch the Map pass as parallel
read-only agents** (one per area) to protect main context. Each returns
the structured summary above. Do not dispatch for two-area audits —
sequential reading is faster than coordinating sub-agents.

## Phase 2: Seam audit

Scan across mapped areas for structural problems:

- **Duplicated concerns** — same problem solved differently in two areas
- **Layering violations** — production importing dev-only; reverse dependencies breaking intended layering
- **Thin wrappers** — adapters or facades that add no value and should collapse upstream
- **Dev/prod branching where a seam belongs** — `NODE_ENV` checks that should be dependency injection
- **Missing dependencies** — area X reimplements what area Y already provides
- **Misplaced primitives** — shared types or helpers embedded in one area that belong in a neutral upstream package

A finding must name concrete files and what's wrong. Speculative concerns
("this could get fragile") are not findings.

## Phase 3: Refactor pass

Beyond specific seam problems, identify cross-cutting opportunities
across:

- **Simplicity** — layers that can collapse across multiple areas
- **Encapsulation** — internals leaking across seams
- **Reuse** — parallel implementations that should consolidate
- **Consistency** — divergent conventions (naming, error handling, logging) across areas
- **Maintainability** — changes that currently require touching N areas and should require touching 1

Only surface opportunities where benefit is concrete and cost is bounded.
Do not invent work.

## Phase 4: Present the phased proposal

Output findings. Make no changes yet.

### Structural audit

**Areas reviewed:** [list]

### Healthy seams

State what's working and should be left alone — explicitly, even briefly.
This is a signal, not filler.

- **A ↔ B**: [what's working]

### Findings

Group by structural concern, **not by file**:

#### [Concern category]
- **[concrete observation]** — [files involved, what's wrong, what should change]

For any category with no findings, state so explicitly
("No layering violations found"). Silence ≠ checked.

### Phased plan

Default ordering (adjust only if findings require it, and state why):

1. **Foundational invariants** — boundary or contract tests that capture current behavior before rewiring. If they don't exist, later phases are unsafe.
2. **Neutral shared locations** — create the upstream package or module that misplaced primitives will move into.
3. **Factory/registry consolidations** — collapse duplicate factories, providers, or registries.
4. **Cross-area rewiring** — move code, adjust imports, update dependency directions.
5. **Parity/contract tests** — prove post-refactor behavior matches pre-refactor behavior.

For each phase:

- **Depends on:** earlier phases or external prerequisites
- **Scope:** files/areas touched
- **Budget:** S/M/L or hour range
- **Risk:** what could go wrong, what to test

---

**Wait for the user to approve, adjust, or reject the plan.** Approval
may be partial — execute only approved phases.

## Phase 5: Execute approved phases

Execute phases in order. After each phase:

1. Run `/verify` on the files changed.
2. Report what moved, what broke, what was added.
3. Wait for user go-ahead before starting the next phase.

Do not collapse phases for speed — the boundaries are the safety
boundaries. If a phase's scope grows mid-execution (e.g. rewiring reveals
more coupled code), stop and revise the plan with the user before
continuing.
