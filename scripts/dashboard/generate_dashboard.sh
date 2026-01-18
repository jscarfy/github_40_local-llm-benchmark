#!/usr/bin/env bash
set -euo pipefail

command -v gh >/dev/null || { echo "gh required" >&2; exit 1; }
command -v jq >/dev/null || { echo "jq required" >&2; exit 1; }

OUT_DIR="${1:-docs/dashboard}"
mkdir -p "${OUT_DIR}"

: "${DASHBOARD_REPOS_JSON:?Set DASHBOARD_REPOS_JSON (JSON array)}"

REPOS_JSON="${DASHBOARD_REPOS_JSON}"

# Optional RBAC filtering:
# export RBAC_POLICY_PATH="docs/enterprise/rbac-policy.yml"
# export RBAC_SUBJECT="user:Scarfy"
if [[ -n "${RBAC_POLICY_PATH:-}" && -n "${RBAC_SUBJECT:-}" && -x "scripts/dashboard/filter_repos_by_rbac.sh" ]]; then
  REPOS_JSON="$(RBAC_POLICY_PATH="${RBAC_POLICY_PATH}" RBAC_SUBJECT="${RBAC_SUBJECT}" DASHBOARD_REPOS_JSON="${REPOS_JSON}" \
    scripts/dashboard/filter_repos_by_rbac.sh)"
fi

REPOS="$(echo "${REPOS_JSON}" | jq -r '.[]')"

TMP_JSON="$(mktemp)"
echo "[]" > "${TMP_JSON}"

for SLUG in ${REPOS}; do
  echo "Collecting: ${SLUG}" >&2
  REPO_JSON="$(gh api "repos/${SLUG}" 2>/dev/null || echo '{}')"
  DEFAULT_BRANCH="$(echo "${REPO_JSON}" | jq -r '.default_branch // "main"')"
  ARCHIVED="$(echo "${REPO_JSON}" | jq -r '.archived // false')"
  PUSHED_AT="$(echo "${REPO_JSON}" | jq -r '.pushed_at // null')"
  HTML_URL="$(echo "${REPO_JSON}" | jq -r '.html_url // ("https://github.com/" + "'"${SLUG}"'")')"

  # Required file check (best-effort)
  REQUIRED=(
    ".github/dependabot.yml"
    ".github/workflows/ci.yml"
    ".github/workflows/security-baseline.yml"
    "SECURITY.md"
  )
  MISSING=()
  for PATH in "${REQUIRED[@]}"; do
    if ! gh api "repos/${SLUG}/contents/${PATH}?ref=${DEFAULT_BRANCH}" >/dev/null 2>&1; then
      MISSING+=("${PATH}")
    fi
  done

  ITEM="$(jq -n \
    --arg slug "${SLUG}" \
    --arg url "${HTML_URL}" \
    --arg default_branch "${DEFAULT_BRANCH}" \
    --arg pushed_at "${PUSHED_AT}" \
    --arg archived "${ARCHIVED}" \
    --argjson missing "$(printf '%s\n' "${MISSING[@]}" | jq -R . | jq -s .)" \
    '{
      slug: $slug,
      url: $url,
      default_branch: $default_branch,
      pushed_at: $pushed_at,
      archived: ($archived == "true"),
      missing_required_files: $missing
    }'
  )"

  jq --argjson item "${ITEM}" '. + [$item]' "${TMP_JSON}" > "${TMP_JSON}.new"
  mv "${TMP_JSON}.new" "${TMP_JSON}"
done

JSON_OUT="${OUT_DIR}/dashboard.json"
MD_OUT="${OUT_DIR}/README.md"

cp "${TMP_JSON}" "${JSON_OUT}"

{
  echo "# Enterprise Security Dashboard"
  echo
  echo "Generated: $(date -u +"%Y-%m-%dT%H:%M:%SZ")"
  echo
  echo "| Repo | Default | Last Push | Missing Required Files |"
  echo "|---|---:|---:|---|"
  jq -r '
    .[]
    | [
        ("[" + .slug + "](" + .url + ")"),
        .default_branch,
        (.pushed_at // "-"),
        (if (.missing_required_files|length)==0 then "✅" else ("❌ " + (.missing_required_files|join(", "))) end)
      ]
    | "| " + join(" | ") + " |"
  ' "${JSON_OUT}"
  echo
} > "${MD_OUT}"

echo "Wrote:"
echo " - ${JSON_OUT}"
echo " - ${MD_OUT}"
