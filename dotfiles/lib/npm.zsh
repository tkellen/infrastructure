# Inter-link all projects, where each project exists in a subdirectory of
# the current parent directory. Uses https://github.com/cowboy/node-linken
alias npm_linkall='eachdir "rm -rf node_modules; npm install"; linken */ --src .'
alias npm_link='rm -rf node_modules; npm install; linken . --src ..'

# Print npm owners in subdirectories.
alias npm_owner_list='eachdir "npm owner ls 2>/dev/null | sort"'

# Add npm owners to projects in subdirectories.
function npm_owner_add() {
  local users=
  local root="$(basename $(pwd))"
  [[ $root == "gruntjs" ]] && users="cowboy tkellen"
  if [[ -n "$users" ]]; then
    eachdir "__npm_owner_add_each $users"
  fi
}

function __npm_owner_add_each() {
  local owners
  owners="$(npm owner ls 2>/dev/null)"
  [[ $? != 0 ]] && return
  for user in $*; do
    echo $owners | grep -v $user >/dev/null && npm owner add $user
  done
}
