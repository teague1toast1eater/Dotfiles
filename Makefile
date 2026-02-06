# Dotfiles Makefile
# Usage: make install

SHELL := /bin/bash
HOME_DIR := $(HOME)
DOTFILES_DIR := $(shell pwd)
BACKUP_DIR := $(DOTFILES_DIR)/backup

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
	.tmux.conf

# List config directories/files (these go in .config/)
CONFIG_FILES := \
	nvim/init.vim \
	fish/config.fish

.PHONY: all install uninstall clean backup help

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
				mv $$link $(BACKUP_DIR)/$$file.backup; \
				ln -s $$target $$link; \
				echo -e "$(GREEN)✓$(NC) Symlinked $$file"; \
			else \
				ln -s $$target $$link; \
				echo -e "$(GREEN)✓$(NC) Symlinked $$file"; \
			fi; \
		else \
			echo -e "$(YELLOW)⚠$(NC) $$file not found in $(DOTFILES_DIR), skipping"; \
		fi; \
	done

install-config:
	@for file in $(CONFIG_FILES); do \
		target=$(DOTFILES_DIR)/.config/$$file; \
		link=$(HOME_DIR)/.config/$$file; \
		link_dir=$$(dirname $$link); \
		if [ -e $$target ]; then \
			mkdir -p $$link_dir; \
			if [ -L $$link ]; then \
				link_target=$$(readlink $$link); \
				if [ "$$link_target" = "$$target" ]; then \
					echo -e "$(YELLOW)✓$(NC) .config/$$file already symlinked"; \
				else \
					echo -e "$(YELLOW)⚠$(NC) .config/$$file is symlinked to $$link_target, updating..."; \
					rm $$link; \
					ln -s $$target $$link; \
					echo -e "$(GREEN)✓$(NC) Updated symlink for .config/$$file"; \
				fi; \
			elif [ -e $$link ]; then \
				echo -e "$(YELLOW)⚠$(NC) Backing up existing .config/$$file"; \
				mkdir -p $(BACKUP_DIR)/.config/$$(dirname $$file); \
				mv $$link $(BACKUP_DIR)/.config/$$file.backup; \
				ln -s $$target $$link; \
				echo -e "$(GREEN)✓$(NC) Symlinked .config/$$file"; \
			else \
				ln -s $$target $$link; \
				echo -e "$(GREEN)✓$(NC) Symlinked .config/$$file"; \
			fi; \
		else \
			echo -e "$(YELLOW)⚠$(NC) .config/$$file not found in $(DOTFILES_DIR), skipping"; \
		fi; \
	done

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
	@for file in $(CONFIG_FILES); do \
		link=$(HOME_DIR)/.config/$$file; \
		if [ -L $$link ]; then \
			echo -e "$(YELLOW)✗$(NC) Removing symlink for .config/$$file"; \
			rm $$link; \
			if [ -e $(BACKUP_DIR)/.config/$$file.backup ]; then \
				echo -e "$(GREEN)✓$(NC) Restoring backup for .config/$$file"; \
				mv $(BACKUP_DIR)/.config/$$file.backup $$link; \
			fi; \
		fi; \
	done
	@echo -e "$(GREEN)Uninstall complete!$(NC)"

clean:
	@echo -e "$(YELLOW)Removing backup directory...$(NC)"
	@rm -rf $(BACKUP_DIR)
	@echo -e "$(GREEN)Backup directory removed!$(NC)"
