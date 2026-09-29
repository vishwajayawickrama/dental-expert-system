#!/bin/bash
# Fetch the exact vendor runtime into an ignored local directory. No global install.
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
[ "$(uname -m)" = arm64 ] || { echo 'This release targets Apple Silicon macOS.' >&2; exit 1; }
mkdir -p "$ROOT/.runtime"
if [ ! -f "$ROOT/.runtime/SWI-Prolog.app/Contents/Resources/swipl/lib/jpl.jar" ]; then
  curl --fail --location 'https://www.swi-prolog.org/download/stable/bin/swipl-10.0.2-1.fat.dmg' -o "$ROOT/.runtime/swipl.dmg"
  echo 'bf775f0b8d7880f4908dee513316013ef42a73793be392814fde2a0a8e9ddc5d  '"$ROOT/.runtime/swipl.dmg" | shasum -a 256 -c -
  MOUNT="$(mktemp -d /private/tmp/dental-swipl.XXXXXX)"
  hdiutil attach "$ROOT/.runtime/swipl.dmg" -readonly -nobrowse -mountpoint "$MOUNT"
  trap 'hdiutil detach "$MOUNT" >/dev/null || true' EXIT
  ditto "$MOUNT/SWI-Prolog.app" "$ROOT/.runtime/SWI-Prolog.app"
  hdiutil detach "$MOUNT"
  trap - EXIT
fi
# Vendor rpaths assume the vendor executable. Make embedding resolve locally.
CORE="$ROOT/.runtime/SWI-Prolog.app/Contents/Frameworks/libswipl.10.0.2.dylib"
NATIVE="$ROOT/.runtime/SWI-Prolog.app/Contents/PlugIns/swipl/libjpl.dylib"
if ! otool -l "$CORE" | grep -q 'path @loader_path '; then install_name_tool -add_rpath '@loader_path' "$CORE"; codesign --force --sign - "$CORE"; fi
if ! otool -l "$NATIVE" | grep -q 'path @loader_path/../../Frameworks '; then install_name_tool -add_rpath '@loader_path/../../Frameworks' "$NATIVE"; codesign --force --sign - "$NATIVE"; fi
"$ROOT/.runtime/SWI-Prolog.app/Contents/MacOS/swipl" --version
