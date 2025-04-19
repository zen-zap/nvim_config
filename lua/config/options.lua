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

vim.opt.termguicolors = true

-- Better search behavior: ignore case unless uppercase is used
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- Allow hidden buffers (so you can switch without saving)
vim.opt.hidden = true

-- Configure completion options for a better menu experience
vim.opt.completeopt = { "menuone", "noselect", "noinsert" }

-- Enable relative line numbers (great for motion commands)
vim.opt.relativenumber = true

-- infinite undo
vim.opt.undofile = true

-- more useful diffs (nvim -d)
--- by ignoring whitespace
vim.opt.diffopt:append('iwhite')

-- Key mappings for window management
vim.keymap.set("n", "<leader>-", "<C-W>s", { desc = "Split Window Below", remap = true })
vim.keymap.set("n", "<leader>|", "<C-W>v", { desc = "Split Window Right", remap = true })
vim.keymap.set("n", "<leader>wd", "<C-W>c", { desc = "Delete Window", remap = true })