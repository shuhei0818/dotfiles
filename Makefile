DOTFILES_EXCLUDES    := .DS_Store .git .gitmodules .travis.yml
DOTFILES_TARGET      := $(wildcard .??*) bin
DOTFILES_DIR         := $(PWD)
DOTFILES_FILES       := $(filter-out $(DOTFILES_EXCLUDES), $(DOTFILES_TARGET))

VSCODE_TARGET_DIR    := vscode
VSCODE_SOURCE_DIR    := ~/Library/Application\ Support/Code/User
VSCODE_SUFFIX        := .json
VSCODE_SETTING_FILES := $(wildcard $(VSCODE_TARGET_DIR)/*$(VSCODE_SUFFIX))
VSCODE_EXTENSIONS    := ${shell cat $(VSCODE_TARGET_DIR)/extensions}

deploy:
	@$(foreach val, $(DOTFILES_FILES), ln -sfnv $(abspath $(val)) $(HOME)/$(val);)
	@$(foreach val, $(VSCODE_SETTING_FILES), ln -sfnv $(abspath $(val)) $(VSCODE_SOURCE_DIR)/$(notdir $(val));)
	@code --list-extensions > $(VSCODE_TARGET_DIR)/extensions

init:
	@$(foreach val, $(VSCODE_EXTENSIONS), code --install-extension $(val);)