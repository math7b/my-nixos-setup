# ~/.bashrc

eval "$(starship init bash)"
eval "$(zoxide init bash)"

alias fzfpreview='fzf --style full --preview="bat {}"'
alias vf='selected=$(fzf --style full --preview="bat {}") && [ -n "$selected" ] && vim "$selected"'
alias svf='selected=$(fzf --style full --preview="bat {}") && [ -n "$selected" ] && sudo vim "$selected"'
alias lsa='ls --all'

alias afas='fastfetch --kitty-icat ~/.config/fastfetch/a.png'

afas
