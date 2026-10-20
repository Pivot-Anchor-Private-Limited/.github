#!/usr/bin/env bash
# Sync the Agentic Studio label set into one or more repos (creates or updates; never deletes).
# Usage: studio/sync-labels.sh <repo> [<repo>...]   e.g. studio/sync-labels.sh naad-coffee-revamp
set -euo pipefail
ORG=Pivot-Anchor-Private-Limited
LABELS="$(dirname "$0")/labels.json"
[ $# -ge 1 ] || { echo "usage: $0 <repo> [<repo>...]" >&2; exit 2; }
for repo in "$@"; do
  python3 -c 'import json,sys; [print("\t".join([l["name"], l["color"], l["description"]])) for l in json.load(open(sys.argv[1]))]' "$LABELS" |
  while IFS=$'\t' read -r name color desc; do
    gh label create "$name" --repo "$ORG/$repo" --color "$color" --description "$desc" --force
  done
  echo "synced $repo"
done
