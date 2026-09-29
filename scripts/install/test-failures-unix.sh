#!/bin/bash
set -euo pipefail
BASE=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
WORK=$(mktemp -d)
trap 'rm -rf "$WORK"' EXIT
expect_failure(){ if "$@" >"$WORK/failure.txt" 2>&1; then echo 'Expected failure was accepted' >&2; exit 1; fi; }
expect_failure env DENTAL_PROLOG_HOME="$WORK/Missing Prolog" bash -c 'source "$1/common-unix.sh"; check_dependencies' _ "$BASE"
grep -q 'SWI-Prolog 10.0.2 is missing' "$WORK/failure.txt"
printf 'partial download\n' > "$WORK/vendor.bin"
expect_failure bash -c 'source "$1/common-unix.sh"; verify_hash "$2" "$3"' _ "$BASE" "$(printf '0%.0s' {1..64})" "$WORK/vendor.bin"
grep -q 'checksum mismatch' "$WORK/failure.txt"
expect_failure bash -c 'source "$1/common-unix.sh"; fetch http://127.0.0.1:1/unavailable "$2" "$3"' _ "$BASE" "$(printf '0%.0s' {1..64})" "$WORK/retry.bin"
[[ ! -e "$WORK/retry.bin" ]]
# A subsequent verified fetch ignores an incomplete .part file.
printf 'complete download\n' > "$WORK/retry.bin"
HASH=$(shasum -a 256 "$WORK/retry.bin" | awk '{print $1}')
mkdir "$WORK/out"; printf 'partial\n' > "$WORK/out/retry.bin.part"
DENTAL_DOWNLOAD_CACHE="$WORK" bash -c 'source "$1/common-unix.sh"; fetch https://unused.invalid "$2" "$3"' _ "$BASE" "$HASH" "$WORK/out/retry.bin"
cmp "$WORK/retry.bin" "$WORK/out/retry.bin"
echo 'PASS: missing dependency, checksum rejection, interrupted download, verified retry.'
