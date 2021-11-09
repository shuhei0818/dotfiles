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
  ~/bin/
)

# Homebrew
export HOMEBREW_CASK_OPTS=--no-quarantine

# color
autoload -Uz colors && colors

# alias
alias ls="ls -GF"
alias la="ls -a"
alias ll="ls -l"
alias lla="ls -la"

if type brew &>/dev/null; then
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

  git_prompt() {
    if [ "$(git rev-parse --is-inside-work-tree 2> /dev/null)" = true ]; then
      PROMPT="%F{074}%n@$(arch)%f %F{142}%1~%f $(git_super_status) %# "
    else
      PROMPT="%F{074}%n@$(arch)%f %F{142}%1~%f %# "
    fi
  }

  precmd() {
    git_prompt
  }

fi
