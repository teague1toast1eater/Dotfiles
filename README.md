# Dotfiles

My personal dotfiles managed with symlinks.

## Quick Start

### First Time Setup (collecting dotfiles)

1. Run the collection script to gather your dotfiles:
   ```bash
   ./dotfiles-manager.sh
   ```

2. Initialize git repository:
   ```bash
   git init
   git add .
   git commit -m "Initial dotfiles commit"
   git remote add origin <your-repo-url>
   git push -u origin main
   ```

### Installing on a New Machine

1. Clone this repository:
   ```bash
   git clone <your-repo-url> ~/dotfiles
   cd ~/dotfiles
   ```

2. Install dotfiles (creates symlinks):
   ```bash
   make install
   ```

That's it! Your dotfiles are now symlinked to their proper locations.

## Makefile Commands

- `make install` - Install dotfiles by creating symlinks (backs up existing files)
- `make uninstall` - Remove all symlinks and restore backups
- `make clean` - Remove backup directory
- `make help` - Show available commands

## What Gets Symlinked

The Makefile will create symlinks for files listed in the `DOTFILES` and `CONFIG_FILES` variables. Current list includes:

- `.bashrc`
- `.bash_profile`
- `.profile`
- `.zshrc`
- `.vimrc`
- `.gitconfig`
- `.tmux.conf`
- `.config/nvim/init.vim`
- `.config/fish/config.fish`

## Adding New Dotfiles

To manage additional dotfiles:

1. Add the file to your `~/dotfiles` directory (maintaining the same structure)
2. Update the `DOTFILES` or `CONFIG_FILES` list in the `Makefile`
3. Run `make install` to create the symlink

## Directory Structure

```
~/dotfiles/
├── .bashrc
├── .vimrc
├── .gitconfig
├── .config/
│   └── nvim/
│       └── init.vim
├── backup/              # Backups of overwritten files
├── Makefile             # Installation automation
├── dotfiles-manager.sh  # Initial collection script
└── README.md
```

## Safety Features

- **Automatic Backups**: Existing dotfiles are backed up to `backup/` before being replaced
- **Symlink Detection**: Won't overwrite existing symlinks that point to the correct location
- **Dry-run Safe**: You can review what will happen before running `make install`

## Troubleshooting

**Symlink already exists but points elsewhere:**
- The Makefile will update it to point to the correct location

**File exists but isn't a symlink:**
- The file will be backed up to `backup/` and replaced with a symlink

**Want to restore original files:**
- Run `make uninstall` to remove symlinks and restore backups
