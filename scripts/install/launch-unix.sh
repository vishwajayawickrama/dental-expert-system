#!/bin/bash
set -euo pipefail
DENTAL_BASE=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
source "$DENTAL_BASE/common-unix.sh"
if [[ "$(uname -s)" == Linux && $# -eq 0 ]]; then
  "$DENTAL_BASE/common-unix.sh" >/dev/null 2>&1 || true
  ERROR=$( (check_dependencies) 2>&1) || {
    command -v notify-send >/dev/null && notify-send 'DentalExplain could not start' "$ERROR" || true
    printf '%s\n' "$ERROR" >&2; exit 1
  }
fi
launch_java "$DENTAL_BASE" "$@"

