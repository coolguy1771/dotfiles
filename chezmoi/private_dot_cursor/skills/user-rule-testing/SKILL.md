---
name: user-rule-testing
description: >-
  Specifies independent, fast, descriptively named tests and when to run
  subsets versus full suites. Use when writing tests, debugging with tests, or
  discussing test strategy, fixtures, or suite layout.
---

# Testing practices

- Each test targets **one small behavior** and proves it correct.
- Tests must be **fully independent** and safe in **any order**; use fresh data, fixtures, or setup per test and clean up when needed.
- Prefer **fast** tests for inner loops; isolate **slow or heavy** suites if they cannot be made fast.
- Know how to run a **single test or case** and use that loop while developing.
- Run the **full suite** before and after substantive sessions when practical; consider a **pre-push** hook for the project.
- When debugging, add a **failing test first** when feasible to pin the bug.
- Use **long, descriptive test names** so failures read like specifications.
- Treat tests as **onboarding documentation**; keep structure and names readable for newcomers.
