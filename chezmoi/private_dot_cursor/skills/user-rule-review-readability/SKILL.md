---
name: user-rule-review-readability
description: >-
  Reviews function size, parameters, division safety, naming, lambdas,
  docstrings, comments (why vs what), TODOs, line wrapping (80–120 columns),
  named arguments (3+ arity), PHP variable-variables, removal of commented-out
  blocks, and bounded recursion. Use when polishing implementation quality and
  PR clarity.
---

# Readability and function quality

## Keep functions small

**TL;DR:** Long functions are hard to test and reason about.

**Fix:** Aim under **~60 lines** and **fewer than ~10** locals; extract helpers.

```javascript
function processOrder(order) {
  return saveOrder(calculateTotals(validateOrder(order)));
}
```

## Do not reassign parameters

**TL;DR:** Mutating parameters obscures inputs.

**Fix:** New `const` locals per step.

```javascript
function processName(name) {
  const trimmed = name.trim();
  return trimmed.toUpperCase();
}
```

## Check divisor before division

**TL;DR:** Division by zero crashes or propagates `Inf`/`NaN`.

**Fix:** Guard computed denominators; explicit branches or safe defaults.

```python
average = total / count if count != 0 else 0
if max != min:
    ratio = value / (max - min)
else:
    ratio = 0
```

## Use descriptive variable names

**TL;DR:** Very short or cryptic names hide intent.

**Fix:** Prefer full words; keep **`i`/`j`/`k`** for loops and **`x`/`y`** for math when conventional.

```javascript
const userCount = users.length;
const isEmailValid = validateEmail(email);
```

## Self-evident function names and docs

**TL;DR:** `calc(p, t)` forces readers to decode semantics.

**Fix:** Verb-noun names, meaningful parameters, JSDoc / docstrings for non-obvious contracts.

```javascript
/**
 * Calculates total including tax.
 */
function calculateTotalPrice(price, taxRate) {
  return price * (1 + taxRate);
}
```

## Do not overuse large anonymous functions

**TL;DR:** Big inline callbacks are hard to scan and reuse.

**Fix:** Extract a **named** predicate or helper; or add a one-line comment stating the filter rule.

```javascript
const validateUser = (user) =>
  Boolean(user.email && user.name && user.age > 0);
users.filter(validateUser);
```

## Bound recursion

**TL;DR:** Unbounded recursion risks stack overflow and DoS on hostile depth.

**Fix:** Depth counters, max depth checks, iterative algorithms, visited sets on graphs.

```javascript
function searchTree(node, target, maxDepth = 10, depth = 0) {
  if (!node || depth >= maxDepth) return null;
  if (node.value === target) return node;
  return searchTree(node.left, target, maxDepth, depth + 1);
}
```

## Comments: why, not mechanics

**TL;DR:** Comments that restate the next line go stale and add noise.

**Fix:** Explain purpose with **because / so that / in order to**; document invariants and external contracts.

```javascript
// Cache result because API calls are expensive
const result = cache.get(key) || await fetchFromAPI();
```

## TODO, FIXME, and remove commented-out code blocks

**TL;DR:** Stale markers and **disabled implementations** left in comments create noise and drift from reality.

**Fix:** Ticket or resolve TODOs; **delete** large commented-out blocks; keep short comments that document **intent**, not old code. Use git history for reference.

```javascript
// Compliant: comments explain behavior, not dead code
// Validates token then permissions
function authenticate(token) {
  return verifyToken(token);
}
```

```javascript
// Non-compliant: blocks of old logic in comments
// function oldImplementation() {
//   return processLegacy(data);
// }
/* if (useOldLogic) { return oldMethod(); } */
```

## Line length and formatting

**TL;DR:** Very long lines are hard to read and review (especially on small screens).

**Fix:** Aim roughly **80–120** characters per line per project standard; break chains, object literals, and argument lists across lines.

```javascript
// Compliant: wrapped chain / object literal
const activeItems = allRawItems
  .filter((rawItem) => rawItem.active)
  .map((rawItem) => ({
    id: rawItem.id,
    title: rawItem.title,
    description: rawItem.description,
    metadata: {
      relatedType: rawItem.type,
      parentId: rawItem.parent.id,
    },
  }));

// Non-compliant: one enormous expression on a single line
// const activeItems = allRawItems.filter(...).map(rawItem => ({ id, title, ... }));
```

## Named arguments at call sites

**TL;DR:** Positional calls with many parameters are easy to transpose and hard to read at review time.

**Fix:** For **three or more** meaningful arguments, prefer **keyword** / **named** arguments (Python, PHP 8+), or an options object in JavaScript.

```python
# Compliant
create_user(
    first_name="John",
    last_name="Doe",
    is_active=True,
    is_verified=False,
    avatar=None,
    age=30,
    role="admin",
)

# Non-compliant
create_user("John", "Doe", True, False, None, 30, "admin")
```

## PHP: avoid accidental dynamic variable names (`$$`)

**TL;DR:** `$$var` is a **variable variable**; an extra `$` is often a typo and yields surprising behavior.

**Fix:** Use a single `$` and normal arrays or maps when you need indirection.

```php
// Compliant
foreach ($issue_types as $issue_type) {
    // ...
}

// Non-compliant: dynamic variable
foreach ($$issue_types as $issue_type) {
    // ...
}
```
