#!/bin/bash
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
JAVA_HOME="$(/usr/libexec/java_home -v 21)"
"$ROOT/scripts/build.sh"
mkdir -p "$ROOT/build/test-classes" "$ROOT/build/reports"
"$ROOT/.runtime/SWI-Prolog.app/Contents/MacOS/swipl" -q -s "$ROOT/knowledge/acceptance.pl" -g run_acceptance -t halt 2>&1 | tee "$ROOT/build/reports/prolog-tests.txt"
"$JAVA_HOME/bin/javac" --release 21 -cp "$ROOT/build/classes:$ROOT/build/stage/jpl.jar" -d "$ROOT/build/test-classes" "$ROOT"/src/test/java/dental/*.java
"$JAVA_HOME/bin/java" -Ddental.home="$ROOT" -cp "$ROOT/build/classes:$ROOT/build/test-classes:$ROOT/build/stage/jpl.jar" dental.IntegrationTest 2>&1 | tee "$ROOT/build/reports/java-tests.txt"
