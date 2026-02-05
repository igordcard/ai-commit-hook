#!/usr/bin/env bash
#
# Install the Claude Code commit-msg hook globally.
#
set -euo pipefail

HOOKS_DIR="$HOME/.config/git/hooks"
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
HOOK_SRC="${SCRIPT_DIR}/commit-msg"

echo "Installing Claude Code commit-msg hook..."

# Verify the hook source exists
if [ ! -f "$HOOK_SRC" ]; then
    echo "ERROR: commit-msg not found at ${HOOK_SRC}" >&2
    exit 1
fi

# Verify claude is available
if ! command -v claude &>/dev/null; then
    echo "WARNING: 'claude' command not found in PATH."
    echo "         The hook requires Claude Code CLI to be installed."
    echo "         Install it from: https://docs.anthropic.com/en/docs/claude-code"
    echo ""
fi

# Create the global hooks directory
mkdir -p "$HOOKS_DIR"

# Copy the hook
cp "$HOOK_SRC" "${HOOKS_DIR}/commit-msg"
chmod +x "${HOOKS_DIR}/commit-msg"

# Set git global hooks path
git config --global core.hooksPath "$HOOKS_DIR"

echo ""
echo "Done! Installed to: ${HOOKS_DIR}/commit-msg"
echo "Global core.hooksPath set to: ${HOOKS_DIR}"
echo ""
echo "NOTE: Per-repo hooks in .git/hooks/ are now superseded by the"
echo "      global hooks path. The commit-msg hook will chain to any"
echo "      local .git/hooks/commit-msg if it exists and is executable."
echo ""
echo "To bypass the review on a single commit:"
echo "  git commit --no-verify"
echo ""
echo "To uninstall:"
echo "  git config --global --unset core.hooksPath"
echo "  rm ${HOOKS_DIR}/commit-msg"
