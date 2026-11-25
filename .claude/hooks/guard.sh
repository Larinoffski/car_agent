#!/usr/bin/env bash
# PreToolUse guard for Bash, Read, Grep and Glob: blocks reading secrets and destructive commands.
# Pattern-based defense in depth, not a hard boundary. Exit 2 blocks the call; stderr goes to the agent.
set -euo pipefail

input=$(cat)
tool=$(jq -r '.tool_name // ""' <<<"$input")

block() {
  echo "Blocked by .claude/hooks/guard.sh: $1" >&2
  exit 2
}

case "$tool" in
  Bash) target=$(jq -r '.tool_input.command // ""' <<<"$input") ;;
  Read) target=$(jq -r '.tool_input.file_path // ""' <<<"$input") ;;
  Grep) target=$(jq -r '[.tool_input.path, .tool_input.glob] | map(select(. != null)) | join(" ")' <<<"$input") ;;
  Glob) target=$(jq -r '[.tool_input.path, .tool_input.pattern] | map(select(. != null)) | join(" ")' <<<"$input") ;;
  *) exit 0 ;;
esac

# Secrets: envs/secrets/ dir, .env files and envs/*.env (except *.env.example), private keys.
# A boundary is any character that cannot be part of a file name.
b='[^A-Za-z0-9_.-]'
secrets="(envs/secrets/|(^|$b)\.env(\.[A-Za-z0-9_-]+)?(\$|$b)|envs/[A-Za-z0-9_.*-]*\.env(\$|$b)|\.(pem|key)(\$|$b))"

if [[ "${target//.env.example/}" =~ $secrets ]]; then
  block "access to secrets is not allowed"
fi

[[ "$tool" == "Bash" ]] || exit 0

destructive=(
  'rm[[:space:]]+-[^[:space:]]*[rR][^[:space:]]*[[:space:]]+(/|~|\$HOME)/?\*?([[:space:]]|$)'
  'git[[:space:]]+push.*[[:space:]](--force|-f)([[:space:]]|$)'
  'git[[:space:]]+reset[[:space:]].*--hard'
  'git[[:space:]]+clean[[:space:]].*-[^[:space:]]*[xX]'
  'docker[[:space:]]+compose[[:space:]].*down.*[[:space:]](-v|--volumes)([[:space:]]|$)'
)
for pattern in "${destructive[@]}"; do
  if [[ "$target" =~ $pattern ]]; then
    block "destructive command; ask the user to run it manually"
  fi
done

exit 0
