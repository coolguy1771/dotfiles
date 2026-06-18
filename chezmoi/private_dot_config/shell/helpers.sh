# Shared aliases and functions for bash and zsh

# Prefer neovim for vim when present
[ -x "$(command -v nvim)" ] && alias vim="nvim" vimdiff="nvim -d"

# mbsync config when set
[ -n "${MBSYNCRC:-}" ] && [ -f "$MBSYNCRC" ] && alias mbsync='mbsync -c $MBSYNCRC'

# Edit a script from ~/.local/bin with fzf
se() {
  [ ! -d "$HOME/.local/bin" ] && return 1
  choice="$(find "$HOME/.local/bin" -mindepth 1 -maxdepth 1 2>/dev/null | while IFS= read -r p; do basename "$p"; done | fzf)"
  [ -n "$choice" ] && [ -f "$HOME/.local/bin/$choice" ] && ${EDITOR:-vim} "$HOME/.local/bin/$choice"
}

# Verbosity and safe defaults
alias \
  cp="cp -iv" \
  mv="mv -iv" \
  rm="rm -vi" \
  bc="bc -ql" \
  rsync="rsync -vrPlu" \
  mkd="mkdir -pv" \
  ffmpeg="ffmpeg -hide_banner"

# Colorize (GNU coreutils; only on Linux to avoid breaking macOS)
if [ "$(uname)" = "Linux" ]; then
  alias \
    ls="ls -hN --color=auto --group-directories-first" \
    grep="grep --color=auto" \
    diff="diff --color=auto" \
    ccat="highlight --out-format=ansi" \
    ip="ip -color=auto" \
    rm="rm -vI"
fi

alias gs='git status'
alias gp='git push'
alias gl='git pull'

gc() { git commit -m "$*"; }

mkcd() { mkdir -p "$1" && cd "$1"; }

extract() {
    if [ -f "$1" ]; then
        case "$1" in
            *.tar.gz|*.tgz) tar xvzf "$1" ;;
            *.tar.bz2|*.tbz2) tar xvjf "$1" ;;
            *.tar.xz|*.txz) tar xvJf "$1" ;;
            *.tar) tar xvf "$1" ;;
            *.zip) unzip "$1" ;;
            *.rar) unrar x "$1" ;;
            *.7z) 7z x "$1" ;;
            *) echo "Unsupported file format" ;;
        esac
    else
        echo "File not found: $1"
    fi
}

# kubectl shorthand: use kubecolor if available
k() {
    if command -v kubecolor &>/dev/null; then
        kubecolor "$@"
    else
        kubectl "$@"
    fi
}

# ls: use lsd if available
if command -v lsd &>/dev/null; then
    alias ls='lsd'
fi

# cat: use bat if available (set in rc files as function to pass args)

# thefuck alias
if command -v thefuck &>/dev/null; then
    alias f='fuck'
fi

# mkpass: generate random alphanumeric password; length defaults to 24 chars
mkpass() {
    local len="${1:-24}"
    LC_ALL=C tr -dc 'A-Za-z0-9!@#$%^&*' </dev/urandom | head -c "$len"
    echo
}

# commit: conventional commits
# commit feat terraform update lock => feat(terraform): update lock
# commit feat! terraform update lock => feat(terraform)!: update lock
# commit chore^ update README => chore: update README
# commit fix!^ rename README => fix!: rename README
commit() {
    local commit_message
    if [ $# -gt 0 ]; then
        local commit_type="$1"
        shift
        if case "$commit_type" in *!^) true;; *) false;; esac; then
            commit_type="${commit_type%!^}"
            commit_message="$commit_type!: $*"
        elif case "$commit_type" in *^) true;; *) false;; esac; then
            commit_type="${commit_type%^}"
            commit_message="$commit_type: $*"
        else
            local commit_scope="$1"
            shift
            local breaking=""
            case "$commit_type" in *!) breaking="!"; commit_type="${commit_type%!}"; esac
            commit_message="$commit_type($commit_scope)$breaking: $*"
        fi
        git commit -s -m "$commit_message"
    else
        commit_message="chore: wip"
        git commit -s -m "$commit_message"
    fi
    if command -v lolcat &>/dev/null; then
        printf '\nCommit message ~ "%s"\n' "$commit_message" | lolcat
    else
        printf '\nCommit message ~ "%s"\n' "$commit_message"
    fi
}

# Modern replacements for common tools (only if installed)
command -v dust &>/dev/null && alias du='dust'
command -v duf &>/dev/null && alias df='duf'
command -v procs &>/dev/null && alias prc='procs'
command -v gping &>/dev/null && alias ping='gping'
command -v dog &>/dev/null && alias dig='dog'
command -v fd &>/dev/null && alias fdd='fd'
command -v xh &>/dev/null && alias http='xh'
command -v btop &>/dev/null && alias top='btop'
command -v btm &>/dev/null && alias btm='btm'

# Better top/htop fallback chain
if command -v btop &>/dev/null; then
    alias htop='btop'
elif command -v btm &>/dev/null; then
    alias htop='btm'
fi

# Trippy needs sudo by default; alias it convenience
command -v trip &>/dev/null && alias traceroute='sudo trip'

# lsd shortcuts (if lsd is in use)
if command -v lsd &>/dev/null; then
    alias la='lsd -A'
    alias ll='lsd -lA --git --date=relative'
    alias lt='lsd --tree --depth=2'
fi

# Single-letter shortcuts
alias g='git'
alias gss='git status -sb'
alias gd='git diff'
alias gds='git diff --staged'

# kubectl power-aliases (work alongside the k() function above)
alias kgp='k get pods'
alias kgs='k get svc'
alias kgn='k get nodes'
alias kga='k get all'
alias kd='k describe'
alias kl='k logs -f --tail=100'
alias kx='k exec -it'

# Edit dotfiles repo (resolves source path via chezmoi at call time)
dotedit() {
    command -v chezmoi &>/dev/null || { echo "chezmoi not installed"; return 1; }
    "${EDITOR:-nvim}" "$(chezmoi source-path)"
}

# Reload shell config
alias reload='exec $SHELL -l'

# Go up N directories: `up 3` == `cd ../../..`
up() {
    local count="${1:-1}"
    local path=""
    for ((i=0; i<count; i++)); do path="../$path"; done
    cd "$path" || return 1
}

# Find process listening on a port: `port 8080`
port() {
    [ -z "$1" ] && { echo "usage: port <number>"; return 1; }
    lsof -nP -iTCP:"$1" -sTCP:LISTEN 2>/dev/null
}

# Kill process on a port: `killport 8080`
killport() {
    [ -z "$1" ] && { echo "usage: killport <number>"; return 1; }
    local pid
    pid="$(lsof -ti TCP:"$1" -sTCP:LISTEN 2>/dev/null)"
    [ -z "$pid" ] && { echo "no process listening on port $1"; return 1; }
    echo "killing pid $pid on port $1"
    kill "$pid"
}

# fzf branch checkout
gco() {
    command -v fzf &>/dev/null || { git checkout "$@"; return; }
    local branch
    branch="$(git branch --all --sort=-committerdate \
        | sed 's/^[ *]*//; s|^remotes/origin/||' \
        | grep -v 'HEAD ->' \
        | awk '!seen[$0]++' \
        | fzf --height=40% --reverse)" || return
    git checkout "${branch}"
}

# fzf ssh host: pick a host from ~/.ssh/config
sshh() {
    command -v fzf &>/dev/null || { echo "fzf not installed"; return 1; }
    local host
    host="$(awk '/^Host / && $2 !~ /\*/ { print $2 }' "$HOME/.ssh/config" 2>/dev/null \
        | fzf --height=40% --reverse)" || return
    ssh "${host}"
}

# Quick weather: `weather` or `weather denver`
weather() {
    local loc="${1:-}"
    curl -s "wttr.in/${loc}?Fn"
}

# Make a directory of today: `today`
today() {
    local dir
    dir="$HOME/today/$(date +%Y-%m-%d)"
    mkdir -p "$dir" && cd "$dir" || return 1
}

# Quick HTTP server in current dir
serve() {
    local port="${1:-8000}"
    if command -v python3 &>/dev/null; then
        python3 -m http.server "$port"
    else
        python -m SimpleHTTPServer "$port"
    fi
}

# Show your public IP
myip() {
    curl -s https://api.ipify.org
    echo
}

# Backup a file with timestamp: `bak file.txt` => file.txt.20260427-105300.bak
bak() {
    [ -z "$1" ] && { echo "usage: bak <file>"; return 1; }
    [ ! -e "$1" ] && { echo "file not found: $1"; return 1; }
    cp -a "$1" "$1.$(date +%Y%m%d-%H%M%S).bak"
}
