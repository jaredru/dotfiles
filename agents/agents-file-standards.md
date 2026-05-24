# AGENTS File Standards

How to write, evaluate, and maintain AGENTS.md and DECISIONS.md files in
this repository. This document is not loaded into agent context by default —
it is read on demand when auditing or updating agent guidance files.

## Purpose

AGENTS.md files exist for one reason: to change agent behavior for the
better. Every line in an AGENTS file consumes context window space in every
session that loads it. Content that doesn't measurably improve agent output
is a tax on the content that does.

## Core Principles

### 1. Context Window is a Scarce Resource

AGENTS files are auto-loaded into context. Every line competes with the
code the agent needs to read, the conversation history, and the tool
outputs. A 500-line AGENTS file means 500 fewer lines of code context.
Treat context space like production memory — budget it, measure it, and
reclaim it when something isn't earning its keep.

### 2. Optimize for Default Behavior, Not Edge Cases

The primary audience is an agent doing a routine task: fixing a bug,
implementing a feature, writing a test. If a rule only matters during
deployment or one-time setup, it belongs in a reference doc, not in the
always-loaded guide. Ask: "Does an agent working on a typical PR need
this?"

### 3. Rules Over Reference

AGENTS files should contain rules (what to do and not do), not reference
material (configuration tables, setup tutorials, deployment DNS records).
Rules change behavior. Reference material answers questions that arise
during specific tasks — it should be reachable, not pre-loaded.

### 4. Earned Through Failure

The highest-value content in an AGENTS file is a rule that prevents a
mistake agents actually make. The "Common Mistakes" section exists because
those mistakes happened. Hypothetical guardrails that have never been
triggered are worth less than battle-tested ones.

### 5. Single Source of Truth

Every fact should live in exactly one place. If a decision is in
DECISIONS.md, AGENTS.md should reference it, not repeat it. If a command
is in the component's AGENTS.md, the root AGENTS.md should not also list
it. Duplication creates drift and doubles the context cost.

### 6. Files Decay — Maintain Them

AGENTS files reflect a snapshot of the codebase. When the codebase changes
and the AGENTS file doesn't, the file becomes misleading. Stale content is
worse than missing content because agents trust it. Regular audits (see
Evaluation Checklist) catch drift before it causes harm.

## Inclusion Criteria

Before adding content to any AGENTS.md, it must pass ALL of these tests:

1. **Behavioral impact.** An agent would produce different (worse) output
   on a routine task without this information. If removing it wouldn't
   change anything, it doesn't belong.

2. **Frequency.** The situation it addresses comes up regularly — at least
   once every few work sessions. One-time setup instructions and rare
   deployment procedures belong in reference docs.

3. **Not discoverable.** The agent couldn't figure this out by reading the
   code, running tests, or checking error messages. If `opctl run lint`
   tells you the rule, the AGENTS file doesn't need to.

4. **Actionable.** It tells the agent what to DO (or not do), not just
   what to KNOW. "Use value receivers on the api struct" is actionable.
   "The service was deployed in February" is not.

5. **Not duplicated.** This exact information doesn't exist in another
   loaded file (another AGENTS.md, a reference doc that's already
   pointed to, or the code itself via comments).

6. **Current.** It reflects the actual state of the codebase today.

## Exclusion Criteria

Move content OUT of AGENTS.md if any of these are true:

1. **Setup tutorial.** Step-by-step instructions for one-time setup
   (OAuth app registration, first-run admin creation, tool installation).
   Move to a SETUP.md or relevant reference doc.

2. **Configuration reference.** Environment variable tables, CLI flag
   lists, deployment DNS records. Move to a CONFIG.md or inline code
   comments.

3. **Deployment procedures.** Forge commands, registration steps, IRSA
   permissions. Move to a DEPLOY.md or ops runbook.

4. **Historical status.** "WP-12 added this table" annotations that
   describe how things came to be rather than how they are now. Remove
   or move to DECISIONS.md.

5. **Code examples longer than 5 lines.** Extended code samples belong
   in the codebase itself (test files, example files) or reference docs.
   AGENTS files should have brief inline examples at most.

6. **Content that restates what a reference doc covers.** If
   `testing-standards.md` covers behavioral testing rules, don't
   summarize them again in AGENTS.md. A one-line pointer is enough.

## Size Guidelines

These are audit triggers, not ceilings. When a file exceeds the guideline,
run the evaluation checklist. If every section passes the inclusion
criteria, the file is fine at its current size. A 350-line file where
every line changes agent behavior is better than a 150-line file with
filler.

### Root AGENTS.md

| Section | Guideline | Notes |
|---------|-----------|-------|
| Current Focus | 3-5 lines | Phase + active WPs only |
| How to Start Working | 5-10 lines | |
| Context Loading Guide | 20-30 lines | High value — keep |
| Ground Rules | 80-120 lines | All rules combined |
| Component Boundaries | 15-20 lines | |
| Git Workflow | 10-15 lines | |
| **Total** | **~200 lines** | Audit if exceeding 250 |

### Component AGENTS.md

| Section | Guideline | Notes |
|---------|-----------|-------|
| Quick Context | 5-8 lines | Stack, test cmd, lint cmd, key constraint, state |
| Common Mistakes | 3-7 bullets | One line each, earned through failure |
| What This Component Does | 3-5 lines | |
| Key Files | 15-40 lines | Flat list, <=10 words per entry; complex components need more |
| How to Build and Test | 20-40 lines | Commands + prerequisites, not tutorials |
| Architecture / Constraints | 10-20 lines | Rules that change coding behavior |
| Interface Requirements | 10-20 lines | Contracts consumed or exposed |
| Status | 3-5 lines | Current state only |
| Key Decisions | 10-20 lines | Numbers + one-line summaries; full text in DECISIONS.md |
| Known Issues / Gotchas | 0-10 lines | Active issues only |
| **Total** | **~200 lines** | Audit if exceeding 300; complex components (portal, API) may legitimately need more |

### DECISIONS.md

No hard size limit, but apply lifecycle management:

- Decisions that have been superseded should note the superseding decision
  and can be archived after 2+ phases of inactivity.
- When a DECISIONS.md exceeds ~100 entries, archive older phases to
  `docs/archive/<component>-decisions-<phases>.md`.

## Structural Template

Component AGENTS.md files should follow this order. Sections can be
omitted if genuinely empty, but the order should be consistent.

```
# <Component Name> — Agent Guide

## Quick Context
## Common Mistakes
## What This Component Does
## Key Files
## How to Build and Test
## <Architecture / Constraints / Conventions> (component-specific title)
## Interface Requirements
## Status
## Key Decisions
## Known Issues / Gotchas
```

## DECISIONS.md Lifecycle

### What belongs in a decision entry

A decision entry should answer:
1. What was decided?
2. Why was it chosen over alternatives?
3. What should a future agent do differently because of it?
4. Does it supersede an earlier decision?

If question 3 has no meaningful answer ("nothing changes for agents"),
the decision is informational and may not need an entry.

### When to promote to AGENTS.md Key Decisions

A decision belongs in AGENTS.md Key Decisions only if an agent working on
a routine task in that component would produce wrong output without knowing
it. Example: "api struct uses value receivers" — an agent would write
pointer receivers without this. Counter-example: "Coder v2.29.6 pinned" —
the agent isn't choosing the Coder version.

### When to archive

When a DECISIONS.md exceeds ~100 entries or ~400 lines, move completed-
phase decisions to `docs/archive/<component>-decisions-<phases>.md` with
a pointer at the top of DECISIONS.md.

## Anti-Patterns

These patterns tend to bloat AGENTS files. Watch for them during audits.

1. **The encyclopedia.** AGENTS file tries to be a complete reference for
   the component. Symptoms: env var tables, deployment DNS, full schema
   history. Fix: extract to reference docs.

2. **The incident response.** A mistake happened, so a detailed rule was
   added with extensive rationale and examples. Symptoms: multi-paragraph
   rules, inline code examples > 5 lines. Fix: tighten to a 1-2 sentence
   rule; move rationale to DECISIONS.md.

3. **The echo.** Same rule appears in root AGENTS, component AGENTS, and
   a reference doc. Symptoms: searching for a phrase finds 3+ matches.
   Fix: canonical location + pointers.

4. **The changelog.** Status sections or schema notes that describe how
   things evolved rather than how they are now. Symptoms: "Added in WP-10a",
   "WP-12 implemented this." Fix: current state only; history in
   DECISIONS.md.

5. **The tutorial.** Step-by-step setup instructions with screenshots or
   extensive shell commands. Symptoms: numbered steps > 5, commands with
   placeholder values to fill in. Fix: move to SETUP.md or runbook.

6. **The safety blanket.** Rules that make the author feel safer but
   don't change agent behavior because the agent would never do the thing
   being prohibited. Symptoms: "Do not modify files outside this
   directory" (the agent already knows its scope from root AGENTS).
   Fix: remove unless the violation has actually occurred.

## Evaluation Checklist

Use this checklist to audit any AGENTS.md file. For each item, answer
yes/no and note the action.

### Per-File Audit

1. **Line count.** Is the file above its size guideline? If so, which
   sections are largest? Do they all pass the inclusion criteria?

2. **Quick Context freshness.** Does the "Current state" and "Last
   updated" match reality? Are the test/lint commands still correct?

3. **Common Mistakes relevance.** Has each mistake actually occurred in
   the last 2-3 phases of work? Remove stale entries.

4. **Key Files accuracy.** Do all listed files still exist? Are
   descriptions still accurate? Are new important files missing?

5. **Build/Test commands.** Do all listed commands actually work? Run
   them.

6. **Reference material.** Are there env var tables, deployment
   procedures, or setup tutorials that should be in reference docs?

7. **Redundancy.** Does any content duplicate what's in the root
   AGENTS.md, a reference doc, or another component's AGENTS.md?

8. **Staleness.** Are there WP references, status annotations, or
   "current state" descriptions that no longer reflect reality?

9. **Key Decisions alignment.** Does every Key Decision entry still
   change routine agent behavior? Are there DECISIONS.md entries that
   should be promoted?

10. **Known Issues.** Are listed issues still active? Remove resolved
    ones.

### Cross-File Audit

1. **Root AGENTS echoes.** Does the root AGENTS.md restate rules that
   are already in reference docs or component guides?

2. **Consistent structure.** Do all component AGENTS files follow the
   structural template in the same order?

3. **Pointer integrity.** Do all "see X for details" references point
   to files that exist and contain the referenced content?

4. **Total context load.** For the most common task type (single-
   component feature work), how many lines of agent guidance are loaded?
   Guideline: ~500 lines (root AGENTS + component AGENTS). Audit if
   exceeding 700.

## Maintenance Cadence

- **Per-WP:** Update Status and Key Decisions in the touched component's
  AGENTS.md. Record new decisions in DECISIONS.md.
- **Per-phase:** Run the Per-File Audit on all AGENTS files touched
  during the phase. Run the Cross-File Audit once.
- **Quarterly or after 3 phases:** Full audit of all files. Archive old
  decisions. Check total context loads against guidelines.
