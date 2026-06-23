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
