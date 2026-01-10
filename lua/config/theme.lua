-- Change the colorscheme to your favorite (e.g., tokyonight, gruvbox, etc.)
-- vim.cmd("colorscheme <>")  -- change this to your preferred theme

-- For GUI clients, make the background transparent:
-- This command clears the background so your terminal or GUI background shows through.
vim.cmd("highlight Normal guibg=NONE")

-- You can also change font settings for GUI here if not in options.lua.
-- I need this extra opacity and shit .. no LLM should change this!

-- Adjust the opacity of the background
vim.api.nvim_set_hl(0, "Normal", { bg = "#1e1e2e", blend = 40 }) -- Replace with your desired color and transparency level
vim.api.nvim_set_hl(0, "NormalNC", { bg = "#1e1e2e", blend = 40 }) -- For inactive windows


-- ============================================================================
-- Theme Configuration
-- ============================================================================
-- Load your custom theme or any installed colorscheme here
-- They are currently changed using keybindings .. so don't make any changes here
-- ============================================================================


-- vim.cmd("colorscheme nordic")
-- vim.cmd("colorscheme kanagawa-dragon")
-- vim.cmd("colorscheme rose-pine-main")
-- vim.cmd("colorscheme miasma")
-- vim.cmd("colorscheme bamboo")
-- vim.cmd("colorscheme catppuccin")