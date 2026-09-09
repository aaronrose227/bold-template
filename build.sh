#!/usr/bin/env bash
# Build a document. Pass its name, or nothing for all.
#   ./build.sh            every document
#   ./build.sh state      that document only
# A document is either name.tex at the top or name/name.tex in a folder.
set -euo pipefail
cd "$(dirname "$0")"

names=${1:-"template state"}

for name in $names; do
  if   [ -f "$name.tex" ];       then doc="$name"
  elif [ -f "$name/$name.tex" ]; then doc="$name/$name"
  else echo "no such document, $name" >&2; exit 1
  fi
  out=$(dirname "$doc")

  if command -v latexmk >/dev/null 2>&1; then
    latexmk -pdf -interaction=nonstopmode -outdir="$out" "$doc.tex"
    latexmk -c -outdir="$out" "$doc.tex" >/dev/null
  elif command -v tectonic >/dev/null 2>&1; then
    tectonic -X compile -Z search-path=. "$doc.tex" --outdir "$out"
  else
    echo "install latexmk or tectonic" >&2
    exit 1
  fi
  echo "built $doc.pdf"
done
