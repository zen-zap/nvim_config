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

    -- LSP-based code-completion
	{
		"hrsh7th/nvim-cmp",
		-- load cmp on InsertEnter
		event = "InsertEnter",
		-- these dependencies will only be loaded when cmp loads
		-- dependencies are always lazy-loaded unless specified otherwise
		dependencies = {
			'neovim/nvim-lspconfig',
			"hrsh7th/cmp-nvim-lsp",
			"hrsh7th/cmp-buffer",
			"hrsh7th/cmp-path",
		},
		config = function()
			local cmp = require'cmp'
			cmp.setup({
				snippet = {
					-- REQUIRED by nvim-cmp. get rid of it once we can
					expand = function(args)
						vim.fn["vsnip#anonymous"](args.body)
					end,
				},
				mapping = cmp.mapping.preset.insert({
					['<C-b>'] = cmp.mapping.scroll_docs(-4),
					['<C-f>'] = cmp.mapping.scroll_docs(4),
					['<C-Space>'] = cmp.mapping.complete(),
					['<C-e>'] = cmp.mapping.abort(),
					-- Accept currently selected item.
					-- Set `select` to `false` to only confirm explicitly selected items.
					['<CR>'] = cmp.mapping.confirm({ select = true }),
				}),
				sources = cmp.config.sources({
					{ name = 'nvim_lsp' },
				}, {
					{ name = 'path' },
				}),
				experimental = {
					ghost_text = true,
				},
			})

			-- Enable completing paths in :
			cmp.setup.cmdline(':', {
				sources = cmp.config.sources({
					{ name = 'path' }
				})
			})
		end
	},


    {
      "lukas-reineke/indent-blankline.nvim",
      main = "ibl",
      ---@module "ibl"
      ---@type ibl.config
      opts = {},
    },

    -- quick navigation
    {
      'ggandor/leap.nvim',
      config = function()
        require('leap').create_default_mappings()
      end
    },
  	-- Enhanced % matching for pairs
    {
      'andymass/vim-matchup',
      config = function()
        vim.g.matchup_matchparen_offscreen = { method = "popup" }
      end
    },
    
    -- to see git changes
    {
      "lewis6991/gitsigns.nvim",
      config = function()
        require("gitsigns").setup()
      end,
    },

    {
      "folke/which-key.nvim",
      config = function()
        require("which-key").setup {}
      end,
    },
    
    {
      "karb94/neoscroll.nvim",
      config = function()
        require("neoscroll").setup {
          easing_function = "quadratic",
          hide_cursor = true,
          stop_eof = true,
        }
      end,
    },
    
    {
      "RRethy/vim-illuminate",
      config = function()
        require("illuminate").configure {
          providers = { "lsp", "regex", "treesitter" },
          delay = 120,
          filetypes_denylist = { "dirvish", "fugitive", "NvimTree" },
        }
      end,
    },
    
	-- Auto pairs for brackets and quotes
    {
      "windwp/nvim-autopairs",
      event = "InsertEnter",
      config = function()
        require("nvim-autopairs").setup({
          enable_check_bracket_line = true,  -- Check for existing bracket in the same line
          disable_filetype = { "TelescopePrompt" },  -- Disable in specific filetypes
        })        
      end,
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
              blend = 0.80,
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

	-- -- toml
	-- 'cespare/vim-toml',
	-- -- yaml
	-- {
	-- 	"cuducos/yaml.nvim",
	-- 	ft = { "yaml" },
	-- 	dependencies = {
	-- 		"nvim-treesitter/nvim-treesitter",
	-- 	},
	-- },
	-- -- rust
	-- {
	-- 	'rust-lang/rust.vim',
	-- 	ft = { "rust" },
	-- 	config = function()
	-- 		vim.g.rustfmt_autosave = 1
	-- 		vim.g.rustfmt_emit_files = 1
	-- 		vim.g.rustfmt_fail_silently = 0
	-- 		vim.g.rust_clip_command = 'wl-copy'
	-- 	end
	-- },

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
