#!/usr/bin/env bash
set -euo pipefail

# This script auto-opens PRs for outdated dependabot config.

DEPENDABOT_FILE=".github/dependabot.yml"
TARGET_REPO="https://github.com/git-store-hub/${REPO_SLUG}"
BASE_BRANCH="main"

# Check for outdated dependabot
if ! grep -q "version: 2" "${DEPENDABOT_FILE}"; then
  echo "Fixing outdated dependabot configuration"
  cp "${TARGET_REPO}/templates/dependabot.yml" "${DEPENDABOT_FILE}"
fi

# Create a PR for the fixes
gh pr create --base "${BASE_BRANCH}" --head "${BASE_BRANCH}" --title "Auto-fix outdated dependabot" --body "Automatically updated dependabot.yml configuration."
