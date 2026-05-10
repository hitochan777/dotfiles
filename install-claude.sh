#!/bin/bash
set -e

DOTFILES_DIR="$(cd "$(dirname "$0")" && pwd)"
CLAUDE_DIR="$HOME/.claude"

mkdir -p "$CLAUDE_DIR"

create_link() {
  local src="$1"
  local dest="$2"
  local name="$(basename "$dest")"

  if [ -L "$dest" ] && [ "$(readlink "$dest")" = "$src" ]; then
    echo "  skip: $name (already linked)"
    return
  fi

  if [ -e "$dest" ] || [ -L "$dest" ]; then
    echo "  backup: $name -> ${name}.backup"
    mv "$dest" "$dest.backup"
  fi

  ln -sf "$src" "$dest"
  echo "  linked: $name"
}

echo ""
echo "=== Claude Code dotfiles setup ==="
echo ""

for item in CLAUDE.md settings.json commands skills agents; do
  if [ -e "$DOTFILES_DIR/.claude/$item" ]; then
    create_link "$DOTFILES_DIR/.claude/$item" "$CLAUDE_DIR/$item"
  fi
done

# Install plugins
if [ -f "$DOTFILES_DIR/.claude/plugins.txt" ]; then
  echo "Installing plugins..."
  while IFS= read -r plugin || [ -n "$plugin" ]; do
    [ -z "$plugin" ] && continue
    claude plugin install "$plugin" 2>/dev/null && echo "  installed: $plugin" || echo "  skip: $plugin (already installed or failed)"
  done < "$DOTFILES_DIR/.claude/plugins.txt"
fi

echo ""
echo "=== Done! ==="
echo ""
echo "Current ~/.claude/ symlinks:"
ls -la "$CLAUDE_DIR" | grep -- "->"
