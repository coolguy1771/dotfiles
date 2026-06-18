---
name: user-rule-review-security
description: >-
  Reviews code for injection, weak password hashing, IDOR / cross-tenant access,
  and unsafe SKILL.md patterns. Use during security review, API handler
  changes, authz checks, subprocess or SQL construction, or credential handling.
---

# Security review

## Injection (queries, commands, dynamic code)

**TL;DR:** Never build queries, OS commands, or executable code by concatenating or interpolating **untrusted** input.

**Fix:** Parameterized queries or bind APIs; subprocess **argument arrays** (no shell); vetted escaping only when parameterization is impossible.

```javascript
// Non-compliant: command injection
exec("rm -rf /tmp/" + userDir);

// Compliant: no shell interpretation of user data
execFile("rm", ["-rf", `/tmp/${userDir}`]);
```

## No weak hashes for security-sensitive data

**TL;DR:** **MD5** and **SHA-1** are unsuitable for passwords or integrity under attack.

**Fix:** **Argon2**, **scrypt**, or **bcrypt** for passwords (salt + work factor). **SHA-256** / **SHA-3** for general cryptographic hashing when not password storage.

```javascript
// Non-compliant
const hash = crypto.createHash("md5").update(password).digest("hex");

// Compliant (pattern)
const hash = bcrypt.hashSync(password, 12);
```

## Authorization (IDOR / cross-tenant)

**TL;DR:** Fetching by ID from the request without proving the caller may access that row leaks or cross-writes data.

**Fix:** After load, compare ownership / tenant to authenticated principal; return **403** (or 404) when mismatch.

```javascript
// Non-compliant
app.get("/orders/:id", (req, res) => {
  const order = db.getOrder(req.params.id);
  res.json(order);
});

// Compliant
app.get("/orders/:id", (req, res) => {
  const order = db.getOrder(req.params.id);
  if (order.ownerId !== req.user.id) return res.status(403).send();
  res.json(order);
});
```

## SKILL and agent instruction safety (meta)

**TL;DR:** `SKILL.md` that exfiltrates secrets, targets production destructively, or mislabels dangerous steps is unsafe.

**Fix:** Accurate descriptions; scope commands to **local** / **staging**; never instruct uploading credentials or running opaque encoded payloads.
