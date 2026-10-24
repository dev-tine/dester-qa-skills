#!/usr/bin/env bash
# dester suite installer: copies shared rules into each skill, then symlinks skills into ~/.claude/skills/
# Usage: ./install.sh [--uninstall]
set -euo pipefail
ROOT="$(cd "$(dirname "$0")" && pwd)"
DEST="${CLAUDE_SKILLS_DIR:-$HOME/.claude/skills}"

if [[ "${1:-}" == "--uninstall" ]]; then
  for d in "$ROOT"/skills/dester-*/; do
    n="$(basename "$d")"
    [[ -L "$DEST/$n" ]] && rm "$DEST/$n" && echo "removed $n"
  done
  exit 0
fi

mkdir -p "$DEST"
for d in "$ROOT"/skills/dester-*/; do
  n="$(basename "$d")"
  mkdir -p "$d/references"
  cp "$ROOT/shared/core-rules.md" "$d/references/core-rules.md"
  cp "$ROOT/shared/glossary.md" "$d/references/glossary.md"
  if [[ -e "$DEST/$n" && ! -L "$DEST/$n" ]]; then
    echo "SKIP $n: $DEST/$n exists and is not a symlink"
    continue
  fi
  ln -sfn "${d%/}" "$DEST/$n"
  echo "installed $n -> $DEST/$n"
done
echo "Done. Open a new Claude Code session and type /dester-explore"
