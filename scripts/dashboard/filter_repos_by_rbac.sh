#!/usr/bin/env bash
set -euo pipefail

# Filters DASHBOARD_REPOS_JSON based on RBAC policy rules.
# For now: only implements "viewer can read repos listed for their subject" (very simple).
# Future: integrate GitHub team membership via `gh api orgs/:org/teams/:team/memberships/:user`.

command -v jq >/dev/null || { echo "jq required" >&2; exit 1; }

: "${DASHBOARD_REPOS_JSON:?Set DASHBOARD_REPOS_JSON}"
: "${RBAC_POLICY_PATH:?Set RBAC_POLICY_PATH}"
: "${RBAC_SUBJECT:?Set RBAC_SUBJECT e.g. user:Scarfy or team:security-admins}"

POLICY="$(cat "${RBAC_POLICY_PATH}")"
ALL_REPOS="$(echo "${DASHBOARD_REPOS_JSON}" | jq -c '.')"

# Determine allowed repo patterns for the subject
ALLOWED_PATTERNS="$(python3 - <<PY
import sys, yaml, json
from pathlib import Path
p = Path("${RBAC_POLICY_PATH}")
data = yaml.safe_load(p.read_text())
subject = "${RBAC_SUBJECT}"
allowed = []
for a in data.get("assignments", []):
    if a.get("subject") == subject:
        allowed += a.get("repos", [])
print(json.dumps(allowed))
PY
)"

# If subject has "*" allow all
if echo "${ALLOWED_PATTERNS}" | jq -e 'index("*") != null' >/dev/null; then
  echo "${ALL_REPOS}"
  exit 0
fi

# Else filter exact matches (v0)
echo "${ALL_REPOS}" | jq --argjson allow "${ALLOWED_PATTERNS}" '[ .[] | select( $allow | index(.) != null ) ]'
