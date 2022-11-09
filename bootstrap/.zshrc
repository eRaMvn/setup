

### BEGIN--Instacart Shell Settings. (Updated: Tue May 18 13:03:30 PDT 2021. [Script Version 1.3.9])
# This Line Added Automatically by Instacart Setup Script
# The sourced file contains all of the instacart utilities and shell settings
# To remove this functionality, leave the block, and enter "NO-TOUCH" in the BEGIN line, and comment the line below:
eval "$(starship init zsh)"
source /Users/thienphan/.instacart_shell_profile
### END--Instacart Shell Settings.
alias terraform=/Users/thienphan/code/tf-instacart/isc-terraform
source "$(brew --prefix)/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/path.zsh.inc"
source "$(brew --prefix)/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/completion.zsh.inc"
export TERRACART_COMMON_DEFAULTS_DIR=/Users/thienphan/code/terraform-common-defaults

export YVM_DIR=/Users/thienphan/.yvm
[ -r $YVM_DIR/yvm.sh ] && . $YVM_DIR/yvm.sh

export PATH="$HOME/.yarn/bin:$HOME/.config/yarn/global/node_modules/.bin:$PATH"
alias git-remove-untracked='git fetch --prune && git branch -r | awk "{print \$1}" | egrep -v -f /dev/fd/0 <(git branch -vv | grep origin) | awk "{print \$1}" | xargs git branch -D'
source ~/.bash_profile
export PATH="/usr/local/opt/libpq/bin:$PATH"
