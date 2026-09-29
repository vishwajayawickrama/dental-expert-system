#!/bin/bash
set -euo pipefail
DENTAL_BASE=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
source "$DENTAL_BASE/common-unix.sh"
check_dependencies
PAYLOAD="$DENTAL_BASE/../application"
[[ -f "$PAYLOAD/DentalExplain.jar" ]] || fail 'Extract the complete submission before installation.'
if [[ "$DENTAL_PLATFORM" == macos ]]; then
  DEST="$HOME/Applications/DentalExplain.app"
  mkdir -p "$HOME/Applications"
  ditto "$PAYLOAD/macos/DentalExplain.app" "$DEST"
  APP="$DEST/Contents/Resources/application"
else
  DEST="$HOME/.local/share/DentalExplain"
  mkdir -p "$DEST" "$HOME/.local/share/applications"
  APP="$DEST"
fi
cp "$PAYLOAD/DentalExplain.jar" "$APP/"
cp -R "$PAYLOAD/knowledge" "$APP/"
cp "$DENTAL_BASE/common-unix.sh" "$APP/"
cp "$DENTAL_BASE/launch-unix.sh" "$APP/launch.sh"
chmod +x "$APP/launch.sh"
launch_java "$APP" --verify-runtime
if [[ "$DENTAL_PLATFORM" == linux ]]; then
  # Desktop-entry quoting also escapes dollar/backtick characters; paths are data.
  ESCAPED=${APP//\\/\\\\}; ESCAPED=${ESCAPED//\"/\\\"}; ESCAPED=${ESCAPED//\$/\\\$}; ESCAPED=${ESCAPED//\`/\\\`}
  printf '[Desktop Entry]\nType=Application\nName=DentalExplain\nComment=Dental Expert System\nExec="%s/launch.sh"\nTerminal=false\nCategories=Education;Science;\n' "$ESCAPED" > "$HOME/.local/share/applications/dentalexplain.desktop"
  chmod +x "$HOME/.local/share/applications/dentalexplain.desktop"
fi
printf 'Installed for current user: %s\n' "$DEST"
if [[ "${1:-}" != --no-launch ]]; then
  if [[ "$DENTAL_PLATFORM" == macos ]]; then open -n "$DEST"; else "$APP/launch.sh" >/dev/null 2>&1 & fi
fi
