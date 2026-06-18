---
name: user-rule-review-sql
description: >-
  Reviews SQL for SELECT * misuse in production paths and redundant overlapping
  indexes. Use when editing queries, migrations, ORM raw SQL, or index DDL.
---

# SQL review

## Avoid SELECT * in production

**TL;DR:** `SELECT *` hides column dependencies and can leak or break on schema change.

**Fix:** List columns in production; reserve `SELECT *` for ad-hoc debugging or trivial literals.

```sql
SELECT id, name, email FROM users WHERE active = 1;
```

```javascript
// Non-compliant in production APIs
const users = await db.query("SELECT * FROM users");
```

## Avoid redundant indexes

**TL;DR:** An index whose leading columns are a **prefix** of another composite index on the same table adds write cost with little benefit.

**Fix:** Drop the narrower index when the composite already serves those lookups (verify query plans first).

```sql
-- Non-compliant: user_id alone is prefix of composite
CREATE INDEX idx_user_id ON users (user_id);
CREATE INDEX idx_user_created_status ON users (user_id, created_at, status);

-- Compliant: keep composite only when it covers the need
CREATE INDEX idx_user_created_status ON users (user_id, created_at, status);
```
