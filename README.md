
<img width="1366" height="706" alt="image" src="https://github.com/user-attachments/assets/80e8f703-98ba-4d06-bb37-39cc84703689" />

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
├── init.lua (Main entry point when nvim gets loaded)
├── lazy-lock.json
└── lua
    └── sarveshtikekar
        ├── branches.lua
        ├── checkpts.lua
        ├── landing_page
        │   └── land_page.lua
        ├── lsp.lua
        ├── plugins
        │   └── init.lua
        ├── remaps.lua
        ├── stdkeys
        │   └── init.lua
        └── themeList
            └── init.lua
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
