#!/bin/bash
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
JAVA_HOME="${JAVA_HOME:-$(/usr/libexec/java_home -v 21)}"
"$ROOT/scripts/build.sh"
mkdir -p "$ROOT/build/DentalExplain.iconset" "$ROOT/dist"
"$JAVA_HOME/bin/javac" -cp "$ROOT/build/classes" -d "$ROOT/build/classes" "$ROOT/scripts/IconBuilder.java"
"$JAVA_HOME/bin/java" -Djava.awt.headless=true -cp "$ROOT/build/classes:$ROOT/build/stage/jpl.jar" IconBuilder "$ROOT/build/DentalExplain.iconset"
iconutil -c icns "$ROOT/build/DentalExplain.iconset" -o "$ROOT/build/DentalExplain.icns"
# Existing deliverables are preserved; each packaging run has a unique output directory.
DEST="$ROOT/dist/release-$(date +%Y%m%d-%H%M%S)"
"$JAVA_HOME/bin/jpackage" --type app-image --dest "$DEST" --name DentalExplain \
  --input "$ROOT/build/stage" --main-jar DentalExplain.jar --main-class dental.App \
  --app-version 1.2.0 --vendor DentalExplain --mac-package-identifier dev.dentalexplain.desktop \
  --icon "$ROOT/build/DentalExplain.icns" --java-options '-Ddental.home=$APPDIR'
APP="$DEST/DentalExplain.app"
mkdir -p "$APP/Contents/app/knowledge" "$APP/Contents/app/runtime"
cp "$ROOT/knowledge/engine.pl" "$ROOT/knowledge/questions.pl" "$ROOT/knowledge/domain.pl" "$APP/Contents/app/knowledge/"
ditto "$ROOT/.runtime/SWI-Prolog.app/Contents/Resources" "$APP/Contents/app/runtime/Resources"
ditto "$ROOT/.runtime/SWI-Prolog.app/Contents/Frameworks" "$APP/Contents/app/runtime/Frameworks"
ditto "$ROOT/.runtime/SWI-Prolog.app/Contents/PlugIns" "$APP/Contents/app/runtime/PlugIns"
NATIVE="$APP/Contents/app/runtime/PlugIns/swipl/libjpl.dylib"
install_name_tool -add_rpath '@loader_path/../../../../runtime/Contents/Home/lib/server' "$NATIVE"
codesign --force --sign - "$NATIVE"
# Re-sign the image after adding resources. Developer ID signing/notarization is a later distribution step.
codesign --force --deep --sign - "$APP"
"$APP/Contents/MacOS/DentalExplain" --verify-runtime
printf '%s\n' "$APP" > "$ROOT/build/latest-app.txt"
printf 'Application image: %s\n' "$APP"
