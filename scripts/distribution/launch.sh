#!/bin/sh
set -eu
DENTAL_DIR=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
if [ "$(uname -s)" = Linux ]; then
  DENTAL_NATIVE=$(find "$DENTAL_DIR/runtime/prolog" -name libjpl.so -print -quit)
  export LD_LIBRARY_PATH="$DENTAL_DIR/runtime/prolog/native:$(dirname "$DENTAL_NATIVE"):$DENTAL_DIR/runtime/java/lib/server${LD_LIBRARY_PATH:+:$LD_LIBRARY_PATH}"
fi
exec "$DENTAL_DIR/runtime/java/bin/java" -jar "$DENTAL_DIR/DentalExplain.jar" "$@"
