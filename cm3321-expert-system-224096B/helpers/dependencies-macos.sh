#!/bin/bash
set -euo pipefail
DENTAL_BASE=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
source "$DENTAL_BASE/common-unix.sh"
platform_paths
[[ "$DENTAL_PLATFORM" == macos ]] || fail 'This script requires Apple Silicon macOS.'
WORK=$(mktemp -d /private/tmp/dental-dependencies.XXXXXX)
MOUNT=''
trap '[[ -z "$MOUNT" ]] || hdiutil detach "$MOUNT" >/dev/null 2>&1 || true; rm -rf "$WORK"' EXIT
if [[ ! -x "$DENTAL_JAVA/bin/java" ]]; then
  printf '%s\n' 'Installing Temurin Java 21 for all users; macOS will request administrator access.'
  curl --fail --location --retry 3 'https://api.adoptium.net/v3/assets/latest/21/hotspot?architecture=aarch64&image_type=jdk&os=mac&vendor=eclipse' -o "$WORK/java.json"
  /usr/bin/plutil -extract 0.binary.installer.link raw -o "$WORK/java-url.txt" "$WORK/java.json"
  /usr/bin/plutil -extract 0.binary.installer.checksum raw -o "$WORK/java-sha.txt" "$WORK/java.json"
  fetch "$(cat "$WORK/java-url.txt")" "$(cat "$WORK/java-sha.txt")" "$WORK/java.pkg"
  pkgutil --check-signature "$WORK/java.pkg" >/dev/null || fail 'Java installer signature verification failed.'
  sudo installer -pkg "$WORK/java.pkg" -target /
fi
if [[ ! -x "$DENTAL_SWIPL" || ! -f "$DENTAL_PROLOG/Resources/swipl/lib/jpl.jar" ]]; then
  printf '%s\n' 'Installing SWI-Prolog 10.0.2 for all users.'
  fetch 'https://www.swi-prolog.org/download/stable/bin/swipl-10.0.2-1.fat.dmg' 'bf775f0b8d7880f4908dee513316013ef42a73793be392814fde2a0a8e9ddc5d' "$WORK/swipl.dmg"
  MOUNT="$WORK/mount"; mkdir "$MOUNT"
  hdiutil attach "$WORK/swipl.dmg" -readonly -nobrowse -mountpoint "$MOUNT" >/dev/null
  [[ ! -e /Applications/SWI-Prolog-10.0.2.app ]] || fail 'The versioned Prolog folder exists but is incomplete. Inspect it before rerunning.'
  if [[ -w /Applications ]]; then ditto "$MOUNT/SWI-Prolog.app" /Applications/SWI-Prolog-10.0.2.app; else sudo ditto "$MOUNT/SWI-Prolog.app" /Applications/SWI-Prolog-10.0.2.app; fi
fi
check_dependencies
launch_java "$DENTAL_BASE/../application" --verify-runtime
printf '%s\n' 'Dependencies ready. Run Install-Application-macOS.command next.'
