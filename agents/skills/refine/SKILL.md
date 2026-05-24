---
description: "Review code for complexity, simplification, and test gaps. Pass files, dirs, or concepts."
---

You are performing a critical review of code. Your goal is to find and
propose fixes for incidental complexity, simplification opportunities,
and test gaps. Be genuinely self-critical — challenge every abstraction,
every layer of indirection, every file that might not need to exist.

`/refine` operates per-file. For reviews that ask whether a set of areas
fit together as a system (seams, layering, missing shared primitives,
cross-area duplication), use `/seams` — run it first, since its
conclusions may relocate or delete files that would otherwise be refined
here.

## Determining which files to review

Interpret $ARGUMENTS to build a file list. Arguments fall into three
categories:

### 1. File paths (contain `/` and a file extension like `.ts`, `.tsx`)
Use them directly as the review file list.

### 2. Directories (contain `/` but no file extension, or end with `/`)
Find the source files in that directory. Exclude `node_modules`,
build artifacts, and generated files. Include source, test, and
config files that a human would review.

### 3. Concepts or area names (anything else — e.g. "quick send", "FX rate", "transfer card")
Search the codebase to find the files that implement that concept:
- Grep for the term in file names, component names, and exports
- Read AGENTS.md files and module indexes to understand where the
  concept lives
- Follow imports to find the full set of files involved

Present the resolved file list to the user before proceeding:
> **Resolved "[concept]" to these files:**
> - path/to/file1.tsx
> - path/to/file2.ts
> - ...
>
> Proceed with these, or adjust?

Wait for confirmation before continuing to Phase 1.

### No arguments provided
Look at your own conversation history to identify which files you
created or modified. Do NOT use git commands like `git diff` or
`git status` — multiple agents may be working in parallel and those
commands will include other agents' uncommitted work.

If you cannot determine files from context, ask the user:
> What should I refine? I can take file paths, a directory, or a
> concept name (e.g. "quick send", "transfer card").

Do not proceed until you have an explicit file list.

## Phase 1: Audit

Read every file in the list. For each file, also read its surrounding
context — imports it pulls in, modules that import it, and any existing
tests. Then evaluate through three lenses:

### Lens 1: Incidental complexity
- Abstractions that aren't pulling their weight
- Files, helpers, or utilities that could be inlined
- Unnecessary indirection or wrapper layers
- Over-engineered solutions to simple problems
- Dead code or unused exports
- Premature generalization — code shaped for hypothetical future needs

### Lens 2: Simplification
- Repeated patterns that should be collapsed
- Verbose implementations that have a simpler equivalent
- Conditions or branching that can be reduced
- Opportunities to use existing project utilities instead of hand-rolling
- Code that duplicates functionality already available in the codebase

### Lens 3: Test gaps
- Code paths that lack unit test coverage
- Edge cases that should be tested (null, empty, error states)
- Behavioral changes that aren't captured by any existing test
- Tests that test implementation details rather than behavior
- Missing regression tests for known bugs

## Phase 2: Present the plan

Output your findings as a structured proposal. Do NOT make any changes yet.

Format:

### Refinement proposal

**Files reviewed:** [list]

#### Incidental complexity
[For each finding:]
- **[file:line]** — [what's wrong and what you'd change]

#### Simplifications
[For each finding:]
- **[file:line]** — [what's verbose/duplicated and how you'd simplify]

#### Test gaps
[For each finding:]
- **[file/area]** — [what's untested and what test you'd add]

#### No changes needed
[If a lens has no findings, say so explicitly — don't skip it silently.
"No incidental complexity found" is a valid and useful signal.]

---

**Wait for the user to approve, adjust, or reject the proposal before
making any changes.** If the user approves (fully or partially), proceed
to Phase 3 for only the approved items.

## Phase 3: Execute approved changes

Make the approved changes. Keep edits scoped to the reviewed files plus
any new test files. Do not touch unrelated code.

After making changes, list what was modified so the user can run `/verify`
on the updated file set.
