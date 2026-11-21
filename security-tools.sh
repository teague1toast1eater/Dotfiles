#!/usr/bin/env bash
# Install the security tools I'm learning, so every machine has the same set.
# Safe to re-run: anything already installed is skipped.
#
# Usage: ./security-tools.sh   (or: make install-security)
# Add or remove tools by editing the lists below.

set -euo pipefail

# Official Arch repos (core/extra)
PACMAN_PKGS=(
	# Recon / scanning
	nmap
	whois
	bind                 # dig, nslookup
	# Packet capture / sniffing
	wireshark-qt         # also pulls in wireshark-cli (tshark)
	tcpdump
	dsniff               # arpspoof, urlsnarf, ...
	# Wireless
	aircrack-ng
	# Password cracking
	hashcat
	john
	seclists             # wordlists -> /usr/share/seclists
	# Web
	sqlmap
	# Reverse engineering / forensics
	ghidra
	radare2
	gdb
	binwalk
	perl-image-exiftool  # exiftool
	# Network utilities
	openbsd-netcat       # nc
	socat
)

# AUR
AUR_PKGS=(
	burpsuite            # Burp Suite Community Edition
)

# mdxfind isn't packaged; it's built from source into ~/tools and copied to ~/.local/bin
MDXFIND_REPO=https://github.com/Cynosureprime/mdxfind
MDXFIND_DIR=$HOME/tools/mdxfind
MDXFIND_BUILD_DEPS=(git base-devel autoconf automake libtool yasm)

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'
info() { echo -e "${GREEN}==>${NC} $*"; }
warn() { echo -e "${YELLOW}==> WARNING:${NC} $*"; }
die()  { echo -e "${RED}==> ERROR:${NC} $*" >&2; exit 1; }

command -v pacman >/dev/null || die "pacman not found; this script is for Arch-based systems."
[[ $EUID -ne 0 ]] || die "Run as your normal user, not root (sudo is used where needed)."

# --- Official packages -------------------------------------------------------
info "Installing official packages..."
sudo pacman -S --needed --noconfirm "${PACMAN_PKGS[@]}"

# --- AUR packages ------------------------------------------------------------
if command -v yay >/dev/null; then
	AUR_HELPER=yay
elif command -v paru >/dev/null; then
	AUR_HELPER=paru
else
	AUR_HELPER=""
fi

if [[ -n $AUR_HELPER ]]; then
	info "Installing AUR packages with $AUR_HELPER..."
	"$AUR_HELPER" -S --needed --noconfirm "${AUR_PKGS[@]}"
else
	warn "No AUR helper (yay or paru) found; skipping: ${AUR_PKGS[*]}"
fi

# --- mdxfind (from source) ---------------------------------------------------
info "Setting up mdxfind..."
sudo pacman -S --needed --noconfirm "${MDXFIND_BUILD_DEPS[@]}"
if [[ -d $MDXFIND_DIR/.git ]]; then
	git -C "$MDXFIND_DIR" pull --ff-only || warn "Couldn't update mdxfind; building the copy already there."
else
	mkdir -p "$(dirname "$MDXFIND_DIR")"
	git clone "$MDXFIND_REPO" "$MDXFIND_DIR"
fi
if (cd "$MDXFIND_DIR" && make deps && make -j"$(nproc)" mdxfind mdsplit); then
	mkdir -p "$HOME/.local/bin"
	install -m 755 "$MDXFIND_DIR/mdxfind" "$MDXFIND_DIR/mdsplit" "$HOME/.local/bin/"
	info "Installed mdxfind and mdsplit to ~/.local/bin"
else
	warn "mdxfind build failed; see output above. Everything else is installed."
fi

# --- Post-install setup ------------------------------------------------------
# Let Wireshark/tshark capture without running as root.
if ! id -nG "$USER" | grep -qw wireshark; then
	sudo usermod -aG wireshark "$USER"
	warn "Added $USER to the 'wireshark' group. Log out and back in for it to take effect."
fi

# --- Summary -----------------------------------------------------------------
info "Checking that everything is installed..."
missing=()
for pkg in "${PACMAN_PKGS[@]}" "${AUR_PKGS[@]}"; do
	pacman -Q "$pkg" &>/dev/null || missing+=("$pkg")
done
[[ -x $HOME/.local/bin/mdxfind ]] || missing+=(mdxfind)

if ((${#missing[@]})); then
	warn "Not installed: ${missing[*]}"
	exit 1
fi
info "All security tools are installed."
