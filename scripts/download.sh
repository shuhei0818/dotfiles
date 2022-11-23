#!/bin/bash

set -euC

DOTFILES_GITHUB="https://github.com/shuhei0818/dotfiles.git"
DOTFILES_TARBALL="https://github.com/shuhei0818/dotfiles/archive/master.tar.gz"
DOTPATH=~/dotfiles

function is_exists() {
    which "$1" >/dev/null 2>&1
    return $?
}

function dotfiles_download() {
    if [ -d "$DOTPATH" ]; then
        echo "$DOTPATH: already exists"
        exit 1
    fi

    echo "Downloading dotfiles..."

    if is_exists "git"; then # git
        git clone --recursive "$DOTFILES_GITHUB" "$DOTPATH"
    elif is_exists "curl" || is_exists "wget"; then # curl or wget
        if is_exists "curl"; then
            curl -L "$DOTFILES_TARBALL"
        elif is_exists "wget"; then
            wget -O - "$DOTFILES_TARBALL"
        fi | tar xvz

        if [ ! -d dotfiles-main ]; then
            echo "dotfiles-main: not found"
            exit 1
        fi

        command mv -f dotfiles-main "$DOTPATH"
    else
        echo "curl or wget required"
        exit 1
    fi
    echo "Success: Download"
}

function main() {
    dotfiles_download
    cd "${DOTPATH}"
    bash ./scripts/install.sh
}

main
