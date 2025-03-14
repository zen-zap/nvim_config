-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

-- options.lua
-- Basic options for Neovim

-- Enable mouse support
vim.opt.mouse = "a"

-- Set line numbers
vim.opt.number = true

-- Set update time (affects CursorHold, used for LSP hover)
vim.opt.updatetime = 300

-- For GUI clients (e.g., Neovide), you can set your font here:
-- vim.opt.guifont = "JetBrainsMono Nerd Font:h14"  -- change the font and size as you like

-- Transparent background for GUI:
-- In a GUI client that supports transparency, you can set:
-- vim.cmd("highlight Normal guibg=NONE")

-- Enable clipboard support
vim.opt.clipboard = "unnamedplus"  -- Use system clipboard

-- Set the width of a tab character to 4 spaces
vim.opt.tabstop = 4

-- Set the number of spaces to use for each step of (auto)indent
vim.opt.shiftwidth = 4

-- Set the number of spaces that a <Tab> counts for while performing editing operations
vim.opt.softtabstop = 4

-- Optional: Convert all tabs to spaces
vim.opt.expandtab = true

vim.opt.guifont = "FiraCode Nerd Font:h14"  -- Adjust the font size as needed

vim.g.colorscheme = "kanagawa-dragon"
