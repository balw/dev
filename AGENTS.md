# AGENTS.md

Personal macOS dev-environment dotfiles. The repo lives at `~/dev` (`.zshrc` hardcodes `~/dev/zinit` for the zinit install).

## Layout

- `install-pkgs` — installs Homebrew if missing, then runs every executable file in `installs/`.
  - `./install-pkgs [--dry] [filter]` — `filter` is a grep pattern matched against script paths (e.g. `./install-pkgs tmux`).
- `installs/<tool>` — one small executable bash script per tool, usually a single `brew install` line.
- `update-configs` — copies configs from this repo onto the machine (`./update-configs [--dry]`):
  - `.config/.zshrc` → `~/.zshrc`
  - `.config/starship.toml` → `$XDG_CONFIG_HOME/starship.toml`
  - every directory in `.config/` → `$XDG_CONFIG_HOME/<dir>`, **replacing** the existing directory (`rm -rf` then `cp -r`)
- `.config/` — the configs themselves: zsh, starship, tmux, ghostty, aerospace.
- `zinit/` — zinit plugin manager clone, created by `.zshrc` on first shell start. Gitignored; don't edit.

## Conventions

- The repo is the source of truth. Edit files here and run `update-configs`; never edit `~/.config` directly.
- New tool: add `installs/<name>` with `#!/usr/bin/env bash` and `chmod +x` it, or `install-pkgs` will skip it.
- New config directory: put it in `.config/<name>/` and `update-configs` picks it up automatically. A single top-level file needs its own `copy_file` line.
- Scripts must work on a fresh machine (no `~/.config`, Homebrew not on `PATH` yet). Create directories before copying into them and quote every path.
- Keep shell scripts in bash and route side effects through `execute` so `--dry` stays accurate.
- Theme is Catppuccin Mocha everywhere (tmux, ghostty). Font is BlexMono Nerd Font.

## Checking changes

- `bash -n install-pkgs update-configs` for syntax.
- `./install-pkgs --dry` / `./update-configs --dry` to preview.
- To test `update-configs` without touching your real home: `HOME=$(mktemp -d) XDG_CONFIG_HOME= ./update-configs`
