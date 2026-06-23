if [ -x /opt/homebrew/bin/brew ]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
elif [ -x /usr/local/bin/brew ]; then
  eval "$(/usr/local/bin/brew shellenv)"
elif [ -x /home/linuxbrew/.linuxbrew/bin/brew ]; then
  eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
fi

if command -v starship >/dev/null 2>&1; then
  eval "$(starship init zsh)"
fi

alias git-remove-untracked='git fetch --prune && git branch -r | awk "{print \$1}" | egrep -v -f /dev/fd/0 <(git branch -vv | grep origin) | awk "{print \$1}" | xargs git branch -D'
if [ -d /usr/local/opt/libpq/bin ]; then
  export PATH="/usr/local/opt/libpq/bin:$PATH"
fi
alias readsecret='read -r -s'

if [ "$(uname -s)" = "Linux" ]; then
  if command -v xsel >/dev/null 2>&1; then
    alias pbcopy='xsel --input --clipboard'
    alias pbpaste='xsel --output --clipboard'
  elif command -v xclip >/dev/null 2>&1; then
    alias pbcopy='xclip -selection clipboard'
    alias pbpaste='xclip -selection clipboard -o'
  elif command -v wl-copy >/dev/null 2>&1 && command -v wl-paste >/dev/null 2>&1; then
    alias pbcopy='wl-copy'
    alias pbpaste='wl-paste'
  fi
fi

# kubectl aliases
[ -f ~/.kubectl_aliases ] && source ~/.kubectl_aliases
