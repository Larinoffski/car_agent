#!/usr/bin/env bash
# PostToolUse formatter for Edit and Write: runs `make fmt FILES=<file>` on the edited file.
# Not wired yet: enable in .claude/settings.json once `make fmt` is configured for the stack.
# Exit 2 in PostToolUse does not block; stderr goes back to the agent as feedback.
set -euo pipefail

file=$(jq -r '.tool_input.file_path // ""')
[[ -n "$file" && -f "$file" ]] || exit 0

cd "${CLAUDE_PROJECT_DIR:-.}"
if ! output=$(make --no-print-directory fmt FILES="$file" 2>&1); then
  echo "make fmt failed for $file:" >&2
  echo "$output" >&2
  exit 2
fi
exit 0
