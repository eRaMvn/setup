eval "$(starship init zsh)"
alias terraform=/Users/thienphan/code/tf-instacart/isc-terraform
export TERRACART_COMMON_DEFAULTS_DIR=/Users/thienphan/code/terraform-common-defaults

export YVM_DIR=/Users/thienphan/.yvm
[ -r $YVM_DIR/yvm.sh ] && . $YVM_DIR/yvm.sh

export PATH="$HOME/.yarn/bin:$HOME/.config/yarn/global/node_modules/.bin:$PATH"
export PATH=$HOME/.pyenv/shims:$PATH
alias git-remove-untracked='git fetch --prune && git branch -r | awk "{print \$1}" | egrep -v -f /dev/fd/0 <(git branch -vv | grep origin) | awk "{print \$1}" | xargs git branch -D'
export PATH="/usr/local/opt/libpq/bin:$PATH"
alias python=/opt/homebrew/bin/python3
eval "$($BREW_PREFIX/bin/pyenv init -)"
