---
description: "Codebase-wide audit across five dimensions (hygiene → horizon). Fans out blind reviewers, operator synthesizes, produces a tiered work plan. Use for pre-rollout reviews, health checks, or broad evaluations larger than a single PR."
---

You are producing a broad evaluation of a codebase or major subtree.
Your goal is an honest picture of what's shipping-ready, what's drifting,
and what paradigms the code should move toward — followed by a tiered
work plan the user can act on.

`/audit` sits above `/seams` (which looks between 2+ areas) and `/refine`
(which looks per-file). It subsumes both lenses and adds goal-alignment
and architectural-horizon passes. If the scope is one PR, one file, or
one bug, use `/review` or `/refine` instead — do not spawn an audit.

## Determining the target

Interpret $ARGUMENTS as the audit target: a repo root, a package, a
directory tree, or a concept. Resolve concepts to concrete paths before
proceeding.

**No arguments means "audit the whole current project"** — resolve to
the git toplevel (`git rev-parse --show-toplevel`), or the current
working directory if not a repo. Don't prompt for a target in this
case; proceed to Phase 0 and let the survey drive the plan.

## Phase 0: Survey, choose a mode, get approval

Survey the target with Glob/Grep/Bash:

- Inventory of units (packages, modules, or top-level directories)
- Rough size per unit (file count, LOC)
- Existing AGENTS.md / README / PLAN.md / DECISIONS.md per unit
- A **calibration candidate** — a unit or pattern the user considers
  exemplary (for grading the rest against). If nothing jumps out, pick
  the unit that looks healthiest and flag the choice for confirmation.
- A **goal statement** — load from PLAN.md / DECISIONS.md / charter if
  present. If absent, ask the user for a one-paragraph summary of what
  this codebase is trying to do. Goal alignment is undefined without it.

### Choose execution mode

Fan-out is not mandatory. Pick based on what the survey found:

- **Inline** — one pass, no sub-agents, operator is the reviewer.
  Right when the target fits comfortably in one agent's context:
  roughly a single package or small repo, one coherent theme, ~50
  source files or fewer. Dotfiles, a single library, a small service.
- **Small fan-out (3–8 reviewers)** — the target has a few natural
  units each deserving a deep pass, but the operator can still hold
  the whole picture.
- **Full fan-out (10+ reviewers)** — scope exceeds any one agent's
  reasonable context budget: monorepos, large trees, many packages.

Prefer the lightest mode that still covers the scope. Do not default
to fan-out — the overhead is real and many audits don't need it.

### Present the plan and wait for approval

> **Audit plan:**
> - **Target:** [path]
> - **Mode:** [inline | small fan-out | full fan-out] — because [reason]
> - **Review units (fan-out only):** [list, one reviewer each]
> - **Calibration:** [unit or pattern]
> - **Goal statement:** [one paragraph, sourced or provided]
> - **Exclusions:** generated code, vendored deps, build artifacts, [other]
> - **Output location:** `<target>/audit/`
> - **Estimated cost:** [inline: one pass] or [~N agents × ~30 min]
>
> Proceed?

Do not spawn reviewers or write output before approval.

## The rubric (all five dimensions, every reviewer)

1. **Per-file hygiene** — dead code, unsafe types, over-abstractions,
   WHAT comments, speculative generalization.
2. **Per-package factoring** — API surface, module boundaries, test
   discipline, doc accuracy. "Should this be two packages? One?"
3. **Systemic coherence** — for each cross-cutting concern (auth,
   routing, logging, flags, mocks, analytics, platform branches, etc.):
   does this unit share one seam with the rest, or fork its own? Is the
   seam enforced (lint, type barrier, CI) or convention-only? Grade
   against the calibration pattern from Phase 0.
4. **Goal alignment** — does this unit serve the stated goal? Load-
   bearing, or scope creep?
5. **Architectural horizon** — is this the right problem being solved
   with the right tools? Name specific ecosystem or paradigm shifts
   that would obviate code here, with the bundle/LOC cost of adopting
   each. Name problems this unit probably has that nobody has filed yet.

## Phase 1: Gather findings

### Inline mode

Read the full target yourself. Apply the full five-dimension rubric
to every file and module in scope. Produce `<target>/audit/AUDIT.md`
directly — skip per-unit files. You are both reviewer and synthesizer;
still follow the honest-severity, cite-`file:line`, what's-great
discipline. Use the same `AUDIT.md` structure described in Phase 2.
Then skip to Phase 3.

### Fan-out mode (small or full)

Spawn one agent per review unit, **in a single batched tool call**.
Each agent receives:

- Its unit path (absolute)
- The full rubric above, verbatim
- Required reading: root AGENTS.md / CLAUDE.md, goal statement, and
  the unit's own docs
- The calibration pointer ("grade systemic coherence against X")
- Output path: `<target>/audit/AUDIT-<unit>.md`
- The output template below

**Reviewers do not see each other's work.** No cross-agent messaging.
Blind fan-out is what makes cross-review corroboration signal.

For oversized units, tell the reviewer explicitly what to deep-review
vs. sample vs. skip, and have them report scope honestly. A truncated
review is worse than a scoped one.

### Output template (each reviewer uses this exactly)

```markdown
# Audit: <unit>

## Summary
2–4 sentences. Top 3 concerns. Honest headline grade.

## Scope
What was deeply reviewed, sampled, skipped. Why.

## Per-file findings
- [blocker|major|polish] <file:line> — <finding>

## Package-level findings
- ...

## Systemic concerns
| Concern | Seam used here | Enforced? | Divergence from calibration |
|---|---|---|---|

## Horizon opportunities
Paradigms that would obviate code here; problems not yet named.

## What's great
Positive patterns worth preserving. Required — not filler.
```

Reviewers cite `file:line` wherever possible. Severity is honest
(blocker / major / polish) — no inflation.

## Phase 2: Synthesize (fan-out only)

Inline mode already produced `AUDIT.md` in Phase 1 — skip to Phase 3.

Read every per-unit review yourself. **Do not delegate synthesis** —
ordering is judgment and belongs with the operator. Produce
`<target>/audit/AUDIT.md` with:

- **Verdict paragraph.** What a new engineer would actually say after a
  day in this code. Honest framing, not cheerleading.
- **Crown jewels.** Patterns independently praised by multiple
  reviewers. These calibrate future work.
- **Shipping-risk blockers.** User-visible bugs, false enforcement
  stories, credential exposure. Ordered by user impact, not reviewer.
- **Systemic coherence table.** One row per cross-cutting concern —
  seam used, enforced?, drift status. One-glance diagnostic.
- **Architectural horizon.** Rank-ordered paradigm shifts with bundle/
  LOC annotations. Label each: adopt / conditional / track / skip.
- **Problems not yet named.** Cross-review patterns nobody has filed.
- **Pre-rollout punch list.** Ordered by ROI. "If we only do 10 things,
  here they are."
- **Per-unit index.** One-line grade + headline + link per review.

## Phase 3: Propose a tiered work plan

Produce `<target>/audit/WORK-PLAN.md` — separate from the review so
execution doesn't inherit the review's authority.

Assign every item a stable ID: `T<tier>-<NN>` (e.g., `T0-01`,
`T1-03`). IDs are permanent once published — never renumber on
revision. They are the join key between the work plan and
`STATUS.md`.

Tiers:

- **T0 — ship-now:** bounded, <1 day each, fan-out-safe
- **T1 — systemic foundations:** enforcement, seams, missing capabilities
- **T2 — architectural / horizon:** bundle-annotated; requires user
  sign-off per item
- **T3 — per-unit polish:** bucketed by kind, not individually ordered

Per item: ID, scope, effort, dependencies, fan-out opportunity.

Then bootstrap `<target>/audit/STATUS.md` (see Phase 4) with every
work-plan item at status `open`.

Wait for the user to pick what to tackle. Do not execute from the
review or plan unilaterally.

## Phase 4: Track execution

`STATUS.md` is the only mutable artifact in `<target>/audit/`. The
review files (`AUDIT*.md`, `WORK-PLAN.md`) are immutable records of
what was found and planned — do not rewrite them as work progresses.
Update `STATUS.md` instead.

Format:

````markdown
# Audit status

Last updated: YYYY-MM-DD

| ID    | Status      | Note                          | Source              |
|-------|-------------|-------------------------------|---------------------|
| T0-01 | done        | fixed in abc1234              | WORK-PLAN.md#T0-01  |
| T0-02 | in-progress | branch: foo/bar               | WORK-PLAN.md#T0-02  |
| T1-03 | deferred    | waiting on upstream X; revisit after 2026-05 | WORK-PLAN.md#T1-03 |
| P-01  | rejected    | behavior is intentional       | AUDIT-foo.md:42     |
````

Status values:

- **open** — not started
- **in-progress** — actively being worked; note the branch or PR
- **done** — merged/shipped; link the commit or PR in the note
- **deferred** — punted with a reason (date, dependency, or the
  condition to revisit on)
- **rejected** — reviewed and declined; note why, so the decision
  doesn't get re-litigated

Default scope is work-plan items only. To track a per-unit finding
that didn't make the plan, promote it: assign a `P-<NN>` ID
(P for "promoted") and append a row whose `Source` points at the
original `AUDIT-<unit>.md:line`. Do not promote polish items in bulk
— promote only what you intend to act on.

On every update, bump "Last updated" and leave the rest of the row
history by simply editing status/note in place. Never change an
item's ID after it's published.

Concurrency: multiple agents may touch `STATUS.md`. Follow the
parallel-agent rules in the root guide — stage `STATUS.md` only,
commit under the commit lock.

## Rules (each earned through a prior failure)

- **Reviewers will be wrong about specifics.** Every audit produces
  some phantom findings (files that don't exist, "dropped" code that
  wasn't, etc.). Before acting on a concrete claim, verify it. Trust
  the shape of findings; verify the instance.
- **Corroboration across reviewers is strong signal.** When N reviewers
  flag the same concern, cite it structurally ("corroborated across N
  reviews"), not individually.
- **"What's great" is not filler.** Without it the synthesis reads as
  "this codebase is bad" instead of "this codebase has clear quality
  patterns plus debt." The second drives better decisions.
- **Missing goal / calibration is a blocker, not a workaround.** Don't
  proceed by guessing. Ask.
- **Cost discipline.** N reviewers × ~200 tool calls each adds up.
  Spawn once, in one batched call. Do not re-run reviewers for "better
  coverage" — pick up what they missed in the next pass.
- **Parallel-agent hygiene.** Each reviewer writes only to its own
  `AUDIT-<unit>.md`. No reviewer stages, commits, or stashes. All
  audit output is left unstaged — the user decides what's for the
  tree and what's scratch.

## Deliverables

By the end, on disk:

- [ ] `<target>/audit/AUDIT-<unit>.md` per unit (fan-out only)
- [ ] `<target>/audit/AUDIT.md` (synthesis, or inline review)
- [ ] `<target>/audit/WORK-PLAN.md` (tiered plan, with stable IDs)
- [ ] `<target>/audit/STATUS.md` (ledger, bootstrapped at `open`)

All unstaged. No commits from this skill. Later execution may commit
`STATUS.md` updates; the review and plan stay immutable.
