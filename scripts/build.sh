#!/bin/bash
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
JAVA_HOME="${JAVA_HOME:-$(/usr/libexec/java_home -v 21)}"
JPL="${DENTAL_JPL_JAR:-$ROOT/.runtime/SWI-Prolog.app/Contents/Resources/swipl/lib/jpl.jar}"
[ -f "$JPL" ] || { echo 'Run scripts/bootstrap.sh first.' >&2; exit 1; }
# Recreate generated classes so removed resources cannot remain in the JAR.
rm -rf "$ROOT/build/classes"
mkdir -p "$ROOT/build/classes" "$ROOT/build/stage"
"$JAVA_HOME/bin/javac" --release 21 -cp "$JPL" -d "$ROOT/build/classes" "$ROOT"/src/main/java/dental/*.java
cp -R "$ROOT/src/main/resources/." "$ROOT/build/classes/"
printf 'Manifest-Version: 1.0\nMain-Class: dental.App\nClass-Path: jpl.jar\nImplementation-Version: 1.3.0\n\n' > "$ROOT/build/manifest.mf"
"$JAVA_HOME/bin/jar" --create --date=2026-01-01T00:00:00Z --file "$ROOT/build/stage/DentalExplain.jar" --manifest "$ROOT/build/manifest.mf" -C "$ROOT/build/classes" .
cp "$JPL" "$ROOT/build/stage/jpl.jar"
