---
name: user-rule-coding-discipline
description: >-
  Constrains scope, style, and change hygiene for implementation work
  including function size and simplicity. Use when editing code, reviewing
  diffs, planning refactors, or deciding what belongs in a change.
---

# Coding discipline

- Touch **only what the task requires**; avoid drive-by refactors and unrelated files.
- **Read surrounding code** before writing; match naming, types, imports, and documentation level; reuse existing helpers instead of duplicating patterns.
- Ensure **every changed line** traces directly to the request.
- Remove **only** imports, variables, or helpers that **your** changes made unused; do not delete unrelated pre-existing dead code unless asked.
- Prefer **simple, unified code paths** over elaborate special cases.
- Avoid **speculative** features, abstractions, and defensive layers for scenarios that are not required.
- Keep **functions** to about **60 lines or fewer**; extract when they grow past that.
- Write the **simplest code** that solves the problem.
- Do **not** create summary or documentation files unless the user explicitly asks.
