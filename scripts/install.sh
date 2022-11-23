#!/bin/zsh

set -euC

function install_brew() {
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
}

function install_all() {
    make install
}

function create_link() {
    make deploy
}

function init_zsh-completions() {
    chmod -R go-w /opt/homebrew/share
    rm -f ~/.zcompdump
    autoload -Uz compinit
    compinit
}

function init_jenv() {
    jenv add "$(/usr/libexec/java_home -v '19')"
    jenv add "$(/usr/libexec/java_home -v '17')"
    jenv global 17.0.5
}

function main() {
    install_brew
    install_all
    create_link
    init_zsh-completions
    init_jenv
}

main
