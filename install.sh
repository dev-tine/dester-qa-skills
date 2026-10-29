#!/usr/bin/env bash
# dester suite installer: copies shared rules into each skill, then symlinks skills into ~/.claude/skills/
# Usage: ./install.sh [--copy] [--uninstall]
#   --copy   copy the skills instead of symlinking (use on Windows Git Bash, or to detach from this folder)
set -euo pipefail
ROOT="$(cd "$(dirname "$0")" && pwd)"
DEST="${CLAUDE_SKILLS_DIR:-$HOME/.claude/skills}"

MODE="link"
case "${1:-}" in
  --uninstall)
    for d in "$ROOT"/skills/dester-*/; do
      n="$(basename "$d")"
      if [[ -L "$DEST/$n" ]]; then rm "$DEST/$n" && echo "removed $n"
      elif [[ -f "$DEST/$n/.dester-copy" ]]; then rm -rf "$DEST/$n" && echo "removed $n (copy)"
      fi
    done
    exit 0 ;;
  --copy) MODE="copy" ;;
  "") ;;
  *) echo "Unknown option: $1 (use --copy or --uninstall)"; exit 1 ;;
esac

mkdir -p "$DEST"
for d in "$ROOT"/skills/dester-*/; do
  n="$(basename "$d")"
  mkdir -p "$d/references"
  cp "$ROOT/shared/core-rules.md" "$d/references/core-rules.md"
  cp "$ROOT/shared/glossary.md" "$d/references/glossary.md"
  if [[ -e "$DEST/$n" && ! -L "$DEST/$n" && ! -f "$DEST/$n/.dester-copy" ]]; then
    echo "SKIP $n: $DEST/$n exists and was not installed by this script"
    continue
  fi
  if [[ "$MODE" == "copy" ]]; then
    rm -rf "$DEST/$n"
    cp -R "${d%/}" "$DEST/$n"
    touch "$DEST/$n/.dester-copy"
    echo "copied $n -> $DEST/$n"
  else
    rm -rf "$DEST/$n" 2>/dev/null || true
    ln -sfn "${d%/}" "$DEST/$n"
    echo "linked $n -> $DEST/$n"
  fi
done
echo "Done. Open a new Claude Code session and type /dester-explore"
