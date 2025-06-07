-- keymaps.lua
-- Custom key mappings

vim.g.mapleader = " " -- Set leader key to space

-- lua/config/keymaps.lua
local opts = { noremap = true, silent = true }

-- Optional: Map K to show hover documentation (if using LSP)
vim.api.nvim_set_keymap("n", "K", ":lua vim.lsp.buf.hover()<CR>", opts)

-- Jump to start and end of line using the home row keys
vim.keymap.set('', 'H', '^')
vim.keymap.set('', 'L', '$')

vim.keymap.set("n", "<Home>", "^", { noremap = true, silent = true })
vim.keymap.set("i", "<Home>", "<C-o>^", { noremap = true, silent = true })


-- In terminal mode, map Ctrl+Shift+C to kill the current terminal job
-- First, define a helper function to kill the terminal job:
function _G.kill_terminal_job()
  -- Check if the current buffer is a terminal
  if vim.bo.buftype == "terminal" then
    local job = vim.b.terminal_job_id
    if job then
      vim.fn.jobstop(job)
      print("Terminal job killed")
    else
      print("No terminal job found")
    end
  else
    print("Not in a terminal buffer")
  end
end

-- Map <C-S-c> in terminal mode (t mode) to call the function:
vim.api.nvim_set_keymap("t", "<C-S-c>", "<C-\\><C-n>:lua kill_terminal_job()<CR>", opts)
-- OPTIONAL: Map K in normal mode to show documentation on hover
-- This will call the LSP hover function.
vim.api.nvim_set_keymap("n", "K", ":lua vim.lsp.buf.hover()<CR>", opts)
-- Map Ctrl+Shift+Up to start Visual Block mode and select upwards
vim.api.nvim_set_keymap('n', '<C-S-Up>', '<C-v>k', { noremap = true, silent = true })
-- Map Ctrl+Shift+Down to start Visual Block mode and select downwards
vim.api.nvim_set_keymap('n', '<C-S-Down>', '<C-v>j', { noremap = true, silent = true })
-- type viw to select the current word
vim.api.nvim_set_keymap('n', '<Leader>e', 'viw', { noremap = true, silent = true })



-- FOR SETTING UP TELESCOPE KEYBINDINGS
local builtin = require("telescope.builtin")
-- Map leader + f to find files
vim.keymap.set("n", "<leader>f", builtin.find_files, { noremap = true, silent = true, desc = "Find Files" })
-- Map leader + g to live grep (search text across files)
vim.keymap.set("n", "<leader>g", builtin.live_grep, { noremap = true, silent = true, desc = "Live Grep" })
-- Map leader + b to list open buffers
vim.keymap.set("n", "<leader>b", builtin.buffers, { noremap = true, silent = true, desc = "List Buffers" })
-- Map leader + h to search help tags
vim.keymap.set("n", "<leader>h", builtin.help_tags, { noremap = true, silent = true, desc = "Help Tags" })



-- Map leader + s to search LSP symbols (useful for functions, classes, etc.)
vim.keymap.set("n", "<leader>s", builtin.lsp_dynamic_workspace_symbols, { noremap = true, silent = true, desc = "Search LSP Symbols" })

vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, { noremap = true, silent = true, buffer = bufnr })



-- handy keymap for replacing up to next _ (like in variable names)
vim.keymap.set('n', '<leader>m', 'ct_')
-- F1 is pretty close to Esc, so you probably meant Esc
vim.keymap.set('', '<F1>', '<Esc>')
vim.keymap.set('i', '<F1>', '<Esc>')

-- Key mappings for window management
vim.keymap.set("n", "<leader>-", "<C-W>s", { desc = "Split Window Below", remap = true })
vim.keymap.set("n", "<leader>|", "<C-W>v", { desc = "Split Window Right", remap = true })
vim.keymap.set("n", "<leader>wd", "<C-W>c", { desc = "Delete Window", remap = true })

vim.keymap.set("n", "<leader>h", "<C-w>h", { desc = "Move to Left Split" })
vim.keymap.set("n", "<leader>j", "<C-w>j", { desc = "Move to Below Split" })
vim.keymap.set("n", "<leader>k", "<C-w>k", { desc = "Move to Above Split" })
vim.keymap.set("n", "<leader>l", "<C-w>l", { desc = "Move to Right Split" })

vim.keymap.set("n", "<leader>w", function()
  if vim.opt.textwidth:get() == 0 then
    vim.opt.textwidth = 80
    vim.opt.formatoptions:append({ "c", "t" })
    print("Auto-wrap enabled")
  else
    vim.opt.textwidth = 0
    vim.opt.formatoptions:remove({ "c", "t" })
    print("Auto-wrap disabled")
  end
end, { desc = "Toggle auto-wrap" })