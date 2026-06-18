---
name: user-rule-review-control-flow
description: >-
  Reviews unreachable and dead branches, goto-style control flow,
  assignment-in-condition, empty catches, dangerous regex, nesting depth,
  guard clauses, preconditions, debug residue, and break in nested loops. Use
  when refactoring conditionals, error handling, loops, or C-style jumps.
---

# Control flow review

## Unreachable and dead control flow

**TL;DR:** Code after `return` / `throw` / `break`, or inside branches that can never run, is untestable noise.

**Fix:** Delete dead code or restructure control flow so every statement is reachable on some valid path.

```javascript
// Non-compliant: lines after return never run
function process(data) {
  return data.map(transform);
  console.log("Processing complete");
  cleanup();
}

// Compliant
function process(data) {
  const result = data.map(transform);
  console.log("Processing complete");
  cleanup();
  return result;
}
```

```javascript
// Non-compliant: else branch impossible if condition is always true
if (true) {
  return result;
} else {
  doSomething();
}
```

## Avoid `goto` (and goto-shaped control flow)

**TL;DR:** `goto` and label soup obscure structure and make invariants hard to reason about.

**Fix:** Use **loops**, **conditionals**, and **functions** instead of jumping between labels.

```cpp
// Non-compliant
int i = 0;
loop:
  if (condition) goto end;
  processItem(i);
  i++;
  if (i < 10) goto loop;
end:

// Compliant
for (int i = 0; i < 10; i++) {
  if (condition) break;
  processItem(i);
}
```

## No assignment inside conditionals

**TL;DR:** `=` inside `if` / `while` is easy to misread and often masks `==` typos.

**Fix:** Assign on its own line, then test.

```javascript
// Non-compliant
let input = "";
if ((input = userInput("x")) !== "") handleInput(input);

// Compliant
const input = userInput("x");
if (input !== "") handleInput(input);
```

## Handle errors in catch blocks

**TL;DR:** Empty catches hide failures.

**Fix:** Log, user-safe feedback, or rethrow; swallow only with narrow types and documented rationale.

## Safe regular expressions

**TL;DR:** Nested quantifiers and greedy stacks risk **catastrophic backtracking**.

**Fix:** Bounded classes, atomic/possessive groups where supported, or a parser.

```javascript
const bad = /(.*@.*)+/;
const better = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
```

## Limit nesting; use early returns and guards

**TL;DR:** Deep nesting and late validation are hard to follow.

**Fix:** Validate at the start; use **early returns**; keep depth around **four** levels or fewer; extract helpers.

```javascript
// Non-compliant
function processUser(user) {
  if (user) {
    if (user.isActive) {
      return performProcessing(user);
    }
  }
  return null;
}

// Compliant
function processUser(user) {
  if (!user) return null;
  if (!user.isActive) return null;
  return performProcessing(user);
}
```

## Break in inner loops

**TL;DR:** `break` / `continue` in nested loops is easy to misread.

**Fix:** Add a short comment naming what you exit, or extract search into a helper that **returns** when found.

```javascript
for (let i = 0; i < items.length; i++) {
  for (let j = 0; j < items[i].length; j++) {
    // Exit inner loop when target found
    if (items[i][j] === target) break;
  }
}
```

## Preconditions and impossible branches

**TL;DR:** Do not assert states the control flow has already ruled out.

**Fix:** Reorder guards; delete redundant checks.

## Debug residue and transparency

**TL;DR:** Debug bypasses (`|| true`), noisy logs, and obfuscated flow should not ship.

**Fix:** Remove temporary bypasses; keep production logs structured and intentional.
