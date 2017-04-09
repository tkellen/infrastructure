# Git shortcuts.
alias gs='git status'
alias gd='git diff'
alias ga='git add'
alias gA='git add -A'
alias gcm='git commit -m'
alias gca='git commit --amend'
alias gpo='git push origin'
alias gpu='git push upstream'
alias gpom='git push origin master'
alias gprom='git pull --rebase origin master'
alias gitback='git reset --hard HEAD~'
alias gp='git pull --rebase'
alias gski='git stash --keep-index'
alias gco='git checkout'
function pr() {
  git fetch -fu origin refs/pull/$1/head:pr/$1
  gco pr/$1
}
