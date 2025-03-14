-- lua/config/lazy.lua
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  spec = {
    -- Import LazyVim plugins
    { "LazyVim/LazyVim", import = "lazyvim.plugins" },
    -- Import/override with your custom plugins
    { import = "plugins" },

    -- Directly include the kanagawa plugin
    { 
      "rebelot/kanagawa.nvim",
      lazy = false,  -- Load immediately
      priority = 1000,  -- High priority to load first
      config = function()
        vim.cmd("colorscheme kanagawa-dragon") -- Force apply the colorscheme        
      end
    },
    
    

    -- Add the nvim-tree file explorer plugin (always load)
    { "nvim-tree/nvim-tree.lua", lazy = false, priority = 1000 },

    -- Add devicons for pretty icons
    { "nvim-tree/nvim-web-devicons", opts = {}, lazy = false, priority = 1000 },

    -- Add Telescope for find functionality (you can lazy-load if preferred)
    { "nvim-telescope/telescope.nvim", dependencies = { "nvim-lua/plenary.nvim" } },

    -- Add oldworld.nvim plugin
    -- { "dgox16/oldworld.nvim", lazy = true },
  },
  install = { colorscheme = { "tokyonight", "habamax", "rose-pine", "kanagawa" } },
  checker = { enabled = true, notify = false },
  performance = {
    rtp = {
      disabled_plugins = {
        "gzip",
        "tarPlugin",
        "tohtml",
        "tutor",
        "zipPlugin",
      },
    },
  },
})


vim.defer_fn(function()
  vim.cmd("colorscheme kanagawa-dragon")
end, 0)
