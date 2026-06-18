---
name: user-rule-review-concurrency
description: >-
  Reviews locking, thread-safe shared state, safe collection removal, and
  request-scoped vs module-global mutable caches in servers. Use when touching
  locks, caches, shared maps, iterators, or Node/Python request handlers.
---

# Concurrency and shared state

## Release locks on every path

**TL;DR:** Every lock acquisition needs a guaranteed release on exception or early return.

**Fix:** `finally`, `try-with-resources`, `with` (Python), or RAII.

```java
// Non-compliant
rwLock.acquireWriteLock(2000);
doSomethingRisky();
rwLock.releaseWriteLock();

// Compliant
rwLock.acquireWriteLock(2000);
try {
    doSomethingRisky();
} finally {
    rwLock.releaseWriteLock();
}
```

## Thread-safe shared mutable state

**TL;DR:** Unsynchronized shared maps and check-then-act patterns race.

**Fix:** Concurrent collections, locks, or atomics; validate cross-thread invariants.

```csharp
private static readonly ConcurrentDictionary<string, int> cache = new();
```

## Safe removal while iterating

**TL;DR:** Mutating a collection during `for-each` / direct iteration throws or skips elements.

**Fix:** `iterator.remove()`, `removeIf`, collect keys then `removeAll`, or iterate a **copy**.

```java
// Compliant: iterator.remove()
Iterator<String> it = list.iterator();
while (it.hasNext()) {
    if (it.next().startsWith("remove")) it.remove();
}

// Compliant: removeIf
list.removeIf(item -> item.startsWith("remove"));

// Non-compliant: ConcurrentModificationException risk
for (String item : list) {
    if (item.startsWith("remove")) list.remove(item);
}
```

```python
# Safer: snapshot keys or use comprehension + assign
for key in list(routes.keys()):
    if routes[key]["hits"] == 0:
        del routes[key]
```

## Avoid unintended module-global request data

**TL;DR:** In long-lived servers, **module-level** mutable structures persist across requests and can leak or race.

**Fix:** Keep per-request data on `req` / context / locals; if a module-level cache is intentional, name and document it (e.g. `SHARED_CONFIG_CACHE`).

```javascript
// Non-compliant: leaks across users
let userCache = {};
app.get("/user/:id", (req, res) => {
  userCache[req.params.id] = getUserData(req.params.id);
  res.json(userCache);
});

// Compliant: request-scoped
app.get("/user/:id", (req, res) => {
  const userData = getUserData(req.params.id);
  res.json(userData);
});
```
