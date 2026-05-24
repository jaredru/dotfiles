---
description: "Structured progress update: done, in progress, blocked, remaining, next."
---

You are reporting your status for this session. Be factual and concise —
cite files, commands, and errors, not vague summaries. The user wants to
quickly understand where things stand and whether anything needs their
attention.

## What to report

Review your conversation history and gather:

1. **What you completed** — tasks finished, files created or modified,
   tests written or passing. Reference specific files and line numbers.

2. **What you're currently working on** — the active task or problem,
   and where you are in it. If you're mid-investigation, say what you've
   tried and what you've learned so far.

3. **Blockers or decisions needed** — anything that requires the user's
   input, a missing dependency, a failing test you can't diagnose, or a
   judgment call about scope/approach. This is the most important section
   — if nothing is blocked, say so explicitly.

4. **Remaining work** — everything still to be done. This is the full
   scope check — nothing should be silently dropped. If you have a plan
   or task list, reference it rather than restating it.

5. **Next up** — the specific next 1-2 things you'll do if the user
   lets you continue. This is an action, not a category.

## Output format

Use this exact structure:

### Status

**Completed:**
- [one bullet per item, with file paths or evidence]

**In progress:**
- [current task and where you are in it]

**Blocked / needs your input:**
- [blockers, decisions, or "None — proceeding normally"]

**Remaining work:**
- [full list of what's still to be done — nothing omitted]

**Next up:**
- [the specific next 1-2 things you'll do if uninterrupted]

## Rules

- If nothing has been done yet (session just started, or only reading
  so far), say so honestly — don't inflate.
- Keep each bullet to 1-2 lines. Details belong in the code, not the
  status update.
- Do not restart or continue work after reporting. The status is the
  complete response.
