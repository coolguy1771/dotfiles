---
name: user-rule-review-performance
description: >-
  Flags obvious scalability issues: nested loops, repeated work in hot loops,
  string concatenation in loops, uncached heavy regex, accidental N+1 queries,
  and missing hash-based lookups. Use when reviewing hot paths, batch jobs,
  list processing, or database access patterns.
---

# Performance review (obvious drains)

**TL;DR:** Cost should not grow unnecessarily with input size (hidden **O(n²)** work, repeated allocations, N+1 I/O).

**Fix:**

- Hoist **invariant** work **outside** loops.
- Prefer **builders** or join APIs over **`+=` strings** in tight loops (per language: `StringBuilder`, `''.join`, etc.).
- **Compile or cache** regex patterns used repeatedly; avoid rebuilding the same `RegExp` inside a loop body.
- Prefer **hash maps / sets** over **nested scans** when you need repeated membership or lookup by key.
- **Batch** database reads/writes instead of **N+1** round-trips per row.

```java
// Non-compliant: new String each iteration
String result = "";
for (String item : largeList) {
    result += item + ",";
}

// Compliant
StringBuilder result = new StringBuilder();
for (String item : largeList) {
    result.append(item).append(",");
}
```

```javascript
// Pattern: build a Map once, O(1) lookups inside loop
const byId = new Map(users.map((u) => [u.id, u]));
for (const order of orders) {
  const user = byId.get(order.userId);
}
```
