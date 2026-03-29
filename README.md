# Neovim Config

<a href="https://dotfyle.com/zen-zap/nvimconfig"><img src="https://dotfyle.com/zen-zap/nvimconfig/badges/plugins?style=for-the-badge" /></a>
<a href="https://dotfyle.com/zen-zap/nvimconfig"><img src="https://img.shields.io/badge/LEADERKEY-space-22c55e?style=for-the-badge&labelColor=1e40af&logo=neovim&logoColor=green" /></a>
<a href="https://dotfyle.com/zen-zap/nvimconfig"><img src="https://dotfyle.com/zen-zap/nvimconfig/badges/plugin-manager?style=for-the-badge" /></a>

## Install Instructions

> Install requires Neovim 0.12+. Always review the code before installing a configuration.

Clone the repository and install the plugins:

```sh
git clone git@github.com:zen-zap/nvim_config ~/.config/zen-zap/nvim_config
```

Open Neovim with this config:

```sh
NVIM_APPNAME=zen-zap/nvim_config/ nvim
```

## Plugins

This configuration uses the `folke/lazy.nvim` plugin manager. Plugins are organized by purpose and set up in `lua/plugins/init.lua`; most are lazy‑loaded automatically.

### Colorschemes

- `AlexvZyl/nordic.nvim`, `rebelot/kanagawa.nvim`, `olivercederborg/poimandres.nvim`, `rose-pine/neovim`, `sainnhe/sonokai`, `sainnhe/everforest`, `folke/tokyonight.nvim`
- Additional themes are included for quick cycling (`catppuccin`, `bamboo.nvim`, `oldworld.nvim`, `miasma.nvim`, `embark`, `gruber-darker`, `mellifluous`, `monochrome`, `evergarden`, etc.)
- Use `<leader>cs` to cycle schemes or `<leader>ct` to pick with Telescope (see **Keybindings** below).

### Completion & Snippets

- `hrsh7th/nvim-cmp` with sources for LSP, buffers, and paths.
- Uses native Neovim snippets (no `vsnip`).

### LSP & Language tooling

- `neovim/nvim-lspconfig` with helper plugins like `j-hui/fidget.nvim` (progress UI) and built‑in support for ESLint, Ruff, and others.

### Treesitter & Syntax

- `nvim-treesitter/nvim-treesitter` (configured to install Rust, RON, C/C++, Java, JSON5, Bash, Lua, Vimscript, Markdown, etc.).

### UI Enhancements

- `akinsho/bufferline.nvim` (buffer tabs)
- `nvim-lualine/lualine.nvim` (statusline, theme-aware)
- `folke/noice.nvim` (improved command line and LSP documentation)
- `karb94/neoscroll.nvim` (smooth scrolling)
- `RRethy/vim-illuminate` (highlight word under cursor)
- `windwp/nvim-autopairs` (auto‑closing brackets/quotes)
- `folke/which-key.nvim` (leader‑key cheat sheet)
- `nvim-telescope/telescope.nvim` & `nvim-lua/plenary.nvim` (fuzzy finder)

### File Explorer & Icons

- `nvim-tree/nvim-tree.lua` (file tree with git highlighting)
- `nvim-tree/nvim-web-devicons` (file icons)
- `echasnovski/mini.nvim` (`mini.icons` for icon-provider compatibility)

### Indent & Motion

- `lukas-reineke/indent-blankline.nvim` (indent guides)
- `leap.nvim` from Codeberg (`https://codeberg.org/andyg/leap.nvim`)
- `andymass/vim-matchup` (improved `%` matching)

### Git

- `lewis6991/gitsigns.nvim` (git decorations & hunk actions)

### Development Helpers

- `nvim-neotest/nvim-nio` (test runner integration)
- `j-hui/fidget.nvim` (LSP progress)
- `nvim-lua/plenary.nvim`, `MunifTanjim/nui.nvim` (utilities used by other plugins)

Many of the color/theme plugins and extras are loaded lazily; you can inspect or add your own by editing `lua/plugins/init.lua`.

## Keybindings

Leader key is set to `<Space>` throughout the configuration (see `lua/config/keymaps.lua`).

- **File navigation:** `<leader>f` find files, `<leader>g` live grep, `<leader>b` open buffers, `<leader>?` help tags.
- **LSP:** `<leader>s` search workspace symbols, `<leader>rn` rename, `gd` go to definition, `K` hover, `[d`/`]d` navigate diagnostics.
- **Colorschemes:** `<leader>cs` cycle, `<leader>ct` choose with Telescope.
- **Window management:** `<leader>-`/`|` to split, `<leader>h/j/k/l` move between splits, `<leader>wd` close, `<leader>tw` toggle auto‑wrap.
- **Buffers:** `L`/`H` cycle next/prev buffer (bufferline integration).
- **File tree:** `<leader>tt` toggle NvimTree.
- **Debugging (DAP):** `<F5>` continue, `<F10>` step over, `<F11>` step into, `<F12>` step out, `<leader>db` toggle breakpoint, `<leader>dr` open REPL, `<leader>du` toggle UI.
- **Terminal:** `<C-S-c>` kills current terminal job.
- **Utils:** `<C-s>` save, `<leader>q` quit, `<leader>Q` quit all!, `<leader><space>` clear search, `<leader>e` select inner word, `<leader>m` change till underscore.

> See the full list of mappings and helper comments in `lua/config/keymaps.lua`.

## Language Servers

Servers are started automatically if their executables are found on the system. The configuration includes sensible defaults, per‑language behaviors (inlay hints, format‑on‑save, etc.) and root detection logic.

Supported/recognized servers:

- `rust-analyzer` – Rust
- `jdtls` – Java
- `clangd` – C/C++/Objective‑C/ CUDA
- `typescript-language-server` – JavaScript/TypeScript and React
- `vscode-eslint-language-server` – ESLint integration for JS/TS/Vue/Svelte
- `pyright-langserver` – Python
- `ruff` – Python linting/formatting
- `lua-language-server` – Lua (configured for Neovim runtime)
- `bash-language-server` – shell scripts
- `yaml-language-server` – YAML files
- `gopls` – Go (with workspace module awareness)

> You can extend or override these settings by editing `lua/config/lsp.lua`.

## Installation Notes

- Requires **Neovim 0.12+**.
- Clone the repo:

```sh
git clone git@github.com:zen-zap/nvim_config ~/.config/zen-zap/nvim_config
```

- Launch with custom appname so config directory is used:

```sh
NVIM_APPNAME=zen-zap/nvim_config/ nvim
```

- External language servers (rust-analyzer, jdtls, clangd, etc.) must be installed and on your `$PATH` for LSP support to activate.
- For Treesitter health checks and parser tooling, install `tree-sitter-cli` (`npm i -g tree-sitter-cli`).
- For C/C++ debugging with DAP, install `codelldb` (e.g. via `:MasonInstall codelldb`).
- This config is built on top of **LazyVim**; additional options are in `lua/config/options.lua` and can be tweaked as needed.

---

*Hope you have a good time with this. Configuration should work out of the box with minimal tweaks.*
