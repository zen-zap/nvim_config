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
vim.cmd("highlight Normal guibg=NONE")

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

vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, { noremap = true, silent = true, buffer = bufnr })

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

-- case-insensitive search/replace
vim.opt.ignorecase = true

-- unless uppercase in search term
vim.opt.smartcase = true

-- more useful diffs (nvim -d)
--- by ignoring whitespace
vim.opt.diffopt:append('iwhite')

-- Jump to start and end of line using the home row keys
vim.keymap.set('', 'H', '^')
vim.keymap.set('', 'L', '$')

-- highlight yanked text
vim.api.nvim_create_autocmd(
	'TextYankPost',
	{
		pattern = '*',
		command = 'silent! lua vim.highlight.on_yank({ timeout = 500 })'
	}
)

-- jump to last edit position on opening file
vim.api.nvim_create_autocmd(
	'BufReadPost',
	{
		pattern = '*',
		callback = function(ev)
			if vim.fn.line("'\"") > 1 and vim.fn.line("'\"") <= vim.fn.line("$") then
				-- except for in git commit messages
				-- https://stackoverflow.com/questions/31449496/vim-ignore-specifc-file-in-autocommand
				if not vim.fn.expand('%:p'):find('.git', 1, true) then
					vim.cmd('exe "normal! g\'\\""')
				end
			end
		end
	}
)

-- prevent accidental writes to buffers that shouldn't be edited
vim.api.nvim_create_autocmd('BufRead', { pattern = '*.orig', command = 'set readonly' })
vim.api.nvim_create_autocmd('BufRead', { pattern = '*.pacnew', command = 'set readonly' })
-- leave paste mode when leaving insert mode (if it was on)
vim.api.nvim_create_autocmd('InsertLeave', { pattern = '*', command = 'set nopaste' })

