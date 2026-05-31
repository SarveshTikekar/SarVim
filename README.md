<img width="1919" height="1023" alt="image" src="https://github.com/user-attachments/assets/af95352e-fe7a-440d-b1da-5a8a7027d189" />
<br> <br>
<img width="1827" height="968" alt="image" src="https://github.com/user-attachments/assets/5e2c53b7-9a2e-4767-af4c-185729672fff" />

# SarVim

**SarVim** is a custom, lightweight, and high-performance development environment configuration for Neovim and Tmux. It is designed to be clean, modular, and fast, focused on clarity, control, and learning rather than stacking prebuilt configs.

It is built incrementally to understand:
- Neovim internals
- Lua module lifecycle
- Buffer, undo, and state management
- Plugin-grade architecture
- Making a switch to Vim motions and its environment for development

---

## Prerequisites & Dependencies

To ensure all visual features, icons, and statuslines render correctly, your system should meet the following requirements:

*   **Operating System:** Ubuntu `v22.04` or newer (for full modern package compatibility)
*   **Neovim:** `v0.9.0` or newer (Recommended: `v0.10.0+` for full API features)
*   **Tmux:** `v3.3` or newer (Required for features like `allow-passthrough` to work seamlessly)
*   **Terminal Emulator:** [Alacritty](https://alacritty.org/) (Highly recommended for configuration rendering and performance)
*   **Shell:** [Oh My Zsh](https://ohmyz.sh/) (Optional but recommended for standard development experience)
*   **Nerd Font:** [CaskaydiaCove Nerd Font](https://github.com/ryanoasis/nerd-fonts) (Automatically installed by the setup script)

---

## Quick Start & Installation

Setting up SarVim is fully automated. Run the unified setup script on your Ubuntu PC:

```bash
git clone https://github.com/SarveshTikekar/SarVim.git && cd SarVim
./sarvim.sh
```

### What the Script Does:
1.  **Dependency Verification:** Checks for and installs standard system tools (`curl`, `git`, `unzip`, `tmux`, `fontconfig`) if missing.
2.  **Neovim Check:** Installs Neovim stable via AppImage if not already installed.
3.  **CaskaydiaCove Nerd Font:** Downloads, installs, and updates the system font cache automatically.
4.  **Neovim Config Setup:** Backs up your existing Neovim config (`~/.config/nvim`) and copies the SarVim Neovim configuration.
5.  **Lazy.nvim Bootstrapping:** Installs the headless plugin manager (`lazy.nvim`) without UI prompts.
6.  **Tmux Configuration:** Sets up `tmux.conf` at `~/.config/tmux/tmux.conf` and installs the **Tmux Plugin Manager (TPM)**, resolving configuration paths automatically.

---

## Tmux Post-Installation Setup

Once the script finishes, you need to manually load your new Tmux settings for the first time:

1.  **Open a new Tmux session:**
    ```bash
    cd ~ && tmux
    ```
2.  **Open the Tmux command prompt:**
    Press `Ctrl + b` followed immediately by the colon key (`:`).
3.  **Source the configuration file:**
    Type the following command in the prompt at the bottom of the screen and press `Enter`:
    ```tmux
    source-file ~/.config/tmux/tmux.conf
    ```
4.  **Install Tmux Plugins:**
    Press your new prefix `Ctrl + a`, then capital `I` (i.e. `Ctrl + a` followed by `Shift + i`) to fetch and install `tmux-powerline` and other plugins.

> [!NOTE]
> Sourcing the file disables the default prefix `Ctrl + b` and activates the custom prefix `Ctrl + a`.

---

## Project Structure

```
├── alacritty
│   └── alacritty.toml        # Alacritty terminal configuration
├── git_configurations
│   ├── gitconfig.txt         # Global Git configurations
│   └── post-push.sh          # Git post-push hook script
├── nvim
│   ├── init.lua              # Neovim main entry point
│   ├── lazy-lock.json        # Lazy.nvim plugin lockfile
│   └── lua
│       └── sarveshtikekar
│           ├── autocompletions
│           │   └── init.lua  # Auto-completion setup
│           ├── branches
│           │   └── init.lua  # Git branch integration statusline helper
│           ├── config
│           │   └── autocmds.lua # Neovim autocommands
│           ├── env
│           │   └── init.lua  # Centralised environment / secrets loader
│           ├── landing_page
│           │   ├── land_page.lua # Startup dashboard rendering
│           │   └── quotes.txt    # Dashboard quotes
│           ├── language-servers
│           │   └── lsp.lua   # Language Server Protocol settings
│           ├── lualine_config
│           │   ├── color_adjuster.lua
│           │   └── init.lua  # Lualine statusline configuration
│           ├── plugins
│           │   ├── barbar
│           │   │   ├── init.lua   # Bufferline plugin setup
│           │   │   └── remaps.lua # Bufferline keymaps
│           │   ├── copilot
│           │   │   └── init.lua   # GitHub Copilot integration
│           │   ├── cyberdream_theme
│           │   │   └── init.lua   # Main UI theme config
│           │   ├── forkyou
│           │   │   └── init.lua   # ForkYou.nvim dev-tracker integration
│           │   ├── init.lua       # Plugin specifications list
│           │   ├── neoscroll
│           │   │   └── init.lua   # Smooth scrolling plugin setup
│           │   └── telescope_ff
│           │       ├── init.lua   # Telescope fuzzy finder config
│           │       └── remaps.lua # Telescope keymaps
│           ├── remaps
│           │   └── remaps.lua # Custom Neovim keymaps
│           ├── scripts
│           │   ├── commits_till_date.sh
│           │   ├── commits_today.sh
│           │   ├── dominant_languages.sh
│           │   ├── init.lua  # Statistics collection runner
│           │   ├── stats
│           │   │   └── stat-log.txt
│           │   └── streak_count.sh
│           ├── stdkeys
│           │   └── init.lua  # General Neovim options & standard settings
│           └── ui
│               ├── icons.lua     # General icon symbols config
│               └── themeList.lua # Lists of available themes
├── README.md
├── sarvim.sh                 # Unified installation/setup script
├── tmux
│   └── tmux.conf             # Custom Tmux configuration
└── tmux-powerline
    ├── config.sh             # Tmux-powerline global config
    ├── segments              # Custom status-bar segment scripts
    │   ├── basename.sh
    │   ├── clock_logo.sh
    │   ├── directory_logo.sh
    │   └── tmux_logo.sh
    └── themes
        └── sarvim_theme.sh   # Custom SarVim tmux-powerline theme
```

---

## Current Features

- Custom keymaps written from scratch
- Checkpoints built on top of Neovim's undo tree
- Two types of developer focus themes
- Lazy.nvim plugin manager (headless, without UI)
- Clean Lua module separation with dedicated plugin sub-directories
- Transparent backgrounds for Neovim and Tmux
- Multiple file/buffer tabbing via Barbar in a single Tmux window/pane
- **Telescope fuzzy finder** — fast file/buffer search with FZF native backend, refactored into its own module (`telescope_ff`)
- **GitHub Copilot** — AI inline completions via `copilot.vim`
- **ForkYou.nvim** — developer activity tracker integrated with forkyou.dev, driven by a centralised `env` secrets module
- **Custom tmux-powerline theme** — `sarvim_theme.sh` with bespoke segments (clock, directory, tmux logo, basename)
- Tiny-inline diagnostics replacing default virtual-text LSP output

---

## Upcoming Features

1. Advanced Fuzzy finding and Searching
2. AI Tools / Agents Integration
3. Integration with Kitty Terminal for Arch Linux (Unconfirmed)
