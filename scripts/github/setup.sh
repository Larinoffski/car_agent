#!/usr/bin/env bash
# Applies GitHub settings to the current repository:
# - merges: squash only, PR title and description become the commit message, head branches are deleted;
# - security: secret scanning, push protection, Dependabot alerts;
# - rulesets: ruleset-main.json (default branch), ruleset-tags.json (release tags v*).
#
# Requirements: gh authenticated with admin rights on the repository, jq. Runs on the host, not in Docker.
# Usage: scripts/github/setup.sh
# Safe to re-run: rulesets are matched by name and updated in place.
# Required status checks are listed in ruleset-main.json; a check can be added only after it has run once.
set -euo pipefail

dir=$(cd "$(dirname "$0")" && pwd)
api_version=2026-03-10

for cmd in gh jq; do
  command -v "$cmd" >/dev/null || { echo "$cmd is required" >&2; exit 1; }
done
gh auth status >/dev/null

repo=$(gh repo view --json nameWithOwner --jq .nameWithOwner)

api() {
  gh api -H "X-GitHub-Api-Version: $api_version" "$@"
}

ruleset_id() {
  api --paginate "repos/$repo/rulesets?includes_parents=false" |
    jq -r --arg name "$1" '.[] | select(.name == $name) | .id'
}

apply_ruleset() {
  local file=$1 name id
  name=$(jq -r .name "$file")
  id=$(ruleset_id "$name")
  if [[ -n "$id" ]]; then
    api -X PUT "repos/$repo/rulesets/$id" --input "$file" >/dev/null
    echo "Ruleset updated: $name"
  else
    api -X POST "repos/$repo/rulesets" --input "$file" >/dev/null
    echo "Ruleset created: $name"
  fi
}

echo "Repository: $repo"

api -X PATCH "repos/$repo" --input - >/dev/null <<'JSON'
{
  "allow_squash_merge": true,
  "allow_merge_commit": false,
  "allow_rebase_merge": false,
  "squash_merge_commit_title": "PR_TITLE",
  "squash_merge_commit_message": "PR_BODY",
  "delete_branch_on_merge": true,
  "security_and_analysis": {
    "secret_scanning": { "status": "enabled" },
    "secret_scanning_push_protection": { "status": "enabled" }
  }
}
JSON
echo "Repository settings updated"

api -X PUT "repos/$repo/vulnerability-alerts" >/dev/null
echo "Dependabot alerts enabled"

apply_ruleset "$dir/ruleset-main.json"
apply_ruleset "$dir/ruleset-tags.json"

echo
echo "== Repository settings"
api "repos/$repo" --jq '{allow_squash_merge, allow_merge_commit, allow_rebase_merge,
  squash_merge_commit_title, squash_merge_commit_message, delete_branch_on_merge, security_and_analysis}'

echo "== Rulesets"
for id in $(api --paginate "repos/$repo/rulesets?includes_parents=false" | jq -r '.[].id'); do
  api "repos/$repo/rulesets/$id" --jq '{name, target, enforcement, conditions, rules}'
done
