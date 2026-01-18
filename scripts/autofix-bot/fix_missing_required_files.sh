#!/usr/bin/env bash
set -euo pipefail

# This script auto-opens PRs for missing required files.

REQUIRED_FILES=(
  ".github/dependabot.yml"
  ".github/workflows/ci.yml"
)

TARGET_REPO="https://github.com/git-store-hub/${REPO_SLUG}"  # Ensure REPO_SLUG is used here
BASE_BRANCH="main"

for FILE in "${REQUIRED_FILES[@]}"; do
  if [ ! -f "$FILE" ]; then
    echo "Fixing missing required file: ${FILE}"
    cp "${TARGET_REPO}/templates/$(basename $FILE)" "$FILE"
  fi
done

# Create a PR for the fixes
gh pr create --base "${BASE_BRANCH}" --head "${BASE_BRANCH}" --title "Auto-fix missing required files" --body "Automatically added missing required files."
