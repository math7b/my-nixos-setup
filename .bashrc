eval "$(starship init bash)"

eval "$(zoxide init bash)"

fastfetch

alias lsa='ls --all'
alias vim-fzf-preview-bat='vim "$(fzf --preview="bat {}")"'
alias fzf-preview-bat='fzf --preview="bat {}"'
