#!/usr/bin/env bash
set -euo pipefail

script_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
target_home="${HOME}"
git_name="Thien Phan"
git_email=""
claude_cask="${CLAUDE_CASK:-claude@latest}"
os="$(uname -s)"

usage() {
  cat <<'EOF'
Usage:
  setup.sh --git-email EMAIL [--git-name NAME] [--home-dir PATH]
  setup.sh --git-email EMAIL [--git-name NAME] --user USERNAME

Options:
  --git-email EMAIL   Git email to write into ~/.gitconfig.
  --git-name NAME     Git name to write into ~/.gitconfig. Defaults to "Thien Phan".
  --home-dir PATH     Home directory where dotfiles should be installed. Defaults to $HOME.
  --user USERNAME     Convenience wrapper for --home-dir /Users/USERNAME on macOS
                      and /home/USERNAME elsewhere.
  --help              Show this help.

Environment:
  CLAUDE_CASK         Homebrew cask to try for Claude Code. Defaults to claude@latest,
                      with fallback to claude-code@latest when unavailable.
EOF
}

die() {
  echo "setup.sh: $*" >&2
  exit 1
}

home_for_user() {
  local username="$1"

  case "$os" in
    Darwin) printf '/Users/%s\n' "$username" ;;
    *) printf '/home/%s\n' "$username" ;;
  esac
}

while (($#)); do
  case "$1" in
    --git-email|--email)
      [[ $# -ge 2 ]] || die "$1 requires a value"
      git_email="$2"
      shift 2
      ;;
    --git-name|--name)
      [[ $# -ge 2 ]] || die "$1 requires a value"
      git_name="$2"
      shift 2
      ;;
    --home-dir|--home)
      [[ $# -ge 2 ]] || die "$1 requires a value"
      target_home="${2%/}"
      shift 2
      ;;
    --user|--username)
      [[ $# -ge 2 ]] || die "$1 requires a value"
      target_home="$(home_for_user "$2")"
      shift 2
      ;;
    --help|-h)
      usage
      exit 0
      ;;
    *)
      die "unknown argument: $1"
      ;;
  esac
done

[[ -n "$git_email" ]] || die "--git-email is required"
[[ -d "$target_home" ]] || die "home directory does not exist: $target_home"

install_homebrew() {
  if command -v brew >/dev/null 2>&1; then
    return
  fi

  echo "Installing Homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
}

load_homebrew() {
  local brew_bin=""

  if command -v brew >/dev/null 2>&1; then
    brew_bin="$(command -v brew)"
  elif [[ -x /opt/homebrew/bin/brew ]]; then
    brew_bin="/opt/homebrew/bin/brew"
  elif [[ -x /usr/local/bin/brew ]]; then
    brew_bin="/usr/local/bin/brew"
  elif [[ -x /home/linuxbrew/.linuxbrew/bin/brew ]]; then
    brew_bin="/home/linuxbrew/.linuxbrew/bin/brew"
  fi

  [[ -n "$brew_bin" ]] || die "Homebrew installed, but brew was not found"
  eval "$("$brew_bin" shellenv)"
}

install_formulae() {
  brew install \
    fd \
    gh \
    git \
    jq \
    node \
    python \
    ripgrep \
    starship \
    tmux \
    uv \
    yq
}

install_tmux_plugin_manager() {
  local tpm_dir="$target_home/.tmux/plugins/tpm"

  if [[ -d "$tpm_dir/.git" ]]; then
    echo "tmux plugin manager is already installed."
    return
  fi

  if [[ -e "$tpm_dir" ]]; then
    echo "TPM path already exists, skipping clone: $tpm_dir"
    return
  fi

  mkdir -p "$target_home/.tmux/plugins"
  git clone https://github.com/tmux-plugins/tpm "$tpm_dir"
}

install_kubectl_aliases() {
  local aliases_file="$target_home/.kubectl_aliases"

  if [[ -f "$aliases_file" ]]; then
    echo "kubectl aliases are already installed."
    return
  fi

  if ! curl -fsSL https://raw.githubusercontent.com/ahmetb/kubectl-aliases/master/.kubectl_aliases -o "$aliases_file"; then
    echo "Warning: failed to install kubectl aliases." >&2
  fi
}

install_cask() {
  local cask="$1"

  if brew list --cask "$cask" >/dev/null 2>&1; then
    echo "$cask is already installed."
    return
  fi

  brew install --cask "$cask"
}

install_claude_code() {
  if install_cask "$claude_cask"; then
    return
  fi

  if [[ "$claude_cask" != "claude-code@latest" ]]; then
    echo "Falling back to claude-code@latest."
    install_cask "claude-code@latest"
    return
  fi

  return 1
}

install_casks() {
  if [[ "$os" != "Darwin" ]]; then
    echo "Skipping macOS-only casks on $os."
    return
  fi

  install_cask "codex"
  install_claude_code
  install_cask "font-jetbrains-mono-nerd-font"
}

install_dotfiles() {
  mkdir -p "$target_home/.config"

  cp "$script_dir/.gitconfig" "$target_home/.gitconfig"
  cp "$script_dir/.tmux.conf" "$target_home/.tmux.conf"
  cp "$script_dir/.zshrc" "$target_home/.zshrc"
  cp "$script_dir/starship.toml" "$target_home/.config/starship.toml"

  HOME="$target_home" git config --global core.hooksPath "$target_home/.git/hooks"
  HOME="$target_home" git config --global user.name "$git_name"
  HOME="$target_home" git config --global user.email "$git_email"

  if [[ -f "$script_dir/ghostty_config" ]]; then
    if [[ "$os" == "Darwin" ]]; then
      ghostty_dir="$target_home/Library/Application Support/com.mitchellh.ghostty"
    else
      ghostty_dir="$target_home/.config/ghostty"
    fi
    mkdir -p "$ghostty_dir"
    cp "$script_dir/ghostty_config" "$ghostty_dir/config"
  fi
}

install_homebrew
load_homebrew
install_formulae
install_casks
install_tmux_plugin_manager
install_kubectl_aliases
install_dotfiles

echo "Setup complete for $target_home."
