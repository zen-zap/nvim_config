-- lua/config/theme.lua
-- Theme and transparency settings

vim.cmd("highlight Normal guibg=NONE")

local function apply_custom_opacity()
    local function transparent_group(name)
        local ok, hl = pcall(vim.api.nvim_get_hl, 0, { name = name, link = false })
        if not ok then
            return
        end

        hl.bg = nil
        hl.ctermbg = nil
        hl.blend = 40
        vim.api.nvim_set_hl(0, name, hl)
    end

    transparent_group("Normal")
    transparent_group("NormalNC")
end

apply_custom_opacity()

vim.api.nvim_create_autocmd("ColorScheme", {
    pattern = "*",
    callback = apply_custom_opacity,
})