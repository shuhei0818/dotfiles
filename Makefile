DOTFILES_EXCLUDES    := .DS_Store .git .gitmodules .travis.yml
DOTFILES_TARGET      := $(wildcard .??*) bin
DOTFILES_DIR         := $(PWD)
DOTFILES_FILES       := $(filter-out $(DOTFILES_EXCLUDES), $(DOTFILES_TARGET))

VSCODE_TARGET_DIR    := vscode
VSCODE_SOURCE_DIR    := ~/Library/Application\ Support/Code/User
VSCODE_SUFFIX        := .json
VSCODE_SETTING_FILES := $(wildcard $(VSCODE_TARGET_DIR)/*$(VSCODE_SUFFIX))
VSCODE_EXTENSIONS    := ${shell cat $(VSCODE_TARGET_DIR)/extensions}

# Create symlinks to dotfiles.
deploy: deploy-dotfiles deploy-vscode

deploy-dotfiles:
	@$(foreach val, $(DOTFILES_FILES), ln -sfnv $(abspath $(val)) $(HOME)/$(val);)

deploy-vscode:
	@$(foreach val, $(VSCODE_SETTING_FILES), ln -sfnv $(abspath $(val)) $(VSCODE_SOURCE_DIR)/$(notdir $(val));)

# Install brew package and vscode extentions.
install: install-brew install-vscode

install-brew:
	@brew bundle --file 'Brewfile'

install-vscode:
	@$(foreach val, $(VSCODE_EXTENSIONS), code --install-extension $(val);)

# Update brewfile and vscode extentions.
update: update-brew update-vscode

update-brew:
	@brew bundle dump --force

update-vscode:
	@code --list-extensions > $(VSCODE_TARGET_DIR)/extensions