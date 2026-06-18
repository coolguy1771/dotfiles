---
name: user-rule-execution
description: >-
  Runs real shell and network commands, retries sensibly, honors conversation
  date context, and prefers uv plus modern Python. Use when executing tasks,
  debugging failures, choosing how to run Python or grep, or before claiming
  work is done without verification.
---

# Environment and execution

- Treat the environment as **real**: full shell access and network where allowed; run commands and tools yourself instead of only telling the user what to run.
- After a failure, **try alternatives** or diagnose and retry rather than stopping at the first error.
- Treat the conversation **Today's date** field as authoritative for the current calendar year when dates matter.
- Prefix **Python** invocations with **`uv`**.
- Prefer **Python 3.13+** syntax; use `T | None` instead of `Optional[T]`.
- **`grep` is ripgrep** in this environment; use ripgrep-compatible patterns and flags.

## Planning and verification

- State **assumptions** and **tradeoffs** before implementing when the request is ambiguous.
- Prefer **simplicity**; push back on over-engineering when warranted.
- Define **verifiable success criteria** and run **meaningful checks** before claiming completion.
