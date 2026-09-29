#!/bin/bash
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
JAVA_HOME="${JAVA_HOME:-$(/usr/libexec/java_home -v 21)}"
exec "$JAVA_HOME/bin/java" -Ddental.home="$ROOT" -cp "$ROOT/build/stage/DentalExplain.jar:$ROOT/build/stage/jpl.jar" dental.App "$@"
