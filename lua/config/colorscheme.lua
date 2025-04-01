local function load_last_colorscheme()
    local file = vim.fn.stdpath("data") .. "/last_colorscheme"
    local f = io.open(file, "r")
    if f then
      local cs = f:read("*l")
      f:close()
      if cs and cs ~= "" then
        vim.cmd("colorscheme " .. cs)
      end
    end
  end
  
  local function save_colorscheme()
    local cs = vim.g.colors_name or ""
    local file = vim.fn.stdpath("data") .. "/last_colorscheme"
    local f = io.open(file, "w")
    if f then
      f:write(cs)
      f:close()
    end
  end
  
  -- Restore the last used colorscheme on startup
  load_last_colorscheme()
  
  -- Save the current colorscheme before exiting
  vim.api.nvim_create_autocmd("VimLeavePre", {
    callback = save_colorscheme,
  })
  