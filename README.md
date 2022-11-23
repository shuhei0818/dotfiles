# Dotfiles

## Install
```bash
$ curl -L raw.github.com/shuhei0818/dotfiles/main/scripts/download.sh | bash
```

## Update
### brewfile and vscode extentions.
```bash
$ make update
```

### Homebrew
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

