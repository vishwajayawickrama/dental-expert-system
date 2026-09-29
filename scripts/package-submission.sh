#!/bin/bash
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
DEST="${1:-$ROOT/build/submission}"
if [[ -e "$DEST" ]]; then
  printf '%s\n' "Staging directory already exists: $DEST. Choose a fresh directory." >&2
  exit 1
fi
for file in DentalExplain-macos-arm64.zip DentalExplain-windows-x64.zip DentalExplain-java-linux-x64.zip; do
  [[ -f "$ROOT/dist/$file" ]] || { printf '%s\n' "Missing verified distribution: $file" >&2; exit 1; }
done
for ext in docx pdf; do
  [[ -s "$ROOT/docs/report/DentalExplain Report.$ext" ]] || { printf '%s\n' "Missing report: $ext" >&2; exit 1; }
done
mkdir -p "$DEST/report" "$DEST/source/scripts" "$DEST/applications/"{macos,windows,linux}
cp "$ROOT/scripts/submission/"Open-* "$DEST/"
chmod +x "$DEST/Open-macOS.command" "$DEST/Open-Linux.sh"
cp "$ROOT/docs/report/DentalExplain Report."{docx,pdf} "$DEST/report/"
cp -R "$ROOT/src" "$ROOT/knowledge" "$DEST/source/"
for file in bootstrap.sh build.sh test.sh run.sh package.sh IconBuilder.java; do
  cp "$ROOT/scripts/$file" "$DEST/source/scripts/"
done
cp -R "$ROOT/scripts/distribution" "$DEST/source/scripts/"
cp "$ROOT/scripts/submission/source-README.md" "$DEST/source/README.md"
cp "$ROOT/scripts/submission/README.txt" "$DEST/README.txt"
unzip -q "$ROOT/dist/DentalExplain-macos-arm64.zip" -d "$DEST/applications/macos"
unzip -q "$ROOT/dist/DentalExplain-windows-x64.zip" -d "$DEST/applications/windows"
unzip -q "$ROOT/dist/DentalExplain-java-linux-x64.zip" -d "$DEST/applications/linux"
mv "$DEST/applications/linux/DentalExplain-java-linux-x64" "$DEST/applications/linux/DentalExplain"
# Hash regular files; ZIP -y preserves the symlinks and Unix executable modes.
(cd "$DEST" && find . -type f ! -name SHA256SUMS.txt ! -name .DS_Store ! -path '*/__MACOSX/*' -print0 | LC_ALL=C sort -z | xargs -0 shasum -a 256 > SHA256SUMS.txt)
ARCHIVE="$ROOT/dist/DentalExplain-submission.zip"
if [[ -e "$ARCHIVE" ]]; then
  printf '%s\n' 'Submission ZIP already exists; preserving it. Rename it before repackaging.' >&2
  exit 1
fi
(cd "$DEST" && zip -q -r -y "$ARCHIVE" . -x '*.DS_Store' '*/__MACOSX/*')
shasum -a 256 "$ARCHIVE" > "$ROOT/dist/DentalExplain-submission.sha256"
printf '%s\n' "$ARCHIVE"
