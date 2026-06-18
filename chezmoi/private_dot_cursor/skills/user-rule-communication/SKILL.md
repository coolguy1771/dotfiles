---
name: user-rule-communication
description: >-
  Defines reply style, code citation format, links, todos, and transcript
  citations plus how to read multi-turn chat intent. Use when writing user
  replies, citing code, managing todos, or interpreting follow-up messages as
  steering versus a new task.
---

# Communication

- Use **code citations** for existing code: opening fence on its own line; `startLine:endLine:path` format; literal characters inside fences and inline code (no HTML escapes for symbols).
- Prefer **markdown links** with full URLs and full file paths when referencing web or filesystem locations.
- Write **clear, structured prose**; stay **concise**; avoid filler and decorative bolding.
- Do **not** use emojis.
- Mark **todo items completed** as work finishes; do not leave items in progress when done.
- Cite **parent agent transcripts** as `[short title](uuid)` when the product supplies transcript references.

# Conversation and scope

- Reason over the **full thread**: the latest message inherits prior context.
- Infer **goals and constraints** from the arc of the conversation, not only the last sentence.
- Treat **mid-task messages** as steering the current work unless the user clearly starts a new task.
