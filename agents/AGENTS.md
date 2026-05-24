# Personal Agent Guide

## Non-Negotiable: Run What You Build

After every code change, you MUST compile/build AND run the actual
program to verify it works. This is not optional. Unit tests passing
is necessary but NOT sufficient.

What "run it" means:
- CLI tool → execute the command with real arguments
- Server → start it, hit the endpoint, check the response
- UI → load the page, interact with the feature
- Library → write and run a script that calls the new code path
- Config change → restart the affected tool and confirm behavior changed

Do not declare a task complete based only on test results. If you
cannot run the program (no runtime, no credentials, no device), say
so explicitly — do not silently skip this step.

## Non-Negotiable: Parallel Agents

Multiple agents always work in this tree in parallel. Cross-agent
interference causes lost work that is very hard to diagnose. These
rules are MUST-follow.

1. **Stage only your own files, by explicit pathspec.** Never
   `git add .`, `-A`, `-u`, or any variant that stages files you did
   not name.

2. **Commit only your own files, by explicit pathspec.** Use
   `git commit -o <pathspec> -m "..."` ("commit only these paths"), so
   any index state another agent prepared is ignored.

3. **If your changes interleave with another agent's in the same
   file, stage only your hunks.** Use `git add -p <path>` or
   `git apply --cached` on a filtered diff. Invariant: after staging,
   `git diff --cached <path>` shows only your changes.

4. **Stash only with a pathspec.** A bare `git stash` swallows other
   agents' uncommitted work. Required form:
   `git stash push -m "<agent-id>" -- <pathspec>`. Restore with
   `git stash apply` + explicit `git stash drop` — never `pop`
   (clobbers on conflict).

5. **Hold the commit lock across staging and committing.** Lock file:
   `<git-toplevel>/agent-commit-lock`. Use `flock(1)`:

   ```bash
   lock="$(git rev-parse --show-toplevel)/agent-commit-lock"
   flock -x -w 120 "$lock" -c '
     git add -- <your-paths> &&
     git commit -o <your-paths> -m "..."
   ' || { echo "timed out waiting for agent-commit-lock"; exit 1; }
   ```

   - `flock` is kernel-managed; the lock releases on process exit, so
     there is no stale-lock logic.
   - Do **not** unlink `agent-commit-lock` on success. Deleting it
     mid-use breaks the lock for waiters (new arrivals lock a
     different inode).
   - Do **not** commit `agent-commit-lock`.
   - To see the current holder:
     `lsof "$(git rev-parse --show-toplevel)/agent-commit-lock"`.

6. **If blocked, stop and ask.** Triggers:
   - `flock -w 120` times out.
   - The index contains staged changes you did not stage.
   - A merge conflict on files you did not touch.
   - `git stash push` or `apply` conflicts with another agent's work.

   Report the files, commands, and output. Do not `git reset`,
   `git checkout --`, bare `git stash`, or force-anything to escape.

## Ground Rules

These rules apply to every task in every project.

1. **Read before writing.** Read surrounding code and project guidance
   before modifying any file. Match existing patterns. Do not introduce
   a new pattern when an existing one covers the case.
2. **Verify before asserting.** If your claim depends on a file, API,
   or library feature existing — open it and check. Do not recall from
   training data. Differentiate confirmed facts from speculation. Cite
   facts in ways I can look up (file paths, line numbers, doc URLs,
   commit hashes).
3. **No stubs or placeholders.** Code that returns hardcoded data, TODO
   comments, or skipped side effects is not an implementation. Response
   data must come from the system, not from literals. A handler that
   skips the DB write or API call it's supposed to make is not done.
4. **Simplest feasible solution.** Do not gold-plate, over-abstract, or
   chase theoretical elegance. Ask clarifying questions when they'd
   meaningfully change the approach.
5. **Push back when warranted.** If you see a better approach with
   evidence, say so. Do not agree for the sake of agreement. Correct
   wrong assumptions early rather than building on a flawed premise.

## Execution Contract

Default behavior depends on the task type:

| Task type | Default behavior |
|-----------|-----------------|
| **Bug fix** | Reproduce or understand the failure → fix → add regression test. A fix without a test is incomplete. |
| **Feature** | Read surrounding code first → implement → test → run it for real → verify it works end-to-end. |
| **Review** | Inspect the diff, prioritize findings by risk. Do not patch code unless I ask. |
| **Refactor** | Preserve behavior. Tests must pass before and after. No feature changes smuggled in. |
| **Ambiguous** | Choose the smallest safe change that satisfies the request. Do not perform broad cleanup unless required. |
| **Doc-only** | Limit changes to docs unless the docs are wrong because the code is also wrong. |

## Verification Loop (mandatory, every change)

Run all five steps in order. Do not skip any step.

1. **Build** — run the project's build/compile command. Fix errors.
2. **Lint** — run the project's linter. Fix violations.
3. **Test** — run the test suite. Fix failures. Add tests for new behavior.
4. **Run it** — execute the actual program and verify the feature works
   from a user's perspective. This is the step agents skip. Do not skip
   it. See "Run What You Build" above for what this means per project type.
5. **Docs** — if behavior changed, update comments and docs to match.

Do not skip steps because "it's a small change." Small changes break
things too. If any step fails, fix the issue before moving on — don't
leave it for me to find.

If step 4 is impossible (no runtime, hardware dependency, etc.), state
why explicitly. "The tests pass" is not a substitute.

After all steps pass, check for leftover scaffolding, dead code, or
unnecessary abstractions introduced during implementation. Re-run
verification after any cleanup.

## Testing Stance

Every code change gets a test — bug fixes, features, refactors.

- **Bug fixes** need a regression test that would have caught the bug.
- **Tests verify behavior, not just status codes.** Assert on side
  effects, persisted data, rendered output — not just "it returned 200."
- **Integration tests verify round-trips.** Create → Read → assert data
  matches.
- **Don't mock what you can test directly.** Mock at system boundaries
  (external APIs, databases in unit tests), not internal interfaces.
- If the project has E2E tests, new user-visible features need E2E
  coverage — unit tests alone are insufficient.
- **Tests are not a substitute for running the real program.** Both are
  required. Tests catch regressions; running it proves the feature works.

**Avoid in tests:**
- Tests that only prove "it exists" when they could prove actual content
  or behavior
- Mocking internal modules or rendering primitives when the real thing
  works fine
- Skipping regression tests for bug fixes
- Asserting on serialized render trees or snapshots as proof of behavior
- Real timer waits when fake timers would eliminate wall-clock cost

## Stop / Ask Boundaries

Stop and ask before proceeding if:

- A required tool, dependency, or credential is missing or inaccessible.
- Uncommitted changes in the files you need to touch appear to conflict
  with the task.
- The task requires changes across boundaries you weren't asked to cross
  (other packages, services, repos).
- Tests or lint fail for reasons you cannot confidently attribute to
  your change.
- You're about to make a judgment call that significantly affects scope,
  architecture, or public API surface.

If none of these apply, continue without asking.

## Common Mistakes

These apply across projects. Per-project CLAUDE.md files should add
their own earned-through-failure lists.

- Running the test suite and declaring done without compiling or running
  the actual program
- Treating "tests pass" as proof the feature works
- Declaring a task done without running the verification loop
- Writing tests that assert on implementation details instead of behavior
- Adding abstractions, helpers, or utility files for one-time operations
- Guessing at library APIs from training data instead of reading the
  actual source or docs
- Over-scoping: fixing adjacent code, adding error handling for
  impossible cases, or refactoring code you weren't asked to touch
- Returning fabricated data (empty arrays, placeholder strings) as if
  it were a real implementation
- Introducing a new pattern when an existing one in the codebase covers
  the case
- Skipping the verification step because "the logic is straightforward"
