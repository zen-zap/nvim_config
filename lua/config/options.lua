-- lua/config/options.lua
-- Basic options for Neovim

-- Enable mouse support
vim.opt.mouse = "a"

-- Set line numbers and relative numbers
vim.opt.number = true
vim.opt.relativenumber = true

-- Set update time (affects CursorHold, used for LSP hover)
vim.opt.updatetime = 300

-- For GUI clients (e.g., Neovide), set your font here
vim.opt.guifont = "FiraCode Nerd Font:h14" 

-- Enable clipboard support
vim.opt.clipboard = "unnamedplus"  -- Use system clipboard

-- Indentation settings
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.softtabstop = 4
vim.opt.expandtab = true

-- Enable true color support
vim.opt.termguicolors = true

-- Better search behavior: ignore case unless uppercase is used
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- Allow hidden buffers (so you can switch without saving)
vim.opt.hidden = true

-- Configure completion options for a better menu experience
-- UPGRADED FOR NEOVIM 0.12: Added native 'fuzzy' matching
vim.opt.completeopt = { "menuone", "noselect", "noinsert", "fuzzy" }

-- Infinite undo
vim.opt.undofile = true

-- More useful diffs (nvim -d) by ignoring whitespace
vim.opt.diffopt:append('iwhite')

-- Prettier formatter requirement
vim.g.lazyvim_prettier_needs_config = false

-- Disable auto-wrap by default
vim.opt.textwidth = 0
vim.opt.formatoptions:remove({ "c", "t" })

-- Disable unused providers
vim.g.loaded_perl_provider = 0
vim.g.loaded_ruby_provider = 0