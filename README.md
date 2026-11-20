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
- `make install-system` - Install root-owned files from `system/` (needs sudo)
- `make uninstall-system` - Remove `system/` symlinks and restore backups (needs sudo)
- `make clean` - Remove backup directory
- `make help` - Show available commands

## System Files (root-owned)

Some files, like udev rules, don't live under `$HOME` and need root to install.
These are mirrored under `system/` using their real absolute path (e.g.
`system/etc/udev/rules.d/foo.rules` -> `/etc/udev/rules.d/foo.rules`), listed
in the `SYSTEM_FILES` variable in the Makefile, and symlinked into place by
`make install-system` (sudo required; same backup/detection behavior as
`make install`).

Currently included:
- `system/etc/udev/rules.d/99-internal-keyboard-toggle.rules` + `system/usr/local/bin/toggle-internal-keyboard.sh` - disables the internal laptop keyboard while an external USB/Bluetooth keyboard is connected.

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

## Hyprland on Omarchy vs. CachyOS

`~/.config/hypr` points at a different directory depending on the machine:

| Host | `~/.config/hypr` → | Notes |
|------|--------------------|-------|
| Omarchy (`/usr/share/omarchy` exists) | `.config/hypr` | Small overrides on top of Omarchy's defaults |
| Anything else (CachyOS) | `.config/hypr-cachyos` | Standalone: Omarchy's default keybindings + my overrides, stock tools only |

Force one with `make install HYPR_SRC=hypr-cachyos`. On non-Omarchy hosts, `.config/omarchy` is not linked.

When you change a binding in `.config/hypr/bindings.lua`, mirror it in
`.config/hypr-cachyos/bindings.lua`. Pick apps (terminal, browser, launcher)
in `o.apps` in `.config/hypr-cachyos/helpers.lua`.

**CachyOS packages the standalone config expects:**
`hyprlock hypridle waybar swaync (or mako) walker (or fuzzel/rofi) awww (or swaybg)
grim slurp wl-clipboard cliphist hyprpicker brightnessctl playerctl jq libnotify
pavucontrol blueman` and `uwsm` (optional).

### Wallpapers

`~/.local/bin/wallpaper` stands in for `omarchy theme bg`. Images live in
`~/Wallpapers` (or `$WALLPAPER_DIR`) and are not tracked in git.

| Key | Action |
|-----|--------|
| `SUPER + CTRL + SPACE` / `SUPER + CTRL + W` | Pick a wallpaper (launcher) |
| `SUPER + SHIFT + CTRL + W` | Next wallpaper |

`wallpaper restore` runs at login. The current image is linked at
`~/.cache/wallpaper/current`, which hyprlock uses as its background.

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
