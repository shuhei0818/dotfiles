# Dotfiles

## Install [Homebrew](https://brew.sh/) brew package and vscode extentions.
```bash
$ /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
$ make install
```

## Create symlinks to dotfiles.
```bash
$ make deploy
```

## Update brewfile and vscode extentions.
```bash
$ make update
```

## Homebrew
```bash
# Update homebrew & fix software.
$ brew update

# Confrim software list for upgrade.
$ brew outdated #CUI
$ brew outdated --cask #GUI

# Upgrade software.
$ brew upgrade # CUI
$ brew upgrade --cask --greedy # GUI
```
