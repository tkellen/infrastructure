alias _='sudo '
alias mem='ps -eo pmem,pcpu,rss,vsize,args | sort -k 1 -r | less'

# global alias
alias -g G='grep'

# View command history.
alias history='fc -l 1'

# Don't confuse zsh's globbing with rake arguments
alias rake='noglob rake'

alias dosnuke="find . -name \"*\" -type f -exec dos2unix {} \;"

# Nuke .DS_Store files recursively.
alias dsnuke="find . -name '*.DS_Store' -type f -ls -delete"

# get public key
alias pkey="pbcopy < ~/.ssh/id_rsa.pub"

alias a="atom"
