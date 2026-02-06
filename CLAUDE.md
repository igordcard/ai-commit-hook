# AI Commit Hook — Project Conventions

## Plans
- All plans live in `plans/` directory, named `PLAN-NNN.md` (zero-padded, sequential)
- To create a new plan, find the highest existing number and increment by 1

## Project Structure
- Shell-based project (bash scripts)
- Main files: `commit-msg` (hook), `install.sh` (installer), `config.conf` (install-time config)
- Config is install-time: values are baked into the hook via `sed` substitution during `install.sh`, not read at runtime
- Hook gets installed to `~/.config/git/hooks/commit-msg`
