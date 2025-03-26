autoload -U compinit
compinit -C
brew_prefix=$(brew --prefix)

function check_and_eval() {
  local cmd="$1" eval_str="$2"
  if command -v "$cmd" >/dev/null 2>&1; then
    eval "$eval_str"
  fi
}

function check_and_source() {
  local file="$1"
  [ -f "$file" ] && source "$file"
}

function wrap_command() {
  local cmd="$1" new_cmd="$2" args="$3"
  if command -v "$cmd" >/dev/null 2>&1; then
    eval "$new_cmd() { [ -t 1 ] && command $cmd $args \"\$@\" || command $new_cmd \"\$@\"; }"
  fi
}

wrap_command "bat" "cat" "--plain --paging=never"
wrap_command "delta" "diff" "--side-by-side"
wrap_command "eza" "ls" "--all"

check_and_source "$brew_prefix/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
check_and_source "$brew_prefix/share/zsh-autosuggestions/zsh-autosuggestions.zsh"
check_and_source "$HOME/.atuin/bin/env"
check_and_eval "atuin" "$(atuin init zsh)"
check_and_eval "starship" "$(starship init zsh)"
check_and_eval "zoxide" "$(zoxide init zsh)"

[ -d "$brew_prefix/bin/eza/completions/zsh" ] && export FPATH="$brew_prefix/bin/eza/completions/zsh:$FPATH"

scan() {
  magick -density 300 "$@" -monochrome +noise Gaussian -attenuate 0.1 -rotate 0.5 scan-output.pdf
}
