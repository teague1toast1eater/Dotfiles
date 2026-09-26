# Dotfiles Makefile
# Usage: make install

SHELL := /bin/bash
HOME_DIR := $(HOME)
DOTFILES_DIR := $(shell pwd)
BACKUP_DIR := $(DOTFILES_DIR)/backup
SYSTEM_DIR := $(DOTFILES_DIR)/system

# Colors for output
GREEN := \033[0;32m
YELLOW := \033[1;33m
RED := \033[0;31m
NC := \033[0m

# List all dotfiles to symlink (relative paths from home directory)
DOTFILES := \
	.bashrc \
	.bash_profile \
	.profile \
	.zshrc \
	.vimrc \
	.gitconfig \
	.tmux.conf \
	.local/bin/monitor

# List .config subdirectories to symlink as a whole
# Each entry is symlinked as ~/.config/<dir> -> <dotfiles>/.config/<dir>
#
# Note: Some Omarchy dirs have nested paths (e.g. Typora/themes, chromium/Default).
# Symlinking the top-level dir (Typora, chromium) covers those and is usually preferable,
# but only add them if you actually track those dirs in your dotfiles repo.
CONFIG_DIRS := \
	nvim \
	zsh \
	alacritty \
	btop \
	elephant \
	environment.d \
	fastfetch \
	fcitx5 \
	fontconfig \
	ghostty \
	git \
	hypr \
	hyprland-preview-share-picker \
	imv \
	kitty \
	lazygit \
	omarchy \
	opencode \
	swayosd \
	systemd \
	tmux \
	uwsm \
	walker

# Root-owned files (outside $HOME), mirrored under system/ with the same
# absolute path structure, e.g. system/etc/foo -> /etc/foo.
# `make install-system` / `make uninstall-system` require sudo.
SYSTEM_FILES := \
	etc/udev/rules.d/99-internal-keyboard-toggle.rules \
	usr/local/bin/toggle-internal-keyboard.sh

.PHONY: all install uninstall clean backup help install-system uninstall-system

# Default target
all: help

help:
	@echo "Dotfiles Makefile"
	@echo ""
	@echo "Available targets:"
	@echo "  make install    - Install dotfiles by creating symlinks"
	@echo "  make uninstall  - Remove symlinks and restore backups"
	@echo "  make backup     - Backup existing dotfiles before installing"
	@echo "  make clean      - Remove backup directory"
	@echo "  make install-system   - Install root-owned files from system/ (needs sudo)"
	@echo "  make uninstall-system - Remove system/ symlinks and restore backups (needs sudo)"
	@echo "  make help       - Show this help message"

install: backup
	@echo -e "$(GREEN)Installing dotfiles...$(NC)"
	@mkdir -p $(BACKUP_DIR)
	@$(MAKE) -s install-dotfiles
	@$(MAKE) -s install-config
	@echo -e "$(GREEN)Installation complete!$(NC)"
	@echo ""
	@echo "Your dotfiles are now symlinked from $(DOTFILES_DIR)"

install-dotfiles:
	@for file in $(DOTFILES); do \
		target=$(DOTFILES_DIR)/$$file; \
		link=$(HOME_DIR)/$$file; \
		if [ -e $$target ]; then \
			if [ -L $$link ]; then \
				link_target=$$(readlink $$link); \
				if [ "$$link_target" = "$$target" ]; then \
					echo -e "$(YELLOW)✓$(NC) $$file already symlinked"; \
				else \
					echo -e "$(YELLOW)⚠$(NC) $$file is symlinked to $$link_target, updating..."; \
					rm $$link; \
					ln -s $$target $$link; \
					echo -e "$(GREEN)✓$(NC) Updated symlink for $$file"; \
				fi; \
			elif [ -e $$link ]; then \
				echo -e "$(YELLOW)⚠$(NC) Backing up existing $$file"; \
				mkdir -p $(BACKUP_DIR)/$$(dirname $$file); \
				mv $$link $(BACKUP_DIR)/$$file.backup; \
				mkdir -p $$(dirname $$link); \
				ln -s $$target $$link; \
				echo -e "$(GREEN)✓$(NC) Symlinked $$file"; \
			else \
				mkdir -p $$(dirname $$link); \
				ln -s $$target $$link; \
				echo -e "$(GREEN)✓$(NC) Symlinked $$file"; \
			fi; \
		else \
			echo -e "$(YELLOW)⚠$(NC) $$file not found in $(DOTFILES_DIR), skipping"; \
		fi; \
	done

install-config:
	@mkdir -p $(HOME_DIR)/.config
	@for dir in $(CONFIG_DIRS); do \
		target=$(DOTFILES_DIR)/.config/$$dir; \
		link=$(HOME_DIR)/.config/$$dir; \
		if [ -e $$target ]; then \
			if [ -L $$link ]; then \
				link_target=$$(readlink $$link); \
				if [ "$$link_target" = "$$target" ]; then \
					echo -e "$(YELLOW)✓$(NC) .config/$$dir already symlinked"; \
				else \
					echo -e "$(YELLOW)⚠$(NC) .config/$$dir is symlinked to $$link_target, updating..."; \
					rm $$link; \
					ln -s $$target $$link; \
					echo -e "$(GREEN)✓$(NC) Updated symlink for .config/$$dir"; \
				fi; \
			elif [ -d $$link ]; then \
				echo -e "$(YELLOW)⚠$(NC) Backing up existing .config/$$dir"; \
				mv $$link $(BACKUP_DIR)/$$dir.backup; \
				ln -s $$target $$link; \
				echo -e "$(GREEN)✓$(NC) Symlinked .config/$$dir"; \
			else \
				ln -s $$target $$link; \
				echo -e "$(GREEN)✓$(NC) Symlinked .config/$$dir"; \
			fi; \
		else \
			echo -e "$(YELLOW)⚠$(NC) .config/$$dir not found in $(DOTFILES_DIR), skipping"; \
		fi; \
	done

install-system:
	@echo -e "$(GREEN)Installing system files (requires sudo)...$(NC)"
	@for file in $(SYSTEM_FILES); do \
		target=$(SYSTEM_DIR)/$$file; \
		link=/$$file; \
		sudo mkdir -p $$(dirname $$link); \
		if [ -L $$link ]; then \
			link_target=$$(readlink $$link); \
			if [ "$$link_target" = "$$target" ]; then \
				echo -e "$(YELLOW)✓$(NC) /$$file already symlinked"; \
			else \
				echo -e "$(YELLOW)⚠$(NC) /$$file is symlinked to $$link_target, updating..."; \
				sudo rm $$link; \
				sudo ln -s $$target $$link; \
				echo -e "$(GREEN)✓$(NC) Updated symlink for /$$file"; \
			fi; \
		elif [ -e $$link ]; then \
			echo -e "$(YELLOW)⚠$(NC) Backing up existing /$$file"; \
			sudo mv $$link $$link.dotfiles-backup; \
			sudo ln -s $$target $$link; \
			echo -e "$(GREEN)✓$(NC) Symlinked /$$file"; \
		else \
			sudo ln -s $$target $$link; \
			echo -e "$(GREEN)✓$(NC) Symlinked /$$file"; \
		fi; \
	done
	@sudo udevadm control --reload
	@sudo udevadm trigger --subsystem-match=input --action=add
	@echo -e "$(GREEN)System install complete!$(NC)"

uninstall-system:
	@echo -e "$(YELLOW)Uninstalling system files...$(NC)"
	@for file in $(SYSTEM_FILES); do \
		target=$(SYSTEM_DIR)/$$file; \
		link=/$$file; \
		if [ -L $$link ] && [ "$$(readlink $$link)" = "$$target" ]; then \
			echo -e "$(YELLOW)✗$(NC) Removing symlink for /$$file"; \
			sudo rm $$link; \
			if [ -e $$link.dotfiles-backup ]; then \
				echo -e "$(GREEN)✓$(NC) Restoring backup for /$$file"; \
				sudo mv $$link.dotfiles-backup $$link; \
			fi; \
		fi; \
	done
	@sudo udevadm control --reload
	@echo -e "$(GREEN)System uninstall complete!$(NC)"

backup:
	@echo -e "$(GREEN)Creating backup directory...$(NC)"
	@mkdir -p $(BACKUP_DIR)

uninstall:
	@echo -e "$(YELLOW)Uninstalling dotfiles...$(NC)"
	@for file in $(DOTFILES); do \
		link=$(HOME_DIR)/$$file; \
		if [ -L $$link ]; then \
			echo -e "$(YELLOW)✗$(NC) Removing symlink for $$file"; \
			rm $$link; \
			if [ -e $(BACKUP_DIR)/$$file.backup ]; then \
				echo -e "$(GREEN)✓$(NC) Restoring backup for $$file"; \
				mv $(BACKUP_DIR)/$$file.backup $$link; \
			fi; \
		fi; \
	done
	@for dir in $(CONFIG_DIRS); do \
		link=$(HOME_DIR)/.config/$$dir; \
		if [ -L $$link ]; then \
			echo -e "$(YELLOW)✗$(NC) Removing symlink for .config/$$dir"; \
			rm $$link; \
			if [ -e $(BACKUP_DIR)/$$dir.backup ]; then \
				echo -e "$(GREEN)✓$(NC) Restoring backup for .config/$$dir"; \
				mv $(BACKUP_DIR)/$$dir.backup $$link; \
			fi; \
		fi; \
	done
	@echo -e "$(GREEN)Uninstall complete!$(NC)"

clean:
	@echo -e "$(YELLOW)Removing backup directory...$(NC)"
	@rm -rf $(BACKUP_DIR)
	@echo -e "$(GREEN)Backup directory removed!$(NC)"
