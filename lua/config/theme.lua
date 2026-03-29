-- lua/config/theme.lua
-- Theme and transparency settings

vim.cmd("highlight Normal guibg=NONE")

local function apply_custom_opacity()
    -- vim.api.nvim_set_hl(0, "Normal", { bg = "#1e1e2e", blend = 40 }) 
    -- vim.api.nvim_set_hl(0, "NormalNC", { bg = "#1e1e2e", blend = 40 }) 
    -- Use "NONE" so it inherits terminal transparency without clashing with the active theme
    vim.api.nvim_set_hl(0, "Normal", { bg = "NONE", blend = 40 }) 
    vim.api.nvim_set_hl(0, "NormalNC", { bg = "NONE", blend = 40 }) 
end

apply_custom_opacity()

vim.api.nvim_create_autocmd("ColorScheme", {
    pattern = "*",
    callback = apply_custom_opacity,
})