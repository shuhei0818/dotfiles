SHELL=/bin/zsh

DOTFILES_EXCLUDES     := .DS_Store .git .gitmodules .travis.yml
DOTFILES_TARGET       := $(wildcard .??*) bin
DOTFILES_DIR          := $(PWD)
DOTFILES_FILES        := $(filter-out $(DOTFILES_EXCLUDES), $(DOTFILES_TARGET))

VSCODE_SOURCE_DIR     := vscode
VSCODE_TARGET_DIR     := ~/Library/Application\ Support/Code/User
VSCODE_SUFFIX         := .json
VSCODE_SETTING_FILES  := $(wildcard $(VSCODE_SOURCE_DIR)/*$(VSCODE_SUFFIX))
VSCODE_SNIPPETS_FILES := $(VSCODE_SOURCE_DIR)/snippets/*$(VSCODE_SUFFIX)
VSCODE_EXTENSIONS     := ${shell cat $(VSCODE_SOURCE_DIR)/extensions}

BREW_SOURCE_DIR       := brew
BREW_FILE             := $(BREW_SOURCE_DIR)/Brewfile

KARABINER_SOURCE_DIR  := karabiner
KARABINER_FILE        := $(KARABINER_SOURCE_DIR)/karabiner.json
KARABINER_TARGET_DIR  := ~/.config/karabiner

# Create symlinks to dotfiles.
deploy: deploy-dotfiles deploy-vscode deploy-karabiner

deploy-dotfiles:
	@$(foreach val, $(DOTFILES_FILES), ln -sfnv $(abspath $(val)) $(HOME)/$(val);)

deploy-vscode:
	@$(foreach val, $(VSCODE_SETTING_FILES), ln -sfnv $(abspath $(val)) $(VSCODE_TARGET_DIR)/$(notdir $(val));)
	@$(foreach val, $(VSCODE_SNIPPETS_FILES), ln -sfnv $(abspath $(val)) $(VSCODE_TARGET_DIR)/snippets/$(notdir $(val));)

deploy-karabiner:
	@ln -sfnv $(abspath $(KARABINER_FILE)) $(KARABINER_TARGET_DIR)/$(notdir $(KARABINER_FILE))

# Install brew package and vscode extentions.
install: install-brew install-vscode

install-brew:
	@brew bundle --file '$(BREW_FILE)'

install-vscode:
	@$(foreach val, $(VSCODE_EXTENSIONS), code --install-extension $(val);)

# Update brewfile and vscode extentions.
update: update-brew update-vscode

update-brew:
	@brew bundle dump --force --file '$(BREW_FILE)'

update-vscode:
	@code --list-extensions > $(VSCODE_SOURCE_DIR)/extensions
