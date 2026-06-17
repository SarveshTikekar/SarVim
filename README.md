<div align="center">
  <img width="1919" height="1023" alt="SarVim Environment Active" src="https://github.com/user-attachments/assets/af95352e-fe7a-440d-b1da-5a8a7027d189" />
  <br> <br>
  <img width="1827" height="968" alt="SarVim Code View" src="https://github.com/user-attachments/assets/5e2c53b7-9a2e-4767-af4c-185729672fff" />
</div>

# SarVim

**SarVim** is a curated, modular, and high-performance development environment configuration for Neovim, Tmux, Kitty/Alacritty, and the Zsh Spaceship Prompt. Designed to prioritize speed, visual clarity, and deep customization control, SarVim avoids bloated prebuilt configurations in favor of a clean, well-documented architecture that serves both as a daily-driver development suite and a learning tool for shell and editor internals.

## Core Philosophy & Learning Goals

SarVim is built from the ground up to facilitate understanding in:
- **Neovim Internals & APIs:** Leveraging Lua-first configurations to control editor behavior.
- **Modular Plugin Architecture:** Structured division of concerns, using headless package management.
- **Environment Integration:** Seamless coordination between shell buffers, window managers (Tmux), and terminal emulators.
- **Workflow Efficiency:** Accelerating transitions to Vim motions and CLI-driven programming.

---

## System Requirements & Prerequisites

For full compatibility and correct rendering of Nerd Fonts, statuslines, and icons, ensure your host environment meets the following specifications:

- **Operating System:** Ubuntu `22.04 LTS` or newer (or equivalent Debian-based distributions).
- **Shell:** [Zsh](https://www.zsh.org/) (Recommended with [Oh My Zsh](https://ohmyz.sh/) for Spaceship integration).
- **Neovim:** `v0.9.0` or newer (Recommended: `v0.10.0+` for modern API capabilities).
- **Tmux:** `v3.3` or newer (Supports advanced terminal passthrough features).
- **Terminal Emulator:** [Alacritty](https://alacritty.org/) or [Kitty](https://sw.kovidgoyal.net/kitty/) (Configs provided for both).
- **Font:** [CaskaydiaCove Nerd Font](https://github.com/ryanoasis/nerd-fonts) (Automated installation included in script).

---

## Automated Setup & Installation

You can automatically set up and configure the entire environment by running the unified installation script:

```bash
git clone https://github.com/SarveshTikekar/SarVim.git && cd SarVim
chmod +x sarvim.sh
./sarvim.sh
```

### Installation Steps Executed by the Script:
1. **System Dependencies:** Checks for and installs standard system tools (`curl`, `git`, `unzip`, `tmux`, `fontconfig`) using the local package manager.
2. **Neovim Auto-Install:** Installs the latest stable Neovim version via AppImage if no existing compatible binary is found.
3. **Typography & Fonts:** Downloads, installs, and registers the **CaskaydiaCove Nerd Font** to the system font directory and refreshes the font cache.
4. **Neovim Configuration:** Backs up any existing configurations in `~/.config/nvim` and deploys SarVim's custom Neovim setup.
5. **Lazy.nvim Bootstrapping:** Installs the package manager headlessly, ready to initialize plugins on first launch.
6. **Tmux Configuration:** Sets up custom window settings, bindings, and installs the **Tmux Plugin Manager (TPM)** to `~/.config/tmux/plugins/tpm`.
7. **Terminal Emulators:** Configures both **Alacritty** (`~/.config/alacritty/alacritty.toml`) and **Kitty** (`~/.config/kitty/kitty.conf`) to optimize rendering, performance, and transparency.
8. **Spaceship Prompt:** Places custom prompt preferences at `~/.config/spaceship.zsh` and configures Zsh to load it.

---

## Post-Installation Verification & Setup

### 1. Activating Tmux Settings
To load the newly installed Tmux settings for the first time:
1. Open a new Tmux session:
   ```bash
   tmux
   ```
2. Open the Tmux command prompt by pressing `Ctrl + b` followed immediately by the colon key (`:`).
3. Type the following command in the prompt at the bottom of the screen and press `Enter`:
   ```tmux
   source-file ~/.config/tmux/tmux.conf
   ```
4. **Fetch Plugins:** Press `Ctrl + a` followed by `Shift + i` (capital `I`) to download and apply `tmux-powerline` along with other plugins.
> [!NOTE]
> Sourcing the custom configuration changes your Tmux prefix key from the default `Ctrl + b` to the more accessible `Ctrl + a`.

### 2. Zsh Spaceship Prompt
If using Zsh, the installer adds the following sourcing instruction to your `~/.zshrc`:
```bash
[ -f "$HOME/.config/spaceship.zsh" ] && source "$HOME/.config/spaceship.zsh"
```
Ensure you reload your shell or source `~/.zshrc` to activate:
```bash
source ~/.zshrc
```

---

## Project Structure & Configuration Map

```
├── alacritty/
│   └── alacritty.toml        # Performance-tuned GPU-accelerated terminal configurations
├── kitty/
│   └── kitty.conf            # Advanced Kitty terminal layout and font adjustments
├── spaceship/
│   └── spaceship.zsh         # Spaceship Zsh theme layout and visual indicator configurations
├── git_configurations/
│   ├── gitconfig.txt         # Custom global git settings
│   └── post-push.sh          # Git post-push hook script
├── nvim/
│   ├── init.lua              # Main Neovim configuration entry point
│   ├── lazy-lock.json        # Pinpoint exact package versions for system stability
│   └── lua/
│       └── sarveshtikekar/
│           ├── autocompletions/
│           │   └── init.lua  # Auto-completion engines and LSP triggers
│           ├── branches/
│           │   └── init.lua  # Statusline Git integration helpers
│           ├── config/
│           │   └── autocmds.lua # Context-specific Neovim autocommands
│           ├── env/
│           │   └── init.lua  # Modular environment and secrets manager
│           ├── landing_page/
│           │   ├── land_page.lua # Startup dashboard UI
│           │   └── quotes.txt    # Integrated dashboard developer quotes
│           ├── language-servers/
│           │   └── lsp.lua   # Code diagnostic engines and LSP hookups
│           ├── lualine_config/
│           │   ├── color_adjuster.lua
│           │   └── init.lua  # Custom statusline visuals and styling rules
│           ├── plugins/
│           │   ├── barbar/   # Buffer management and tab switching mappings
│           │   ├── copilot/  # GitHub Copilot integrations
│           │   ├── cyberdream_theme/ # High-contrast developer visual theme
│           │   ├── forkyou/  # Personal tracking plugin integration
│           │   ├── init.lua  # Declared plugin stack specification
│           │   ├── neoscroll/ # Kinematic and smooth scroll configurations
│           │   └── telescope_ff/ # Advanced fuzzy find module configuration
│           ├── remaps/
│           │   └── remaps.lua # Custom navigation and system hotkeys
│           ├── scripts/      # Activity statistics scripts for custom dashboards
│           ├── stdkeys/
│           │   └── init.lua  # Standard Neovim engine adjustments
│           └── ui/
│               ├── icons.lua # Base unicode icon specifications
│               └── themeList.lua # Palette definitions
├── tmux/
│   └── tmux.conf             # Bindings, window managers, and styling specifications
├── tmux-powerline/
│   ├── config.sh             # Configuration mapping for Tmux visual bars
│   ├── segments/             # Dynamic shell information status indicators
│   └── themes/
│       └── sarvim_theme.sh   # Visual custom styling for Tmux-powerline
├── README.md                 # Project documentation
└── sarvim.sh                 # Unified multi-component setup script
```

---

## Features

- **Decoupled Configuration Design:** Complete Lua module separation keeps customization neat and simple.
- **Modern Terminal Support:** Out-of-the-box support for both GPU-accelerated **Alacritty** and resource-optimized **Kitty** terminal configurations.
- **Tailored Shell Prompt:** Sleek Zsh prompt integration using **Spaceship** configurations to output clean developer states.
- **State-aware Undo Tree:** Custom checkpoints and history navigation mapped on top of Neovim's native persistent undo history.
- **Contextual Statusline:** Customized **Tmux Powerline** with custom widgets for a unified status bar layout across terminal windows.
- **Fuzzy Navigation:** Fast visual navigation built via **Telescope** modules with native FZF capabilities.
- **AI Assist:** Seamless integration with GitHub Copilot for prompt inline completions.
- **Modern Diagnostics:** Subdued inline diagnostics replacing default visual noise.

---

## Upcoming Roadmap

1. **Enhanced Fuzzy Filtering:** Deep search customization with custom tree-sitter integration.
2. **AI Agent Hooks:** Direct integration of interactive LLM coding agents into buffer sessions.
3. **Advanced System Diagnostic Tools:** Expanded status indicators showing system resource details in the statusline.
