#!/bin/sh
set -eu
DENTAL_ROOT=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
DENTAL_APP="$DENTAL_ROOT/applications/linux/DentalExplain"
if [ "$(uname -s)" != Linux ]; then
  printf '%s\n' 'Use Open-Windows.cmd or Open-macOS.command on your platform.' >&2
  exit 1
fi
if [ ! -f "$DENTAL_APP/launch.sh" ] || [ ! -x "$DENTAL_APP/runtime/java/bin/java" ]; then
  printf '%s\n' 'DentalExplain or its runtime is missing. Extract the complete ZIP and preserve executable permissions.' >&2
  exit 1
fi
exec /bin/sh "$DENTAL_APP/launch.sh" "$@"
