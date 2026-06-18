---
name: user-rule-review-structure-api
description: >-
  Reviews duplication, file/class naming alignment, oversized multi-purpose
  files, public API compatibility, and composition plus dependency injection
  versus deep inheritance. Use during refactors, new modules, or API versioning
  work.
---

# Structure and API review

## Remove obvious within-file duplication

**TL;DR:** Copy-paste diverges under maintenance.

**Fix:** Helpers, loops, or table-driven dispatch; delete redundant branches.

```javascript
function validateField(value, fieldName) {
  if (!value) throw new Error(`${fieldName} is required`);
}
validateField(name, "Name");
validateField(email, "Email");
```

## Class or module name matches filename

**TL;DR:** Case or basename mismatches break imports on **case-sensitive** disks (e.g. Linux).

**Fix:** Match primary type and filename exactly; follow PSR-4, Java packages, Python module norms.

## Avoid overly large files

**TL;DR:** Files with many unrelated responsibilities are hard to navigate and merge.

**Fix:** Split into focused modules; one clear responsibility per file when practical.

## Preserve public API contracts

**TL;DR:** Renaming params, removing JSON fields, or tightening types breaks clients.

**Fix:** Support old and new names during migration; optional new fields with defaults; additive responses first.

```php
$userId = $request->getQueryParams()['userId']
    ?? $request->getQueryParams()['user_id']
    ?? null;
```

## Favor composition over inheritance

**TL;DR:** Deep inheritance couples subclasses to parent internals and state you may not need.

**Fix:** Prefer **composition** and **dependency injection**; inherit only from framework bases or for pure behavior extensions **without** new state.

```javascript
// Non-compliant: inherits Logger, hard-wires Validator
class FileProcessor extends Logger {
  constructor() {
    super();
    this.validator = new Validator();
  }
}

// Compliant: collaborators injected
class FileProcessor {
  constructor(logger, validator) {
    this.logger = logger;
    this.validator = validator;
  }
}
```
