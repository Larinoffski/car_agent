#!/usr/bin/env bash
# Creates the GitHub deployment environments used by CI: staging and production.
# Secrets (APP_KEY, DB_PASSWORD) are added by a human in Settings -> Environments.
#
# Requirements: gh authenticated with admin rights on the repository. Runs on the host, not in Docker.
# Usage: scripts/github/environments.sh
# Safe to re-run: PUT creates the environment or leaves an existing one unchanged.
set -euo pipefail

# Print API output directly instead of through a pager.
export GH_PAGER=cat

api_version=2026-03-10
environments=(staging production)

command -v gh >/dev/null || { echo "gh is required" >&2; exit 1; }
gh auth status >/dev/null

repo=$(gh repo view --json nameWithOwner --jq .nameWithOwner)

for env in "${environments[@]}"; do
  gh api -H "X-GitHub-Api-Version: $api_version" \
    -X PUT "repos/$repo/environments/$env" --jq .name
done
