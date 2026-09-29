#!/bin/bash
set -euo pipefail
ROOT=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
exec /bin/bash "$ROOT/../helpers/application-unix.sh" "$@"
