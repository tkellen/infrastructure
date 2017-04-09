# Use colors as variable names instead of escape codes.
autoload -U colors; colors # -U flag ignores aliases for functions added while loading

# Export colors for BSD.
export LSCOLORS="Gxfxcxdxbxegedabagacad"

# Export colors for Linux.
export LS_COLORS="di=36;:ln=35;40:so=32;40:pi=33;40:ex=31;40:bd=34;46:cd=34;43:su=0;41:sg=0;46:tw=0;42:ow=0;43:"

# Automatically color ls correctly for Linux and BSD.
ls --color -d . &>/dev/null 2>&1 && alias ls='ls --color=tty' || alias ls='ls -G'

# Make completions appear colored.
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}

# colorize less
export LESS="-fMnQRSPw%f line %lb"