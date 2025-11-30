# ~/.bashrc

eval "$(starship init bash)"
eval "$(zoxide init bash)"

alias fzf='fzf --style full --preview="bat {}"'
alias nvf='selected=$(fzf --style full --preview="bat {}") && [ -n "$selected" ] && nvim "$selected"'
alias snvf='selected=$(fzf --style full --preview="bat {}") && [ -n "$selected" ] && sudo nvim "$selected"'

alias lsa='ls --all'

alias arise='uwsm start hyprland'

alias dfas='clear; fastfetch --kitty-icat ~/.config/fastfetch/nyarch.png'

alias zen='exec ./zen/zen'

dfas

export N_PREFIX="$HOME/n"; [[ :$PATH: == *":$N_PREFIX/bin:"* ]] || PATH+=":$N_PREFIX/bin"  # Added by n-install (see http://git.io/n-install-repo).


# fnm
FNM_PATH="/home/mathy/.local/share/fnm"
if [ -d "$FNM_PATH" ]; then
  export PATH="$FNM_PATH:$PATH"
  eval "`fnm env`"
fi
