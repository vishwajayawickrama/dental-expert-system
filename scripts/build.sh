#!/bin/bash
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
JAVA_HOME="$(/usr/libexec/java_home -v 21)"
JPL="$ROOT/.runtime/SWI-Prolog.app/Contents/Resources/swipl/lib/jpl.jar"
[ -f "$JPL" ] || { echo 'Run scripts/bootstrap.sh first.' >&2; exit 1; }
# Recreate generated classes so removed resources cannot remain in the JAR.
rm -rf "$ROOT/build/classes"
mkdir -p "$ROOT/build/classes" "$ROOT/build/stage"
"$JAVA_HOME/bin/javac" --release 21 -cp "$JPL" -d "$ROOT/build/classes" "$ROOT"/src/main/java/dental/*.java
cp -R "$ROOT/src/main/resources/." "$ROOT/build/classes/"
"$JAVA_HOME/bin/jar" --create --file "$ROOT/build/stage/DentalExplain.jar" --main-class dental.App -C "$ROOT/build/classes" .
cp "$JPL" "$ROOT/build/stage/jpl.jar"
