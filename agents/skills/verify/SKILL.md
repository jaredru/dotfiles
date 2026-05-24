---
description: "Pre-commit verification gate. Pass files as arguments (required)."
---

You are running the pre-commit verification gate. Your job is to determine
which checks the project requires, run them against the specified files,
fix what you can automatically, and produce a verification summary table.

## CRITICAL: File arguments are required

$ARGUMENTS must contain a space-separated list of files to verify. These
are the files YOU changed — not all files that differ in the working tree.

If $ARGUMENTS is empty or missing, DO NOT attempt to detect files
automatically. Multiple agents work in parallel, so `git diff`,
`git status`, or `git ls-files` will include other agents' uncommitted
work. Instead, stop immediately and respond:

> **Error:** `/verify` requires explicit file arguments.
> Usage: `/verify path/to/file1.tsx path/to/file2.ts`

## Step 1: Read the project's verification requirements

Read the project's AGENTS.md, CLAUDE.md, and any area-specific AGENTS.md
files relevant to the files in $ARGUMENTS. Look for:
- Pre-commit gates or checklists
- Required lint, format, test, and typecheck commands
- Visual validation or headless browser requirements
- Any other checks the project mandates before committing

These documents define what to run. This skill defines the workflow.

## Step 2: Lint and format

Run the project's lint and format checks against the files in $ARGUMENTS,
using the commands specified in the project documentation.

If format check fails, attempt auto-fix using the project's format-write
command, then re-check.

If lint fails, read the errors carefully. If they are auto-fixable, note
what was fixed. If not, report them as blocking.

## Step 3: Tests

Run the project's test command scoped to the files in $ARGUMENTS, using
whatever test runner and flags the project specifies.

Record pass/fail counts.

## Step 4: Typecheck

Run the project's typecheck command. Only NEW typecheck errors in the
files from $ARGUMENTS are blocking — pre-existing errors from other
files do not block your commit.

## Step 5: Visual validation

If the project documentation specifies visual validation requirements
(headless browser, storybook, screenshot comparison, etc.), determine
whether they apply to the files in $ARGUMENTS.

- If required, run the validation as documented.
- If exempt, state the exemption reason explicitly using the project's
  criteria for exemption.
- If the project has no visual validation requirements, omit this check
  from the summary.

## Step 6: Output the verification summary

Output a table covering every check the project requires:

| Check | Result |
|-------|--------|
| Lint | {0 errors / N errors (blocking)} |
| Format | {All files correct / Fixed N files / N files still failing} |
| Tests | {N passed, 0 failed / N passed, M failed (blocking)} |
| Typecheck | {No new errors / N new errors (blocking)} |
| [Any other project-required check] | {result} |

If any check is **blocking**, add a section below the table:

### Blocking issues
- **{Check}**: {description of what failed and what to fix}

If all checks pass, state: **All checks passed. Ready to commit.**
