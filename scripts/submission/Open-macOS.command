#!/bin/sh
set -eu
DENTAL_ROOT=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
DENTAL_APP="$DENTAL_ROOT/applications/macos/DentalExplain.app"
if [ "$(uname -s)" != Darwin ]; then
  printf '%s\n' 'Use Open-Windows.cmd or Open-Linux.sh on your platform.' >&2
  exit 1
fi
if [ ! -x "$DENTAL_APP/Contents/MacOS/DentalExplain" ]; then
  printf '%s\n' 'DentalExplain is missing. Extract the complete submission ZIP and keep its folders together.' >&2
  exit 1
fi
if [ "${1:-}" = --verify-runtime ]; then
  exec "$DENTAL_APP/Contents/MacOS/DentalExplain" "$@"
fi
exec /usr/bin/open -a "$DENTAL_APP" --args "$@"
