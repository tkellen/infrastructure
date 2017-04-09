setopt auto_cd # Change directory by typing a directory name on its own.
setopt cdablevars # Allow cd with to variable names
setopt extended_glob # Turn on the more powerful pattern matching features.

# Turn on completions
autoload -U compinit; compinit # -U flag ignores aliases for functions added while loading
