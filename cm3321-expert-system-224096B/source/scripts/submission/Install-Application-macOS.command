#!/bin/bash
set -euo pipefail
ROOT=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
exec /bin/bash "$ROOT/scripts/install/application-unix.sh" "$@"
