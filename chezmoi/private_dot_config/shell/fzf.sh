# fzf options: layout, preview, colors. Sourced by zshrc/bashrc when fzf is present.
export FZF_DEFAULT_OPTS="--height 40% --layout=reverse --border --inline-info"
export FZF_CTRL_T_OPTS="--preview 'bat --theme Dracula --style numbers --color always {} 2>/dev/null || cat {}'"
export FZF_CTRL_R_OPTS="--preview 'echo {}' --preview-window down:3:hidden"
export FZF_ALT_C_OPTS="--preview 'tree -L 2 -C {} 2>/dev/null || ls -la {}'"
export FZF_DEFAULT_COMMAND="fd --type f --hidden --follow --exclude .git 2>/dev/null || find . -path '*/\.*' -prune -o -type f -print 2>/dev/null"
