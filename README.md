# dev

My macOS dev environment: install scripts and dotfiles.

## Setup on a new Mac

Clone into `~/dev` (the zsh config expects zinit at `~/dev/zinit`):

```sh
git clone git@github.com:balw/dev.git ~/dev
cd ~/dev
./install-pkgs
./update-configs
```

Run `install-pkgs` first so everything (including herdr) is installed before configs are copied. Then open a new terminal.

## Scripts

- `./install-pkgs` installs Homebrew if needed, then runs every script in `installs/` and `skills/vendor/`.
  - `./install-pkgs tmux` only runs scripts matching `tmux`.
- `./update-configs` copies the configs in this repo onto the machine.

Both take `--dry` to show what they would do without doing it.

## What's included

| Tool | Install | Config |
| --- | --- | --- |
| zsh + zinit | — | `.config/.zshrc` → `~/.zshrc` |
| Starship | `installs/starship` | `.config/starship.toml` |
| tmux | `installs/tmux` | `.config/tmux/` |
| Ghostty | `installs/ghostty` | `.config/ghostty/` |
| AeroSpace | `installs/aerospace` | `.config/aerospace/` |
| Claude Code | `installs/claude-code` | `claude/` → `~/.claude/` (see below) |
| opencode | `installs/opencode` | `opencode/` → `~/.config/opencode/` |
| herdr | `installs/herdr` | `herdr/config.toml` → `~/.config/herdr/config.toml` |
| rtk | `installs/rtk` | — (set up by `update-configs`) |
| Plannotator | `skills/vendor/plannotator` | — |
| fnm, Composer, Obsidian, Raycast, Nerd Font | `installs/*` | — |

## Making changes

Edit files in this repo, then run `./update-configs`. Don't edit the copies in `~/.config` directly — they get overwritten.

- **New tool:** add an executable script to `installs/` (`chmod +x`).
- **New config folder:** add it under `.config/` and it gets copied automatically.

`update-configs` replaces each folder in `~/.config` that has a matching folder in `.config/`, so anything not in the repo is lost.

## Agent instructions and subagents

`agents/AGENTS.md` holds my global instructions for coding agents. Claude Code and opencode both use it:

- opencode reads it directly as `~/.config/opencode/AGENTS.md`.
- Claude Code only reads `~/.claude/CLAUDE.md` globally, so `claude/CLAUDE.md` imports it with `@AGENTS.md` (plus `@RTK.md` for rtk).

(The `AGENTS.md` in the repo root is different: it describes this repo for agents working on it.)

Subagents live in `claude/agents/` and `opencode/agents/`. The two tools use different file formats, so each agent has a copy per tool with the same instructions. `verify` runs tests, builds and lint checks without editing code; Claude's copy uses Haiku 5.5.

## Claude Code and rtk

[rtk](https://github.com/rtk-ai/rtk) cuts the tokens Claude spends on Bash commands by rewriting them (e.g. `git status` → `rtk git status`) to return shorter output.

`update-configs` runs `rtk init -g --auto-patch`, which adds a hook to `~/.claude/settings.json` and writes `~/.claude/RTK.md` (referenced from `~/.claude/CLAUDE.md`). Restart Claude Code afterwards. `rtk gain` shows how many tokens it has saved.

It only affects Bash commands, not Claude's built-in Read, Grep and Glob tools.

opencode gets rtk's plugin (`rtk init -g --opencode`) and reads the same `RTK.md` through `instructions` in `opencode/opencode.json`.

## Claude Code skills

Skills live in `skills/`:

- `skills/custom/<name>/SKILL.md`: skills I've written. `update-configs` copies each folder to `~/.claude/skills/<name>`.
- `skills/vendor/<name>`: an install script for someone else's skill, usually their own installer. `install-pkgs` runs these. Rerun `./install-pkgs <name>` to update one.

`update-configs` only replaces skill folders that exist in `skills/custom/`, so vendor skills in `~/.claude/skills` are left alone. Don't give a custom skill the same name as a vendor one.

## Claude Code, opencode and herdr

`update-configs` copies `claude/settings.json` to `~/.claude/settings.json`, then runs `herdr integration install claude` and `herdr integration install opencode`. These let herdr track Claude and opencode sessions running in its panes.

The hook isn't stored in `claude/settings.json` because it contains a path specific to the machine. It's added back every time `update-configs` runs, along with rtk's hook, so your live `settings.json` will have more entries than the repo copy.

If you change a setting inside Claude Code (e.g. with `/config`), copy it into `claude/settings.json` too, or the next `update-configs` will undo it.
