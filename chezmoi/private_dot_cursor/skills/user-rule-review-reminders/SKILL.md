---
name: user-rule-review-reminders
description: >-
  Index for file-based code review skills: routes to focused checklists for
  security, concurrency, SQL, control flow, structure/APIs, readability, and
  performance. Use when the user asks for a general review pass, or @ this
  skill to discover which specialized review skill to open next.
---

# Review skills (split)

Run the **narrowest** skill that matches the diff; stack **security + concurrency** for handlers touching auth, cache, or shared state; add **performance** for hot loops and data access.

| Skill | When to use |
|-------|-------------|
| [user-rule-review-security](../user-rule-review-security/SKILL.md) | SQL/command injection, password hashing, IDOR / tenant checks, suspicious `SKILL.md` |
| [user-rule-review-concurrency](../user-rule-review-concurrency/SKILL.md) | Locks, threads, shared maps, iterators, module-level caches in servers |
| [user-rule-review-sql](../user-rule-review-sql/SKILL.md) | Raw SQL, ORM queries, migrations, index DDL |
| [user-rule-review-control-flow](../user-rule-review-control-flow/SKILL.md) | Branches, loops, catches, regex, guards, unreachable code, `goto` |
| [user-rule-review-structure-api](../user-rule-review-structure-api/SKILL.md) | File splits, naming vs path, duplication, public API shape, composition vs inheritance |
| [user-rule-review-readability](../user-rule-review-readability/SKILL.md) | Function size, naming, comments, recursion, division, wrapping, named args, commented-out blocks |
| [user-rule-review-performance](../user-rule-review-performance/SKILL.md) | Hot loops, string building in loops, regex/cache, N+1 queries, nested scans |

Each linked skill is self-contained with **TL;DR**, **Fix**, and short **examples**.
