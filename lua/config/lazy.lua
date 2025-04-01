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
    
    -- Import/override with your custom plugins
    { import = "plugins" },

    -- Directly include the kanagawa plugin
    { 
      "rebelot/kanagawa.nvim",
      lazy = false,  -- Load immediately
      priority = 1000,  -- High priority to load first
      config = function()
        -- vim.cmd("colorscheme kanagawa-dragon") -- Force apply the colorscheme        
      end
    },

    -- Add nvim-lspconfig explicitly
    {
      "neovim/nvim-lspconfig",
      lazy = false, -- Load immediately if you want
    },
    
    -- Add the nvim-tree file explorer plugin (always load)
    { "nvim-tree/nvim-tree.lua", lazy = false, priority = 1000 },

    -- Add devicons for pretty icons
    { "nvim-tree/nvim-web-devicons", opts = {}, lazy = false, priority = 1000 },

    -- Add Telescope for find functionality (you can lazy-load if preferred)
    { "nvim-telescope/telescope.nvim", dependencies = { "nvim-lua/plenary.nvim" } },

    {
      "folke/noice.nvim",
      dependencies = { "MunifTanjim/nui.nvim" },
      config = function()
        require("noice").setup({
          lsp = {
            override = {
              ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
              ["vim.lsp.util.stylize_markdown"] = true,
              ["cmp.entry.get_documentation"] = true,
            },
          },
          presets = {
            command_palette = true,       -- Enable a command palette-style UI
            long_message_to_split = true,   -- Split long messages into a separate window
            lsp_doc_border = true,          -- Add borders to LSP documentation popups
          },
        })
      end,
    },

    {
      'shaunsingh/nord.nvim',
      lazy = false,
      priority = 1000,
      config = function ()
          vim.cmd('colorscheme nord')
      end
    },

    {
      'AlexvZyl/nordic.nvim',
      lazy = false,
      priority = 1000,
      config = function()
        require('nordic').setup({
          -- This callback can be used to override the colors used in the base palette.
          on_palette = function(palette) end,
          -- This callback can be used to override the colors used in the extended palette.
          after_palette = function(palette) end,
          -- This callback can be used to override highlights before they are applied.
          on_highlight = function(highlights, palette) end,
          -- Enable bold keywords.
          bold_keywords = false,
          -- Enable italic comments.
          italic_comments = true,
          -- Enable editor background transparency.
          transparent = {
              -- Enable transparent background.
              bg = true,
              -- Enable transparent background for floating windows.
              float = true,
          },
          -- Enable brighter float border.
          bright_border = false,
          -- Reduce the overall amount of blue in the theme (diverges from base Nord).
          reduced_blue = true,
          -- Swap the dark background with the normal one.
          swap_backgrounds = false,
          -- Cursorline options.  Also includes visual/selection.
          cursorline = {
              -- Bold font in cursorline.
              bold = false,
              -- Bold cursorline number.
              bold_number = true,
              -- Available styles: 'dark', 'light'.
              theme = 'dark',
              -- Blending the cursorline bg with the buffer bg.
              blend = 0.85,
          },
          noice = {
              -- Available styles: `classic`, `flat`.
              style = 'classic',
          },
          telescope = {
              -- Available styles: `classic`, `flat`.
              style = 'flat',
          },
          leap = {
              -- Dims the backdrop when using leap.
              dim_backdrop = true,
          },
          ts_context = {
              -- Enables dark background for treesitter-context window
              dark_background = true,
          }
      })
        vim.cmd.colorscheme('nordic')
      end
    },

    {
      'sainnhe/sonokai',
      lazy = false,
      priority = 1000,
      config = function()
        -- Optionally configure and load the colorscheme
        -- directly inside the plugin declaration.
        vim.g.sonokai_enable_italic = true
        vim.cmd.colorscheme('sonokai')
      end
    },

    {
      'sainnhe/everforest',
      lazy = false,
      priority = 1000,
      config = function()
        -- Optionally configure and load the colorscheme
        -- directly inside the plugin declaration.
        vim.g.everforest_enable_italic = true
        vim.cmd.colorscheme('everforest')
      end
    },

    {
      "nvim-lualine/lualine.nvim",
      dependencies = { "nvim-tree/nvim-web-devicons" },
      lazy = false,
      priority = 1000,
      config = function()
        require("lualine").setup {
          options = {
            theme = "nord",   -- or another theme you like
            section_separators = { left = "", right = "" },
            component_separators = { left = "", right = "" },
          },
          sections = {
            lualine_a = { "mode" },                      -- Current mode: Normal, Insert, etc.
            lualine_b = { "branch", "diff", "diagnostics" },
            lualine_c = { "filename" },
            lualine_x = { "encoding", "fileformat", "filetype" },
            lualine_y = { "progress" },
            lualine_z = { "location" },                  -- Shows row and column
          },
          inactive_sections = {
            lualine_a = {},
            lualine_b = {},
            lualine_c = { "filename" },
            lualine_x = { "location" },
            lualine_y = {},
            lualine_z = {}
          },
        }
      end,
    },    
  },
  install = { colorscheme = { "tokyonight", "habamax", "rose-pine", "kanagawa", "poimandres", "sonokai"} },
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

-- vim.defer_fn(function()
--   vim.cmd("colorscheme habamax")
-- end, 0)
