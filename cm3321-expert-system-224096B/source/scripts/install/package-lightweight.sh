#!/bin/bash
set -euo pipefail
ROOT=$(CDPATH= cd -- "$(dirname -- "$0")/../.." && pwd)
DEST="$ROOT/build/lightweight"
mkdir -p "$DEST/application/knowledge" "$DEST/scripts/install"
cp "$ROOT/build/stage/DentalExplain.jar" "$DEST/application/"
cp "$ROOT/knowledge/"{engine,domain,questions}.pl "$DEST/application/knowledge/"
cp "$ROOT/scripts/install/"{common-unix,dependencies-macos,dependencies-linux,application-unix,launch-unix}.sh "$DEST/scripts/install/"
cp "$ROOT/scripts/install/windows.ps1" "$DEST/scripts/install/"
cp "$ROOT/scripts/submission/"Install-* "$DEST/"
APP="$DEST/application/macos/DentalExplain.app"
mkdir -p "$APP/Contents/"{MacOS,Resources/application}
cat > "$APP/Contents/Info.plist" <<'PLIST'
<?xml version="1.0" encoding="UTF-8"?><!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd"><plist version="1.0"><dict><key>CFBundleName</key><string>DentalExplain</string><key>CFBundleIdentifier</key><string>dev.dentalexplain.desktop</string><key>CFBundleExecutable</key><string>DentalExplain</string><key>CFBundlePackageType</key><string>APPL</string><key>CFBundleShortVersionString</key><string>1.3.0</string><key>CFBundleIconFile</key><string>DentalExplain.icns</string></dict></plist>
PLIST
cat > "$APP/Contents/MacOS/DentalExplain" <<'LAUNCH'
#!/bin/bash
APP=$(CDPATH= cd -- "$(dirname -- "$0")/../Resources/application" && pwd)
if [[ ! -f "$APP/launch.sh" ]]; then /usr/bin/osascript -e 'display alert "DentalExplain" message "Run Install-Application-macOS.command first."'; exit 1; fi
mkdir -p "$HOME/Library/Logs"
"$APP/launch.sh" "$@" 2>"$HOME/Library/Logs/DentalExplain-startup.log"
STATUS=$?
if [[ $STATUS -ne 0 ]]; then /usr/bin/osascript -e 'display alert "DentalExplain could not start" message "Run Install-Dependencies-macOS.command again. Details are in Library/Logs/DentalExplain-startup.log."'; fi
exit "$STATUS"
LAUNCH
[[ ! -f "$ROOT/build/DentalExplain.icns" ]] || cp "$ROOT/build/DentalExplain.icns" "$APP/Contents/Resources/"
chmod +x "$APP/Contents/MacOS/DentalExplain" "$DEST/"*.command "$DEST/"*.sh "$DEST/scripts/install/"*.sh
printf '%s\n' "$DEST"
