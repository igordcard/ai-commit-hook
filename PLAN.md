# Global `commit-msg` Hook with Claude Code Review

## Overview

Create a global Git `commit-msg` hook that automatically calls Claude Code to review every commit across all local repos. All project files live in `~/ai-commit-hook` (a dedicated Git repo). Installation into the system is a separate manual step.

## Project Structure (`~/ai-commit-hook/`)

```
ai-commit-hook/
  commit-msg              # The hook script
  install.sh              # Installation helper (sets core.hooksPath, copies hook)
  README.md               # Documentation
  PLAN.md                 # This plan
```

## Implementation Steps

### Step 1: Create the repo `~/ai-commit-hook`

Initialize a new Git repo.

### Step 2: Write `commit-msg` hook script

The script will:

1. **Gather context:**
   - Staged diff: `git diff --cached`
   - Commit message: read from `$1` (the message file Git passes)
   - Branch name: `git branch --show-current`
   - Staged file list: `git diff --cached --name-status`
   - Repo name: basename of the repo root

2. **Guard against huge diffs:** If the diff exceeds ~20,000 lines, truncate with a warning.

3. **Call Claude Code:**
   ```bash
   claude -p "$PROMPT" --output-format text --max-turns 1 --no-input
   ```
   - `--max-turns 1`: no agentic looping, just analysis
   - `--no-input`: don't read stdin

4. **Display the report.**

5. **Prompt the user** to continue or abort:
   - Read from `/dev/tty`
   - Default = continue (Enter = proceed)
   - `n` or `a` = abort (exit 1)

6. **Chain to local repo hooks** if `.git/hooks/commit-msg` exists.

### Step 3: Write `install.sh`

A helper script that:
- Creates `~/.config/git/hooks/`
- Copies `commit-msg` there
- Runs `git config --global core.hooksPath ~/.config/git/hooks`
- Warns about per-repo hooks being superseded

### Step 4: Write `README.md`

Documents: what it does, how to install, how to bypass (`--no-verify`), how to uninstall.

### Step 5: Write `PLAN.md`

Save this plan as a file in the repo.

### Step 6: Git commit all files

Commit everything in the `~/ai-commit-hook` repo.

## The Prompt Sent to Claude

```
You are a senior code reviewer. Analyze this Git commit and provide a SHORT report (max 10 lines).

Repository: <repo_name>
Branch: <branch>

== Commit Message ==
<message>

== Files Changed ==
<file_list>

== Diff ==
<diff>

Review checklist:
- Does the commit message accurately describe the changes?
- Any obvious bugs, logic errors, or typos in the code?
- Any security concerns (secrets, injection, unsafe operations)?
- Any leftover debug code (console.log, print, TODO)?

Format:
SUMMARY: One-line overall assessment
ISSUES: Bulleted list of concerns (or "None found")
SUGGESTIONS: Bulleted list of optional improvements (or "Looks good")
```

## Bypass

```
git commit --no-verify
```

## Verification (manual, after install)

1. Go to any Git repo, stage a change, commit
2. Observe Claude's review before the commit completes
3. Test aborting (type `n`) and continuing (Enter)
4. Test `--no-verify` to bypass
5. Test with a repo that has a local `commit-msg` hook
