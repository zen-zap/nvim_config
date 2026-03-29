-- lua/config/colorscheme.lua

local function load_last_colorscheme()
    local file = vim.fn.stdpath("data") .. "/last_colorscheme"
    local f = io.open(file, "r")
    local loaded_successfully = false

    if f then
        local cs = f:read("*l")
        f:close()
        if cs and cs ~= "" then
            loaded_successfully = pcall(vim.cmd, "colorscheme " .. cs)
        end
    end
    
    if not loaded_successfully then
        pcall(vim.cmd, "colorscheme ashen")
    end
end

local function save_colorscheme()
    local cs = vim.g.colors_name or "ashen"
    local file = vim.fn.stdpath("data") .. "/last_colorscheme"
    local f = io.open(file, "w")
    if f then
        f:write(cs)
        f:close()
    end
end

load_last_colorscheme()

-- Save the current colorscheme before exiting
vim.api.nvim_create_autocmd("VimLeavePre", {
    callback = save_colorscheme,
})