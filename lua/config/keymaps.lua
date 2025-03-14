-- keymaps.lua
-- Custom key mappings

-- lua/config/keymaps.lua
local opts = { noremap = true, silent = true }

-- Map visual mode Ctrl+C to copy to system clipboard (if not already set)
vim.api.nvim_set_keymap("v", "<C-c>", '"+y', opts)

-- Create a custom user command :F to toggle the file explorer
vim.api.nvim_create_user_command("F", "NvimTreeToggle", { desc = "Toggle File Explorer" })

-- Map Ctrl+F in normal mode to open Telescope's live grep (find function)
vim.api.nvim_set_keymap("n", "<C-f>", ":Telescope live_grep<CR>", opts)

-- Optional: Map K to show hover documentation (if using LSP)
vim.api.nvim_set_keymap("n", "K", ":lua vim.lsp.buf.hover()<CR>", opts)

-- Custom undo/redo mappings:
-- Override default Ctrl+Z (normally suspends process) to undo
vim.api.nvim_set_keymap("n", "<C-z>", "u", opts)
-- Map Ctrl+Shift+Z to redo
vim.api.nvim_set_keymap("n", "<C-S-z>", "<C-r>", opts)


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
