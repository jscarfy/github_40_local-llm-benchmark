#!/usr/bin/env bash
set -euo pipefail

command -v git >/dev/null || { echo "git required" >&2; exit 1; }
command -v gh  >/dev/null || { echo "gh required" >&2; exit 1; }

: "${BASE_BRANCH:=main}"
: "${FIX_BRANCH:=autofix/missing-required-files}"
: "${TEMPLATES_DIR:=templates}"

REQUIRED_FILES=(
  ".github/dependabot.yml"
  ".github/workflows/ci.yml"
  ".github/workflows/security-baseline.yml"
  "SECURITY.md"
)

# Ensure no uncommitted changes
if ! git diff --quiet || ! git diff --cached --quiet; then
  echo "ERROR: uncommitted changes exist; please commit or stash first." >&2
  exit 1
fi

# Ensure the base branch is up-to-date
git checkout "${BASE_BRANCH}"
git pull --ff-only || true

# Create or checkout the fix branch
if git show-ref --verify --quiet "refs/heads/${FIX_BRANCH}"; then
  git branch -D "${FIX_BRANCH}"
fi
git checkout -b "${FIX_BRANCH}"

# Add missing required files
changed=0
for f in "${REQUIRED_FILES[@]}"; do
  if [[ ! -f "${f}" ]]; then
    src="${TEMPLATES_DIR}/${f}"
    if [[ ! -f "${src}" ]]; then
      echo "ERROR: missing template: ${src}" >&2
      exit 1
    fi
    echo "Adding: ${f}"
    mkdir -p "$(dirname "${f}")"
    cp "${src}" "${f}"
    changed=1
  fi
done

if [[ "${changed}" -eq 0 ]]; then
  echo "No missing required files. Exiting."
  exit 0
fi

# Commit and push the changes
git add -A
git commit -m "chore(autofix): add missing required baseline files"

git push -u origin "${FIX_BRANCH}"

# Create PR (idempotent check)
gh pr create \
  --base "${BASE_BRANCH}" \
  --head "${FIX_BRANCH}" \
  --title "chore(autofix): add missing required baseline files" \
  --body "Automatically added missing required baseline files from templates."
