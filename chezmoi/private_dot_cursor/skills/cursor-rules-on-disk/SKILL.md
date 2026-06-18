---
name: cursor-rules-on-disk
description: >-
  Explains where Cursor loads rules from (global and project .mdc, Settings
  user rules, plugins, legacy .cursorrules), when to use file-based rules, and
  how to migrate or dedupe so the agent is not instructed twice. Use when the
  user asks where rules live on disk, how to version rules in git, export
  Settings rules to files, or fix duplicated or conflicting rule sources.
---

# Cursor rules on disk

## Sources (what the agent actually sees)

Rules and similar instructions can come from **several places at once**:

| Source | Typical path / location | Format |
|--------|-------------------------|--------|
| Global file rules | `~/.cursor/rules/*.mdc` | Markdown + YAML frontmatter |
| Project file rules | `<repo>/.cursor/rules/*.mdc` | Same |
| **User rules** (Settings) | Not separate text files; persisted in app state (e.g. macOS `~/Library/Application Support/Cursor/User/globalStorage/state.vscdb` and related WAL/backup) | Plain text in UI |
| Plugin rules | `~/.cursor/plugins/cache/.../rules/*.mdc` (paths vary by plugin) | `.mdc` |
| Legacy | `<repo>/.cursorrules` | Plain text |
| Team / org | Often remote / policy | Varies |

**Skills** (`~/.cursor/skills/`, `.cursor/skills/`) and **AGENTS.md / CLAUDE.md** are separate mechanisms; they are not `.cursor/rules` files but still steer the agent.

## `.mdc` frontmatter (file-based rules)

```yaml
---
description: Short summary; used for discovery in the rule picker
globs: "**/*.py"        # optional; omit or set alwaysApply for global behavior
alwaysApply: true       # optional; if true, applies without glob match
---
```

Use `alwaysApply: true` for user-wide preferences that should attach to every chat. Use `globs` when the rule should apply only when matching files matter.

## When to prefer file-based rules

- **Version control**: put project rules under `<repo>/.cursor/rules/` and commit them.
- **Transparency**: diffable, reviewable, shareable with the team.
- **Backup**: easier than scraping SQLite for Settings text.

Keep **global** personal defaults in `~/.cursor/rules/`; keep **repo-specific** contracts in the repo.

## Migration from Settings “User rules”

1. Create one or more `.mdc` files under `~/.cursor/rules/` (or `.cursor/rules/` for project-only).
2. Paste or rewrite the Settings text into the markdown body; set `alwaysApply: true` if it replaced global user rules.
3. **Remove or shorten the same text in Cursor Settings → Rules** so instructions are not applied twice (token cost and contradictions).

Do **not** put new personal skills in `~/.cursor/skills-cursor/`; that tree is for Cursor-built skills.

## Verification

After migration, confirm:

- [ ] No duplicate paragraphs in Settings and `.mdc` for the same policy.
- [ ] `description` in each `.mdc` is accurate (shown in rule UI).
- [ ] `globs` vs `alwaysApply` matches intent (narrow vs always-on).
