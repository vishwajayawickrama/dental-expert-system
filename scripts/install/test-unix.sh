#!/bin/bash
set -euo pipefail
ROOT=$(CDPATH= cd -- "$(dirname -- "$0")/../.." && pwd)
source "$ROOT/scripts/install/common-unix.sh"
check_dependencies
export JAVA_HOME="$DENTAL_JAVA"
mkdir -p "$ROOT/build/test-classes" "$ROOT/build/reports"
"$DENTAL_SWIPL" -q -s "$ROOT/knowledge/acceptance.pl" -g run_acceptance -t halt
"$DENTAL_JAVA/bin/javac" --release 21 -cp "$ROOT/build/stage/DentalExplain.jar:$DENTAL_JPL" -d "$ROOT/build/test-classes" "$ROOT"/src/test/java/dental/*.java
if [[ "$DENTAL_PLATFORM" == macos ]]; then
 export DYLD_LIBRARY_PATH="$DENTAL_PROLOG/Frameworks:$DENTAL_JAVA/lib/server"
else
 export LD_LIBRARY_PATH="$(dirname "$(find "$DENTAL_PROLOG" -name libjpl.so -print -quit)"):$DENTAL_PROLOG/lib:$DENTAL_JAVA/lib/server"
fi
"$DENTAL_JAVA/bin/java" "-Ddental.home=$ROOT" "-Ddental.prolog.home=$DENTAL_PROLOG" -cp "$ROOT/build/stage/DentalExplain.jar:$ROOT/build/test-classes:$DENTAL_JPL" dental.IntegrationTest
