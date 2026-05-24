#!/bin/bash
# Symlink agent config into each AI coding tool's config directory.
# Add new tools here as needed (codex, opencode, etc.)

AGENTS_DIR="$XDG_CONFIG_HOME/agents"

# Claude Code: ~/.claude/
mkdir -p "$HOME/.claude"
ln -sf "$AGENTS_DIR/AGENTS.md" "$HOME/.claude/CLAUDE.md"
ln -sfn "$AGENTS_DIR/skills" "$HOME/.claude/skills"
