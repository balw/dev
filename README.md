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

- `./install-pkgs` installs Homebrew if needed, then runs every script in `installs/`.
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
| Claude Code | `installs/claude-code` | `claude/settings.json` → `~/.claude/settings.json` |
| herdr | `installs/herdr` | `herdr/config.toml` → `~/.config/herdr/config.toml` |
| fnm, Composer, Obsidian, Raycast, Nerd Font | `installs/*` | — |

## Making changes

Edit files in this repo, then run `./update-configs`. Don't edit the copies in `~/.config` directly — they get overwritten.

- **New tool:** add an executable script to `installs/` (`chmod +x`).
- **New config folder:** add it under `.config/` and it gets copied automatically.

`update-configs` replaces each folder in `~/.config` that has a matching folder in `.config/`, so anything not in the repo is lost.

## Claude Code and herdr

`update-configs` copies `claude/settings.json` to `~/.claude/settings.json`, then runs `herdr integration install claude`. That adds a hook so herdr can track Claude sessions running in its panes.

The hook isn't stored in `claude/settings.json` because it contains a path specific to the machine. It's added back every time `update-configs` runs, so your live `settings.json` will have one more entry than the repo copy.

If you change a setting inside Claude Code (e.g. with `/config`), copy it into `claude/settings.json` too, or the next `update-configs` will undo it.
