# Path
typeset -U path PATH
path=(
  /opt/homebrew/bin(N-/)
  /opt/homebrew/sbin(N-/)
  /usr/bin
  /usr/sbin
  /bin
  /sbin
  /usr/local/bin(N-/)
  /usr/local/sbin(N-/)
  ~/bin
)
path+=$(go env GOPATH)/bin

# history
HISTFILE=$HOME/.zsh-history
HISTSIZE=100000
SAVEHIST=1000000

# share .zshhistory
setopt inc_append_history
setopt share_history

# color
autoload -Uz colors && colors

# cdr
autoload -Uz add-zsh-hock
autoload -Uz chpwd_recent_dirs cdr add-zsh-hook

# alias
alias ls="ls -GF"
alias la="ls -a"
alias ll="ls -l"
alias lla="ls -la"

alias relogin='exec $SHELL -l'

# Homebrew
export HOMEBREW_CASK_OPTS=--no-quarantine

# github-cli
FPATH=$(brew --prefix)/share/zsh/site-functions/:$FPATH

# zsh-completions
FPATH=$(brew --prefix)/share/zsh-completions:$FPATH

autoload -Uz compinit
compinit -i

# zsh-autosuggestions
source $(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh

# zsh-syntax-highlighting
source $(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# zsh-git-prompt
source $(brew --prefix)/opt/zsh-git-prompt/zshrc.sh

ZSH_THEME_GIT_PROMPT_PREFIX="["
ZSH_THEME_GIT_PROMPT_SUFFIX="]"
ZSH_THEME_GIT_PROMPT_BRANCH="%{$fg[white]%}"
ZSH_THEME_GIT_PROMPT_STAGED="%{$fg[green]%}%{ %G%}"
ZSH_THEME_GIT_PROMPT_CONFLICTS="%{$fg[magenta]%}%{x%G%}"
ZSH_THEME_GIT_PROMPT_CHANGED="%{$fg[red]%}%{+%G%}"
ZSH_THEME_GIT_PROMPT_BEHIND="%{$fg[red]%}%{-%G%}"
ZSH_THEME_GIT_PROMPT_AHEAD="%{$fg[green]%}%{+%G%}"
ZSH_THEME_GIT_PROMPT_CLEAN="%{$fg[green]%}%{✔%G%}"

function git_prompt() {
    if [ "$(git rev-parse --is-inside-work-tree 2> /dev/null)" = true ]; then
        PROMPT="%F{074}%n@$(arch)%f %F{142}%1~%f $(git_super_status) %# "
    else
        PROMPT="%F{074}%n@$(arch)%f %F{142}%1~%f %# "
    fi
}

# history with peco
function peco-select-history() {
    BUFFER=$(history -n 1 | tail -r | awk '!a[$0]++' | peco --prompt "history ❯")
    CURSOR=$#BUFFER
    zle clear-screen
}
zle -N peco-select-history
bindkey '^r' peco-select-history

# cdr with peco
function peco-cdr() {
    local destination="$(cdr -l | sed 's/^[0-9]* *//' | peco --prompt "cdr ❯" --query "$LBUFFER")"
    if [ -n "$destination" ]; then
        BUFFER="cd $destination"
        zle accept-line
    fi
}
zle -N peco-cdr
bindkey '^t' peco-cdr

# ghq with vscode
function peco-ghq-code () {
    local destination=$(ghq list -p | peco --prompt "ghv ❯")
    if [ -n "$destination" ]; then
        code ${destination}
    fi
}
alias ghv=peco-ghq-code

# ghq with github-cli web
function peco-ghq-gh () {
    local destination=$(gh repo list | awk '{print $1}' | peco --prompt "ghw ❯")
    if [ -n "$destination" ]; then
        gh repo view -w ${destination}
    fi
}
alias ghw=peco-ghq-gh

# docker with peco
function peco-docker-exec () {
    local destination=$(docker ps --format "table {{.ID}}\t{{.Image}}\t{{.Command}}\t{{.Status}}\t{{.Names}}" | sed 1d | peco --prompt "dexec ❯" | awk '{print $1}')
    if [ -n "$destination" ]; then
        docker exec -it ${destination} /bin/bash
        if [ $status != 0 ]; then
            docker exec -it ${destination} sh
        fi
    fi
}
alias dexec=peco-docker-exec

precmd() {
    git_prompt
}
