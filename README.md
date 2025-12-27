
<img width="1363" height="691" alt="image" src="https://github.com/user-attachments/assets/ab285877-6b05-45d7-9bba-869eb731fb0b" />

## 🚀 About

**SarVim** is my personal Neovim + Tmux setup focused on **clarity, control, and learning** rather than stacking prebuilt configs.

It is built incrementally to understand:
- Neovim internals
- Lua module lifecycle
- buffer, undo, and state management
- plugin-grade architecture
- Making a switch to Vim motions and its environment for development
---

## ✨ Features (WIP)

- ⚙️ Custom keymaps written from scratch
- ⏱️ Checkpoints built on top of Neovim’s undo tree
- 🎨 Random & toggleable themes
- 📦 Lazy vim plugin manager (Without UI)
- 🧠 Clean Lua module separation

---

<h1> File Tree Structure </h1>

```
├── nvim
│   ├── init.lua (Main Enrty to our Nvim setup)
│   ├── lazy-lock.json
│   └── lua
│       └── sarveshtikekar
│           ├── autocompletions
│           │   └── init.lua
│           ├── branches
│           │   └── init.lua
│           ├── landing_page
│           │   ├── land_page.lua
│           │   └── quotes.txt
│           ├── lsp.lua
│           ├── lualine_config
│           │   ├── color_adjuster.lua
│           │   └── init.lua
│           ├── plugins
│           │   └── init.lua
│           ├── remaps.lua
│           ├── stdkeys
│           │   └── init.lua
│           └── themeList
│               └── init.lua
├── README.md
└── tmux
    └── tmux.conf (My Tmux config)


```
<h1> Installation </h1>

```
git clone https://github.com/SarveshTikekar/SarVim.git && cd SarVim
git checkout Version1
cp -r nvim/ ~/.config/
```

<h1> For LazyVim installation without UI </h1>

```
cd ~
mkdir -p ~/.local/share/nvim/lazy
git clone https://github.com/folke/lazy.nvim.git --branch=stable ~/.local/share/nvim/lazy/lazy.nvim
```
<h1> For setting up Tmux </h1>
<h3> Step 1: Installing tmux </h3>

```
sudo apt update && sudo apt install tmux
```

<h3> Step 2: Moving the conf file to appropriate destination </h3>

```
mkdir -p ~/.config/tmux
cd ~/SarVim/
cp -r tmux/tmux.conf ~/.config/tmux/tmux.conf
```
<h3> Step 3: Installing Tmux plugin Manager (TPM) </h3>

```
mkdir -p ~/.config/tmux/plugins
git clone https://github.com/tmux-plugins/tpm ~/.config/tmux/plugins/tpm
```

<h3> Step 4: Opening a Tmux session </h3>

```
cd ~ && tmux 
```
* Since your configuration isn't active yet, tmux is still listening for the default prefix: <b> Ctrl + b </b>
* Press Ctrl + b, then immediately press the colon (:) key, which opens the command prompt at the bottom of the screen.
  
<h3> Step 5: Sourcing the tmux.conf file </h3>
* Type the following command exactly in cmd prompt and press Enter

```
source-file ~/.config/tmux/tmux.conf
```
* Once you hit Enter, your custom settings are live. Ctrl + b is now disabled, and the new prefix Ctrl + a is active.
