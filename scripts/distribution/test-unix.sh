#!/bin/bash
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
PROLOG="${1:?Prolog directory}"
JPL=$(find "$PROLOG" -name jpl.jar -print -quit)
SWIPL=$(find "$PROLOG" -type f -name swipl -print -quit)
mkdir -p "$ROOT/build/test-classes" "$ROOT/build/reports"
"$SWIPL" -q -s "$ROOT/knowledge/acceptance.pl" -g run_acceptance -t halt
"$JAVA_HOME/bin/javac" --release 21 -cp "$ROOT/build/stage/DentalExplain.jar:$JPL" -d "$ROOT/build/test-classes" "$ROOT"/src/test/java/dental/*.java
"$JAVA_HOME/bin/java" -Ddental.home="$ROOT" -cp "$ROOT/build/stage/DentalExplain.jar:$ROOT/build/test-classes:$JPL" dental.IntegrationTest
