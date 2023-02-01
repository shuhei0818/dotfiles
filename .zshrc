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
path+=(
  $(go env GOPATH)/bin #Go
  $HOME/.jenv/bin # Java
  $HOME/.volta/bin(N-/) # JavaScript
  /opt/homebrew/opt/mysql-client/bin #mysql
)

# jenv
eval "$(jenv init -)"

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
alias rm="rm -i"

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

source $HOME/bin/pecofunc

zle -N peco-select-history;bindkey '^r' peco-select-history # history with peco
zle -N peco-cdr; bindkey '^t' peco-cdr # cdr with peco
alias ghd=peco-ghq-cd # ghq with vscode
alias ghv=peco-ghq-code # ghq with vscode
alias ghi=peco-ghq-idea # ghq with vscode
alias ghw=peco-ghq-gh # ghq with github-cli web
alias dexec=peco-docker-exec # docker with peco

precmd() {
    git_prompt
}
