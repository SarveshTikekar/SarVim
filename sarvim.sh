#!/usr/bin/env bash

# Exit immediately if a command exits with a non-zero status
set -e

# Define Colors for attractive terminal output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
MAGENTA='\033[0;35m'
CYAN='\033[0;36m'
BOLD='\033[1m'
NC='\033[0m' # No Color

# Helper functions for printing status messages
print_header() {
    echo -e "${BOLD}${CYAN}"
    echo "  ____              __     ___                 "
    echo " / ___|  __ _ _ __  \ \   / (_)_ __ ___        "
    echo " \___ \ / _' | '__|  \ \ / /| | '_ \` _ \       "
    echo "  ___) | (_| | |      \ V / | | | | | | |      "
    echo " |____/ \__,_|_|       \_/  |_|_| |_| |_|      "
    echo -e "${NC}"
    echo -e "${BOLD}${MAGENTA}====================================================${NC}"
    echo -e "${BOLD}${WHITE}       SarVim Development Environment Setup        ${NC}"
    echo -e "${BOLD}${MAGENTA}====================================================${NC}\n"
}

print_step() {
    echo -e "\n${BOLD}${BLUE}[*] $1${NC}"
}

print_success() {
    echo -e "${GREEN}[✓] $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}[!] $1${NC}"
}

print_error() {
    echo -e "${RED}[✗] $1${NC}"
}

# Ensure script is run from the repository directory
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd "$SCRIPT_DIR"

# Print Banner
print_header

# -----------------------------------------------------------------------------
# Step 1: Dependency Check & Installation
# -----------------------------------------------------------------------------
print_step "Checking System Dependencies..."

DEPS=("git" "curl" "unzip" "tmux")
MISSING_DEPS=()

for dep in "${DEPS[@]}"; do
    if ! command -v "$dep" &> /dev/null; then
        MISSING_DEPS+=("$dep")
    fi
done

if ! command -v fc-cache &> /dev/null; then
    MISSING_DEPS+=("fontconfig")
fi

if [ ${#MISSING_DEPS[@]} -gt 0 ]; then
    print_warning "The following dependencies are missing: ${MISSING_DEPS[*]}"
    print_warning "Attempting to install them via apt (sudo privileges may be requested)..."
    sudo apt update
    for dep in "${MISSING_DEPS[@]}"; do
        sudo apt install -y "$dep"
    done
    print_success "All system dependencies installed successfully!"
else
    print_success "All base system dependencies are already installed!"
fi

# Also check for Neovim (needed for the config to run)
if ! command -v nvim &> /dev/null; then
    print_warning "Neovim (nvim) was not found on your system."
    print_warning "LazyVim and SarVim require Neovim (v0.8.0 or newer)."
    read -p "Would you like to install Neovim stable via AppImage? (y/n): " -n 1 -r
    echo ""
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        print_step "Installing Neovim stable..."
        curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.appimage
        chmod +x nvim-linux-x86_64.appimage
        sudo mv nvim-linux-x86_64.appimage /usr/local/bin/nvim
        print_success "Neovim installed successfully at /usr/local/bin/nvim!"
    else
        print_warning "Skipping Neovim installation. Please make sure you install Neovim manually."
    fi
fi

# -----------------------------------------------------------------------------
# Step 2: CaskaydiaCove Nerd Font Installation
# -----------------------------------------------------------------------------
print_step "Setting up CaskaydiaCove Nerd Font..."
FONT_DIR="$HOME/.local/share/fonts/CaskaydiaCove"

if fc-list : family | grep -qi "Caskaydia"; then
    print_success "CaskaydiaCove Nerd Font is already installed!"
else
    print_warning "CaskaydiaCove Nerd Font not found. Downloading..."
    mkdir -p "$FONT_DIR"
    
    # Download zip file to a temporary location
    TEMP_ZIP="/tmp/CascadiaCode.zip"
    if curl -fLo "$TEMP_ZIP" "https://github.com/ryanoasis/nerd-fonts/releases/latest/download/CascadiaCode.zip"; then
        print_step "Extracting fonts to $FONT_DIR..."
        unzip -o "$TEMP_ZIP" -d "$FONT_DIR"
        rm "$TEMP_ZIP"
        
        print_step "Updating system font cache..."
        fc-cache -fv &> /dev/null
        print_success "CaskaydiaCove Nerd Font installed successfully!"
    else
        print_error "Failed to download CaskaydiaCove Nerd Font. Skipping font setup."
    fi
fi

# -----------------------------------------------------------------------------
# Step 3: LazyVim & Neovim Configuration Setup
# -----------------------------------------------------------------------------
print_step "Setting up Neovim Configuration..."

# Backup existing Neovim config if present
if [ -d "$HOME/.config/nvim" ]; then
    BACKUP_DIR="$HOME/.config/nvim.bak_$(date +%Y%m%d_%H%M%S)"
    print_warning "Existing Neovim config found at ~/.config/nvim. Backing it up to $BACKUP_DIR..."
    mv "$HOME/.config/nvim" "$BACKUP_DIR"
fi

# Copy Neovim config from repo
mkdir -p "$HOME/.config"
if [ -d "nvim" ]; then
    cp -r nvim "$HOME/.config/"
    print_success "Copied SarVim Neovim configuration to ~/.config/nvim"
else
    print_error "nvim directory not found in the repository. Please make sure you are in the SarVim repo root."
fi

# Install Lazy.nvim without UI
print_step "Installing Lazy.nvim package manager (without UI)..."
mkdir -p "$HOME/.local/share/nvim/lazy"
if [ -d "$HOME/.local/share/nvim/lazy/lazy.nvim" ]; then
    print_warning "Lazy.nvim repository already exists. Updating..."
    git -C "$HOME/.local/share/nvim/lazy/lazy.nvim" pull
else
    git clone https://github.com/folke/lazy.nvim.git --branch=stable "$HOME/.local/share/nvim/lazy/lazy.nvim"
fi
print_success "Lazy.nvim setup complete."

# -----------------------------------------------------------------------------
# Step 4: Tmux Configuration & TPM Setup
# -----------------------------------------------------------------------------
print_step "Setting up Tmux configuration..."

# Copy Tmux config
mkdir -p "$HOME/.config/tmux"
if [ -f "tmux/tmux.conf" ]; then
    cp -r tmux/tmux.conf "$HOME/.config/tmux/tmux.conf"
    print_success "Moved tmux.conf to ~/.config/tmux/tmux.conf"
else
    print_error "tmux/tmux.conf not found in the repository."
fi

# Install Tmux Plugin Manager (TPM)
print_step "Installing Tmux Plugin Manager (TPM)..."
mkdir -p "$HOME/.config/tmux/plugins"
if [ -d "$HOME/.config/tmux/plugins/tpm" ]; then
    print_warning "TPM is already installed. Updating..."
    git -C "$HOME/.config/tmux/plugins/tpm" pull
else
    git clone https://github.com/tmux-plugins/tpm "$HOME/.config/tmux/plugins/tpm"
fi

# Create compatibility symlink to ~/.tmux/plugins/tpm as referenced in tmux.conf
mkdir -p "$HOME/.tmux/plugins"
if [ ! -d "$HOME/.tmux/plugins/tpm" ]; then
    ln -sf "$HOME/.config/tmux/plugins/tpm" "$HOME/.tmux/plugins/tpm"
    print_success "Created compatibility symlink: ~/.tmux/plugins/tpm -> ~/.config/tmux/plugins/tpm"
fi
print_success "TPM installation complete."

# Attempt to source configuration if Tmux is currently running
if [ -n "$TMUX" ]; then
    tmux source-file "$HOME/.config/tmux/tmux.conf" &>/dev/null || true
    print_success "Sourced tmux.conf inside active Tmux session!"
fi

# -----------------------------------------------------------------------------
# Step 5: Alacritty Configuration Setup
# -----------------------------------------------------------------------------
print_step "Setting up Alacritty configuration..."
mkdir -p "$HOME/.config/alacritty"
if [ -f "alacritty/alacritty.toml" ]; then
    # Backup existing alacritty config
    if [ -f "$HOME/.config/alacritty/alacritty.toml" ]; then
        BACKUP_ALACRITTY="$HOME/.config/alacritty/alacritty.toml.bak_$(date +%Y%m%d_%H%M%S)"
        print_warning "Existing Alacritty config found. Backing up to $BACKUP_ALACRITTY..."
        mv "$HOME/.config/alacritty/alacritty.toml" "$BACKUP_ALACRITTY"
    fi
    cp alacritty/alacritty.toml "$HOME/.config/alacritty/alacritty.toml"
    print_success "Alacritty configuration copied to ~/.config/alacritty/alacritty.toml"
else
    print_warning "Alacritty configuration file not found in the repository."
fi

# -----------------------------------------------------------------------------
# Step 6: Git Hook & Configuration Setup
# -----------------------------------------------------------------------------
print_step "Setting up Git Hooks and custom aliases..."
mkdir -p "$HOME/.config/.git_hooks"
if [ -f "git_configurations/post-push.sh" ]; then
    cp git_configurations/post-push.sh "$HOME/.config/.git_hooks/post-push.sh"
    chmod +x "$HOME/.config/.git_hooks/post-push.sh"
    print_success "Git post-push hook copied to ~/.config/.git_hooks/ and made executable."
else
    print_warning "git_configurations/post-push.sh not found in the repository."
fi

# Configure Git hooks path and custom pp alias globally
print_step "Configuring global Git settings..."
git config --global core.hooksPath "$HOME/.config/.git_hooks/"
git config --global alias.pp "!git push \$@ && ~/.config/.git_hooks/post-push.sh"
print_success "Git global config updated with hooksPath and 'pp' alias!"

# Make Neovim dashboard scripts executable
print_step "Making SarVim dashboard scripts executable..."
chmod +x "$HOME/.config/nvim/lua/sarveshtikekar/scripts/"*.sh &>/dev/null || true
print_success "Dashboard scripts are now executable."

# -----------------------------------------------------------------------------
# Step 7: Beautiful Completion & Instructions Output
# -----------------------------------------------------------------------------
echo -e "\n${BOLD}${GREEN}[✓] SarVim development environment setup is complete!${NC}\n"

echo -e "${BOLD}${MAGENTA}======================================================================${NC}"
echo -e "                     ${BOLD}${CYAN}Tmux Configuration Activation${NC}"
echo -e "${BOLD}${MAGENTA}======================================================================${NC}"
echo -e "Since your Tmux configuration is not active yet, Tmux is still listening"
echo -e "for the default prefix: ${BOLD}${YELLOW}Ctrl + b${NC}."
echo -e ""
echo -e "Please follow these steps to activate the new configuration:"
echo -e "  ${BOLD}${CYAN}1.${NC} Open a new Tmux session:"
echo -e "     ${GREEN}cd ~ && tmux${NC}"
echo -e "  ${BOLD}${CYAN}2.${NC} Press ${BOLD}${YELLOW}Ctrl + b${NC}, then immediately press the colon (${BOLD}${YELLOW}:${NC}) key."
echo -e "     This will open the Tmux command prompt at the bottom of the screen."
echo -e "  ${BOLD}${CYAN}3.${NC} Type the following command exactly and press Enter:"
echo -e "     ${GREEN}source-file ~/.config/tmux/tmux.conf${NC}"
echo -e ""
echo -e "Once you press Enter, your custom settings are live!"
echo -e "${BOLD}${YELLOW}Ctrl + b${NC} is now disabled, and the new prefix ${BOLD}${GREEN}Ctrl + a${NC} is active."
echo -e "${BOLD}${MAGENTA}======================================================================${NC}\n"