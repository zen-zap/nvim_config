-- lua/config/theme.lua
-- Theme and transparency settings

-- Clear the background so your terminal/GUI background shows through
vim.cmd("highlight Normal guibg=NONE")

-- Wrap your strict opacity settings in a function
local function apply_custom_opacity()
    -- Opacity values are not to be changed (at least for me).
    vim.api.nvim_set_hl(0, "Normal", { bg = "#1e1e2e", blend = 40 }) 
    vim.api.nvim_set_hl(0, "NormalNC", { bg = "#1e1e2e", blend = 40 }) 
end

-- 1. Apply immediately on startup
apply_custom_opacity()

-- 2. Apply automatically EVERY time you cycle colorschemes with <leader>cs
vim.api.nvim_create_autocmd("ColorScheme", {
    pattern = "*",
    callback = apply_custom_opacity,
})