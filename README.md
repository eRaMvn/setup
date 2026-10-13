# Setup

Personal machine bootstrap files and scripts.

## Bootstrap a Machine

From the repository root:

```bash
./bootstrap/setup.sh --git-email thien.phan@instacart.com --user thienphan
```

Use `--user` when the target home directory follows the system default:

- macOS: `/Users/USERNAME`
- Linux: `/home/USERNAME`

Use `--home-dir` when the target path is different:

```bash
./bootstrap/setup.sh --git-email thien.phan@instacart.com --home-dir /Users/someone
```

Override the Git name when needed:

```bash
./bootstrap/setup.sh \
  --git-name "Thien Phan" \
  --git-email thien.phan@instacart.com \
  --user thienphan
```

## What It Installs

The bootstrap script installs Homebrew when `brew` is missing, then installs tools through Homebrew.

Formulae:

- `fd`
- `gh`
- `git`
- `jq`
- `node`
- `python`
- `ripgrep`
- `starship`
- `tmux`
- `uv`
- `yq`

macOS casks:

- `codex`
- `claude@latest`, with fallback to `claude-code@latest`
- `font-jetbrains-mono-nerd-font`

To force a different Claude Code cask:

```bash
CLAUDE_CASK=claude-code@latest ./bootstrap/setup.sh --git-email thien.phan@instacart.com --user thienphan
```

## What It Writes

The script copies these files into the target home directory:

- `bootstrap/.gitconfig` to `~/.gitconfig`
- `bootstrap/.tmux.conf` to `~/.tmux.conf`
- `bootstrap/.zshrc` to `~/.zshrc`
- `bootstrap/starship.toml` to `~/.config/starship.toml`
- `bootstrap/ghostty_config` to the Ghostty config path when present

It also installs the tmux plugin manager under `~/.tmux/plugins/tpm` and downloads kubectl aliases to `~/.kubectl_aliases` when those files are missing.

After copying `.gitconfig`, it updates:

- `user.name`
- `user.email`
- `core.hooksPath`

Run the built-in help for the full argument list:

```bash
./bootstrap/setup.sh --help
```

## tmux

The tmux config uses TPM with these plugins: `tmux-sensible`, `tmux-yank`, `tmux-resurrect`, `tmux-logging`, and `tmux-continuum`.

The prefix is the default `Ctrl-b`.

### Install or update plugins

After the first bootstrap, install the plugins from inside tmux with `prefix + I`, or from a shell:

```bash
~/.tmux/plugins/tpm/bin/install_plugins
```

Update them with `prefix + U`. Reload the config after editing it:

```bash
tmux source-file ~/.tmux.conf
```

### Mouse and copy

- Mouse wheel scrolls back through history.
- Drag to select; releasing the button copies to the system clipboard.
- Keyboard: `prefix + [` enters copy mode, `v` starts a selection, `y` copies it.
- In iTerm2, hold `Option` while dragging to use native selection instead of tmux's.

### Session persistence

tmux-continuum saves every 15 minutes and restores the last save when the tmux server starts, so sessions come back after a reboot or OS upgrade. Restored: sessions, windows, pane layouts, working directories, pane contents, and simple programs such as `vim` and `less`. Not restored: running processes and shell state.

- `prefix + Ctrl-s`: save now (do this before a planned reboot).
- `prefix + Ctrl-r`: restore the last save manually.

Saves live in `~/.local/share/tmux/resurrect/`. The `last` symlink points at the save that will be restored.

To test a restore without rebooting, save, then restart the server. This kills every running session:

```bash
tmux run-shell ~/.tmux/plugins/tmux-resurrect/scripts/save.sh
tmux kill-server
tmux   # continuum restores the last save on server start
```

Automatic restore is skipped when another tmux server is already running, such as one started with `-L`. Use `prefix + Ctrl-r` in that case.
