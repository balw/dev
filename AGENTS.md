# AGENTS.md

Personal macOS dev-environment dotfiles. The repo lives at `~/dev` (`.zshrc` hardcodes `~/dev/zinit` for the zinit install).

## Layout

- `install-pkgs` — installs Homebrew if missing, then runs every executable file in `installs/` and `skills/vendor/`.
  - `./install-pkgs [--dry] [filter]` — `filter` is a grep pattern matched against script paths (e.g. `./install-pkgs tmux`).
- `installs/<tool>` — one small executable bash script per tool, usually a single `brew install` line.
- `update-configs` — copies configs from this repo onto the machine (`./update-configs [--dry]`):
  - `.config/.zshrc` → `~/.zshrc`
  - `.config/starship.toml` → `$XDG_CONFIG_HOME/starship.toml`
  - every directory in `.config/` → `$XDG_CONFIG_HOME/<dir>`, **replacing** the existing directory (`rm -rf` then `cp -r`)
  - `claude/settings.json` → `~/.claude/settings.json`
  - `claude/CLAUDE.md` → `~/.claude/CLAUDE.md`, `agents/AGENTS.md` → `~/.claude/AGENTS.md`, `claude/agents/*.md` → `~/.claude/agents/`
  - each folder in `skills/custom/` → `~/.claude/skills/<name>` (replaces that skill folder only)
  - `opencode/opencode.json`, `agents/AGENTS.md` and `opencode/agents/*.md` → `$XDG_CONFIG_HOME/opencode/`
  - `herdr/config.toml` → `$XDG_CONFIG_HOME/herdr/config.toml`, then `herdr integration install claude` and `opencode` (if herdr is installed)
  - `rtk init -g --auto-patch` and `rtk init -g --opencode --auto-patch` (if rtk is installed): adds rtk's Bash hook to `~/.claude/settings.json`, writes `~/.claude/RTK.md`, and installs rtk's opencode plugin
- `.config/` — the configs themselves: zsh, starship, tmux, ghostty, aerospace.
- `claude/` — Claude Code user config. Kept outside `.config/` because Claude Code reads `~/.claude`, and `update-configs` would otherwise copy it to `~/.config/claude`. Only copy specific files into `~/.claude` — never replace the whole directory, it holds sessions, history and credentials.
- `agents/AGENTS.md` — my **global** instructions for coding agents, shared by Claude Code and opencode. Not to be confused with this file, which only describes this repo. Keep it tool-neutral; tool-specific setup belongs in `claude/` or `opencode/`.
- `claude/CLAUDE.md` — just `@AGENTS.md` and `@RTK.md`. Claude Code only reads `~/.claude/CLAUDE.md` globally, so this imports the shared file. Keep the `@RTK.md` line.
- `claude/agents/`, `opencode/agents/` — subagents per tool (different frontmatter formats). Keep the instruction body of agents that exist in both identical.
- `opencode/` — opencode config. Only specific files are copied; `~/.config/opencode` also holds plugins and node_modules.
- `herdr/` — herdr (terminal agent multiplexer) config. Kept outside `.config/` because `~/.config/herdr` also holds sockets, logs and session snapshots that a directory replace would wipe.
- `skills/custom/` — my own Claude Code skills, one folder per skill with a `SKILL.md`.
- `skills/vendor/` — one executable script per third-party skill that runs its upstream installer (e.g. `plannotator`). Don't copy vendor skill files into the repo; they're owned and updated by their installer.
- `zinit/` — zinit plugin manager clone, created by `.zshrc` on first shell start. Gitignored; don't edit.

## Conventions

- The repo is the source of truth. Edit files here and run `update-configs`; never edit `~/.config` directly.
- Claude Code rewrites `~/.claude/settings.json` itself when settings change in-app (e.g. `/config`). Copy those changes back into `claude/settings.json` before running `update-configs`, or they get overwritten.
- New third-party skill: add an executable `skills/vendor/<name>` script. New custom skill: add `skills/custom/<name>/SKILL.md`. Keep names unique across both.
- New tool: add `installs/<name>` with `#!/usr/bin/env bash` and `chmod +x` it, or `install-pkgs` will skip it.
- New config directory: put it in `.config/<name>/` and `update-configs` picks it up automatically. A single top-level file needs its own `copy_file` line.
- Scripts must work on a fresh machine (no `~/.config`, Homebrew not on `PATH` yet). Create directories before copying into them and quote every path.
- Don't commit herdr's Claude hook to `claude/settings.json` — it contains an absolute path to `~/.claude/hooks/herdr-agent-state.sh` (a herdr-managed script). `update-configs` re-adds it via `herdr integration install claude`, which is idempotent.
- Same for rtk's hook: don't commit it to `claude/settings.json` or commit `RTK.md`; `rtk init -g --auto-patch` regenerates both and is idempotent.
- Run `install-pkgs` before `update-configs` on a new machine so herdr exists when the integration step runs.
- Keep shell scripts in bash and route side effects through `execute` so `--dry` stays accurate.
- Theme is Catppuccin Mocha everywhere (tmux, ghostty). Font is BlexMono Nerd Font.

## Checking changes

- `bash -n install-pkgs update-configs` for syntax.
- `./install-pkgs --dry` / `./update-configs --dry` to preview.
- To test `update-configs` without touching your real home: `HOME=$(mktemp -d) XDG_CONFIG_HOME= ./update-configs`
