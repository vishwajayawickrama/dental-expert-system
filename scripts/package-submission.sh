#!/bin/bash
set -euo pipefail
ROOT=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)
DEST=${1:-$ROOT/build/submission-lightweight}
[[ ! -e "$DEST" ]] || { echo 'Choose a fresh staging directory.' >&2; exit 1; }
PAYLOAD="$ROOT/build/lightweight"
for file in "$PAYLOAD/application/DentalExplain.jar" "$PAYLOAD/application/windows/DentalExplain.exe" "$ROOT/docs/report/DentalExplain Report.docx" "$ROOT/docs/report/DentalExplain Report.pdf"; do
 [[ -s "$file" ]] || { printf 'Missing verified file: %s\n' "$file" >&2; exit 1; }
done
mkdir -p "$DEST/report" "$DEST/source/scripts" "$ROOT/dist"
cp -R "$PAYLOAD/." "$DEST/"
cp "$ROOT/scripts/submission/README.txt" "$DEST/"
cp "$ROOT/docs/report/DentalExplain Report."{docx,pdf} "$DEST/report/"
cp -R "$ROOT/src" "$ROOT/knowledge" "$DEST/source/"
cp "$ROOT/scripts/submission/source-README.md" "$DEST/source/README.md"
cp "$ROOT/scripts/build.sh" "$ROOT/scripts/IconBuilder.java" "$DEST/source/scripts/"
cp -R "$ROOT/scripts/install" "$DEST/source/scripts/"
mkdir -p "$DEST/source/scripts/submission"
cp "$ROOT/scripts/submission/"Install-* "$DEST/source/scripts/submission/"
cp "$ROOT/scripts/submission/THIRD-PARTY-NOTICES.txt" "$DEST/"
# All required dependencies are installed separately; reject accidental runtime inclusion.
if find "$DEST" -type d \( -name runtime -o -name .runtime -o -name .git -o -name node_modules \) | grep -q .; then echo 'Unexpected runtime or development directory' >&2; exit 1; fi
(cd "$DEST" && find . -type f ! -name SHA256SUMS.txt ! -name .DS_Store -print0 | LC_ALL=C sort -z | xargs -0 shasum -a 256 > SHA256SUMS.txt)
ARCHIVE="$ROOT/dist/DentalExplain-submission.zip"
if [[ -e "$ARCHIVE" ]]; then
 mkdir -p "$ROOT/dist/archive"
 mv "$ARCHIVE" "$ROOT/dist/archive/DentalExplain-submission-before-1.3.0-$(date +%Y%m%d-%H%M%S).zip"
fi
(cd "$DEST" && zip -q -r -y "$ARCHIVE" . -x '*.DS_Store' '*/__MACOSX/*')
SIZE=$(wc -c < "$ARCHIVE" | tr -d ' ')
[[ "$SIZE" -lt 20000000 ]] || { echo "Submission exceeds 20 MB: $SIZE bytes" >&2; exit 1; }
shasum -a 256 "$ARCHIVE" > "$ROOT/dist/DentalExplain-submission.sha256"
printf '%s (%s bytes)\n' "$ARCHIVE" "$SIZE"
