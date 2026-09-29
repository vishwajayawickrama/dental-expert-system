#!/bin/bash
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
PLATFORM="${1:?macos-arm64 or linux-x64}"
PROLOG="${2:?Prolog directory}"
JAVA_HOME="${JAVA_HOME:-$(/usr/libexec/java_home -v 21)}"
DEST="$ROOT/build/distribution/DentalExplain-java-$PLATFORM"
case "$PLATFORM" in macos-arm64|linux-x64) ;; *) exit 2 ;; esac
rm -rf "$DEST"
mkdir -p "$DEST/runtime" "$ROOT/dist"
cp "$ROOT/build/stage/"*.jar "$DEST/"
cp -R "$ROOT/knowledge" "$DEST/knowledge"
cp -R "$PROLOG" "$DEST/runtime/prolog"
"$JAVA_HOME/bin/jlink" --add-modules java.desktop,java.logging,java.xml --strip-debug --no-header-files --no-man-pages --output "$DEST/runtime/java"
cp "$ROOT/scripts/distribution/launch.sh" "$DEST/launch.sh"
chmod +x "$DEST/launch.sh"
if [ "$PLATFORM" = macos-arm64 ]; then
  cp "$DEST/launch.sh" "$DEST/Launch.command"
  # Preserve vendor resources and license files, including Java redistribution notices.
  cp -R "$JAVA_HOME/legal" "$DEST/runtime/java/" 2>/dev/null || true
fi
cp "$ROOT/scripts/distribution/README.txt" "$DEST/README.txt"
cp "$ROOT/LICENSE" "$DEST/" 2>/dev/null || true
(cd "$(dirname "$DEST")" && zip -qry "$ROOT/dist/DentalExplain-java-$PLATFORM.zip" "$(basename "$DEST")")
shasum -a 256 "$DEST/DentalExplain.jar" > "$ROOT/dist/jar-$PLATFORM.sha256"
printf '%s\n' "$DEST"
