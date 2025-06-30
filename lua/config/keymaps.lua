-- keymaps.lua
-- Custom key mappings

vim.g.mapleader = " " -- Set leader key to space

-- lua/config/keymaps.lua
local opts = { noremap = true, silent = true }

-- Map K to show hover documentation (if using LSP)
vim.keymap.set("n", "K", vim.lsp.buf.hover, { desc = "LSP Hover" })

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
vim.keymap.set("n", "<leader>?", builtin.help_tags, { noremap = true, silent = true, desc = "Help Tags" })



-- Map leader + s to search LSP symbols (useful for functions, classes, etc.)
vim.keymap.set("n", "<leader>s", builtin.lsp_dynamic_workspace_symbols, { noremap = true, silent = true, desc = "Search LSP Symbols" })

vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, { desc = "LSP Rename" })



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

-- Enhanced Colorscheme switcher with preview
local colorschemes = {
  "poimandres",
  "kanagawa-dragon", 
  "nordic",
  "sonokai",
  "everforest",
  "rose-pine",
  "tokyonight"
}

local current_colorscheme = 2 
-- Start with "kanagawa-dragon" -- there is previous select memory, so it will start with the last used colorscheme

-- Cycle through colorschemes
vim.keymap.set("n", "<leader>cs", function()
  current_colorscheme = current_colorscheme % #colorschemes + 1
  vim.cmd.colorscheme(colorschemes[current_colorscheme])
  print("Colorscheme: " .. colorschemes[current_colorscheme])
end, { desc = "Cycle Colorscheme" })

-- Telescope colorscheme picker with live preview
vim.keymap.set("n", "<leader>ct", function()
  require("telescope.builtin").colorscheme({
    enable_preview = true,
    results_title = "Available Colorschemes",
    prompt_title = "Select Colorscheme",
  })
end, { desc = "Choose Colorscheme (Telescope)" })

-- Add these at the end of your keymaps file

-- File tree toggle
vim.keymap.set("n", "<leader>t", ":NvimTreeToggle<CR>", { desc = "Toggle File Tree" })

-- DAP (Debugging) keymaps
vim.keymap.set("n", "<F5>", function() require("dap").continue() end, { desc = "DAP Continue" })
vim.keymap.set("n", "<F10>", function() require("dap").step_over() end, { desc = "DAP Step Over" })
vim.keymap.set("n", "<F11>", function() require("dap").step_into() end, { desc = "DAP Step Into" })
vim.keymap.set("n", "<F12>", function() require("dap").step_out() end, { desc = "DAP Step Out" })
vim.keymap.set("n", "<leader>db", function() require("dap").toggle_breakpoint() end, { desc = "DAP Toggle Breakpoint" })
vim.keymap.set("n", "<leader>dr", function() require("dap").repl.open() end, { desc = "DAP Open REPL" })
vim.keymap.set("n", "<leader>du", function() require("dapui").toggle() end, { desc = "DAP Toggle UI" })

-- Quick save
vim.keymap.set("n", "<C-s>", ":w<CR>", { desc = "Save File" })
vim.keymap.set("i", "<C-s>", "<Esc>:w<CR>a", { desc = "Save File" })

-- Quick quit
vim.keymap.set("n", "<leader>q", ":q<CR>", { desc = "Quit" })
vim.keymap.set("n", "<leader>Q", ":qa!<CR>", { desc = "Quit All Force" })

-- Better indenting
vim.keymap.set("v", "<", "<gv", { desc = "Indent Left" })
vim.keymap.set("v", ">", ">gv", { desc = "Indent Right" })

-- Move text up and down
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move Selection Down" })
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv", { desc = "Move Selection Up" })

-- Clear search highlighting
vim.keymap.set("n", "<leader><space>", ":nohlsearch<CR>", { desc = "Clear Search Highlight" })