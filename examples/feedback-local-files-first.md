---
name: local-files-first
description: Prefer local filesystem discovery before expensive API traversal when both are available
type: feedback
---

Use local files for discovery before making expensive API calls when the same answer can be derived from the filesystem.

**Why:** Local files are immediate, inspectable, and less failure-prone. Remote traversal adds latency, rate-limit risk, and extra moving parts.

**How to apply:** When the task is search, scan, inventory, or structure discovery, check whether the necessary information already exists in local files before using an API. Use the API only for the targeted mutation or retrieval the filesystem cannot provide.
