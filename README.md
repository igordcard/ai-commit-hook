# AI Commit Hook

A global Git `commit-msg` hook that calls Claude Code to review every commit before it completes.

## What It Does

On every `git commit`, the hook:

1. Collects the staged diff, commit message, branch name, and file list
2. Sends them to Claude Code for a quick code review
3. Displays the review (summary, issues, suggestions)
4. Asks you to proceed or abort

## Prerequisites

- [Claude Code CLI](https://docs.anthropic.com/en/docs/claude-code) installed and authenticated

## Install

```bash
cd ~/ai-commit-hook
./install.sh
```

This will:
- Copy the hook to `~/.config/git/hooks/commit-msg`
- Set `git config --global core.hooksPath ~/.config/git/hooks`

## Bypass

Skip the review for a single commit:

```bash
git commit --no-verify
```

## Uninstall

```bash
git config --global --unset core.hooksPath
rm ~/.config/git/hooks/commit-msg
```

## How It Works

- Large diffs (>20,000 lines) are truncated to keep the review fast
- If Claude is unavailable, the commit proceeds without blocking
- If a local `.git/hooks/commit-msg` hook exists, it is chained after the review
- The prompt asks Claude to check for: message accuracy, bugs, security issues, and leftover debug code
