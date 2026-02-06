# Plan 002: Add Model Configuration

## Context

The `claude` command in the `commit-msg` hook runs without specifying a model. This plan adds `--model` support with a default of `sonnet`, configurable via an install-time config file (`config.conf`).

## Changes

### 1. Create `config.conf`
A shell-sourceable config file with:
```bash
MODEL=sonnet
```

### 2. Modify `commit-msg`
- Add `MODEL="__MODEL__"` placeholder near the top
- Pass `--model "$MODEL"` to the `claude` invocation

### 3. Modify `install.sh`
- Source `config.conf` from the script directory (with defaults if missing)
- Replace `cp` with `sed` substitution to bake `__MODEL__` into the installed hook
- Print the configured model in the install summary

### 4. Update `README.md`
- Add a "Configuration" section documenting `config.conf`
- Update project structure to reflect `plans/` directory

## Verification

1. Edit `config.conf`, set `MODEL=sonnet`, run `./install.sh`
2. Inspect `~/.config/git/hooks/commit-msg` — confirm `MODEL="sonnet"` and `--model "$MODEL"` in the claude line
3. Test with a real commit
