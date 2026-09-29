#!/bin/bash
# Shared installation helpers; no clinical inference is implemented here.
set -euo pipefail
fail(){ printf '%s\n' "$*" >&2; exit 1; }
verify_hash(){ printf '%s  %s\n' "$1" "$2" | shasum -a 256 -c - >/dev/null || fail 'Download checksum mismatch; nothing was installed.'; }
fetch(){
  local url="$1" hash="$2" destination="$3"
  if [[ -n "${DENTAL_DOWNLOAD_CACHE:-}" && -f "$DENTAL_DOWNLOAD_CACHE/$(basename "$destination")" ]]; then
    cp "$DENTAL_DOWNLOAD_CACHE/$(basename "$destination")" "$destination"
  else
    curl --fail --location --retry 3 --connect-timeout 30 "$url" -o "$destination.part" || fail 'Download failed. Check your connection and run this script again.'
    mv "$destination.part" "$destination"
  fi
  verify_hash "$hash" "$destination"
}
# An existing unrelated Prolog installation is never overwritten.
platform_paths(){
  case "$(uname -s)/$(uname -m)" in
    Darwin/arm64) DENTAL_PLATFORM=macos; DENTAL_PROLOG=${DENTAL_PROLOG_HOME:-/Applications/SWI-Prolog-10.0.2.app/Contents}
      DENTAL_JAVA=$(/usr/libexec/java_home -F -v 21 2>/dev/null || true); DENTAL_SWIPL="$DENTAL_PROLOG/MacOS/swipl" ;;
    Linux/x86_64) DENTAL_PLATFORM=linux; DENTAL_PROLOG=${DENTAL_PROLOG_HOME:-/opt/dentalexplain-dependencies/swipl-10.0.2}
      DENTAL_JAVA=${DENTAL_JAVA_HOME:-/usr/lib/jvm/java-21-openjdk-amd64}; DENTAL_SWIPL="$DENTAL_PROLOG/bin/swipl" ;;
    *) fail 'Supported: Apple Silicon macOS or Ubuntu 24.04 x64 desktop.' ;;
  esac
}
check_dependencies(){
  platform_paths
  [[ -x "$DENTAL_JAVA/bin/java" ]] || fail 'Java 21 is missing. Run Install-Dependencies for your OS first.'
  "$DENTAL_JAVA/bin/java" -version 2>&1 | head -1 | grep -Eq 'version "21[."]' || fail 'Java 21 is required.'
  [[ -x "$DENTAL_SWIPL" ]] || fail 'SWI-Prolog 10.0.2 is missing. Run Install-Dependencies for your OS first.'
  "$DENTAL_SWIPL" -q -g 'current_prolog_flag(version_data,swi(10,0,2,_))' -t halt || fail 'SWI-Prolog 10.0.2 is required.'
  DENTAL_JPL=$(find "$DENTAL_PROLOG" -type f -name jpl.jar -print -quit)
  [[ -f "$DENTAL_JPL" ]] || fail 'Matching jpl.jar is missing. Re-run Install-Dependencies.'
}
launch_java(){
  local app="$1"; shift
  check_dependencies
  if [[ "$DENTAL_PLATFORM" == macos ]]; then
    export DYLD_LIBRARY_PATH="$DENTAL_PROLOG/Frameworks:$DENTAL_JAVA/lib/server${DYLD_LIBRARY_PATH:+:$DYLD_LIBRARY_PATH}"
  else
    local native; native=$(find "$DENTAL_PROLOG" -type f -name libjpl.so -print -quit)
    [[ -n "$native" ]] || fail 'Native JPL library is missing.'
    export LD_LIBRARY_PATH="$(dirname "$native"):$DENTAL_PROLOG/lib:$DENTAL_JAVA/lib/server${LD_LIBRARY_PATH:+:$LD_LIBRARY_PATH}"
  fi
  "$DENTAL_JAVA/bin/java" "-Ddental.home=$app" "-Ddental.prolog.home=$DENTAL_PROLOG" -cp "$app/DentalExplain.jar:$DENTAL_JPL" dental.App "$@"
}
