eval "$(starship init zsh)"

alias git-remove-untracked='git fetch --prune && git branch -r | awk "{print \$1}" | egrep -v -f /dev/fd/0 <(git branch -vv | grep origin) | awk "{print \$1}" | xargs git branch -D'
export PATH="/usr/local/opt/libpq/bin:$PATH"
alias readsecret='read -r -s'
alias pbcopy='xsel --input clipboard'
alias pbpaste='xsel --output clipboard'

# kubectl aliases
if [ ! -f ~/.kubectl_aliases ]; then
  curl -fsSL https://raw.githubusercontent.com/ahmetb/kubectl-aliases/master/.kubectl_aliases -o ~/.kubectl_aliases
fi
[ -f ~/.kubectl_aliases ] && source ~/.kubectl_aliases
