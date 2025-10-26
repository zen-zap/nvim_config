return {

    -- nvim-lspconfig
    {
        "neovim/nvim-lspconfig",
    },
    -- Bufferline (tab line)
    {
        'akinsho/bufferline.nvim', 
        version = "*", 
        dependencies = 'nvim-tree/nvim-web-devicons', 
        config = function()
            vim.opt.termguicolors = true
            require("bufferline").setup{
                options = {
                    -- Add icons
                    diagnostics = "nvim_lsp",
                    show_buffer_icons = true,
                    show_buffer_close_icons = true,
                    separator_style = "thin",
                }
            }
        end
    },

    -- nvim-cmp (LSP-based code completion)
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
            "hrsh7th/cmp-vsnip", -- Add cmp-vsnip for snippet completion
            "hrsh7th/vim-vsnip", -- Snippet engine
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
                    { name = "vsnip" }, -- Enable vsnip as a source
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

    -- Indent guides
    {
        "lukas-reineke/indent-blankline.nvim",
        main = "ibl",
        opts = {},
    },


    -- Leap (quick navigation)
    {
        "ggandor/leap.nvim",
        config = function()
            require("leap").add_default_mappings()
        end,
    },

    -- Matchup (enhanced % matching)
    {
        "andymass/vim-matchup",
        config = function()
            vim.g.matchup_matchparen_offscreen = { method = "popup" }
        end,
    },

    -- Git signs
    {
        "lewis6991/gitsigns.nvim",
        config = function()
            require("gitsigns").setup()
        end,
    },

    -- Which-key (keybinding helper)
    {
        "folke/which-key.nvim",
        config = function()
            require("which-key").setup({})
        end,
    },

    -- Smooth scrolling
    {
        "karb94/neoscroll.nvim",
        config = function()
            require("neoscroll").setup({
                easing_function = "quadratic",
                hide_cursor = true,
                stop_eof = true,
            })
        end,
    },

    -- Highlight word under cursor
    {
        "RRethy/vim-illuminate",
        config = function()
            require("illuminate").configure({
                providers = { "lsp", "regex", "treesitter" },
                delay = 120,
                filetypes_denylist = { "dirvish", "fugitive", "NvimTree" },
            })
        end,
    },

    -- Auto pairs for brackets and quotes
    {
        "windwp/nvim-autopairs",
        event = "InsertEnter",
        config = function()
            require("nvim-autopairs").setup({
                enable_check_bracket_line = true,
                disable_filetype = { "TelescopePrompt" },
            })
        end,
    },

    -- nvim-tree (file explorer)
    {
        'nvim-tree/nvim-tree.lua',
        dependencies = 'nvim-tree/nvim-web-devicons',
        config = function()
        require("nvim-tree").setup({
            -- THIS IS THE KEY: Set the file tree to the left
            view = {
            side = "left",
            },
            -- Add git highlighting
            git = {
            enable = true,
            },
            -- Disable netrw (the default file explorer)
            disable_netrw = true,
        })
        end
    },

    -- Lualine (statusline)
    {
        'nvim-lualine/lualine.nvim',
        dependencies = { 'nvim-tree/nvim-web-devicons' },
        config = function()
        require('lualine').setup({
            options = {
            theme = 'auto', -- Will match your colorscheme
            }
        })
        end
    },

    -- Devicons
    { "nvim-tree/nvim-web-devicons", opts = {}, lazy = false, priority = 1000 },

    -- Telescope (fuzzy finder)
    { "nvim-telescope/telescope.nvim", dependencies = { "nvim-lua/plenary.nvim" } },

    -- Noice (UI enhancements)
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
                    command_palette = true,
                    long_message_to_split = true,
                    lsp_doc_border = true,
                },
            })
        end,
    },

    -- Kanagawa colorscheme
    {
        "rebelot/kanagawa.nvim",
        lazy = false,
        priority = 1000,
        config = function()
        end,
    },

    -- Poimandres colorscheme
    {
        "olivercederborg/poimandres.nvim",
        lazy = false,
        priority = 1000,
        config = function()
            require("poimandres").setup({})
            -- vim.cmd.colorscheme("poimandres")
        end,
    },

    -- Nordic colorscheme
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
        "nvim-treesitter/nvim-treesitter",
        opts = { ensure_installed = { "rust", "ron", "cpp", "java", "json5" } },
        config = function(_, opts)
            require("nvim-treesitter.configs").setup(opts)
            -- Enable inlay hints for Rust
            if vim.lsp.inlay_hint then
                vim.lsp.inlay_hint.enable(true, { bufnr = 0 })
            end
        end,
        lazy = false,
        priority = 1000,
    },

    {'akinsho/bufferline.nvim', version = "*", dependencies = 'nvim-tree/nvim-web-devicons'},

    -- Sonokai colorscheme
    {
        "sainnhe/sonokai",
        lazy = false,
        priority = 1000,
        config = function()
            vim.g.sonokai_enable_italic = true
            -- vim.cmd.colorscheme("sonokai")
        end,
    },

    -- Everforest colorscheme
    {
        "sainnhe/everforest",
        lazy = false,
        priority = 1000,
        config = function()
            vim.g.everforest_enable_italic = true
            -- vim.cmd.colorscheme("everforest")
        end,
    },

    -- Rose Pine colorscheme
    {
        "rose-pine/neovim",
        name = "rose-pine",
        lazy = false,
        priority = 1000,
        config = function()
            require("rose-pine").setup({
                dark_variant = "main", -- Choose between "main", "moon", or "dawn"
            })
            -- vim.cmd.colorscheme("rose-pine")
        end,
    },

    -- Tokyo Night colorscheme
    {
        "folke/tokyonight.nvim",
        lazy = false,
        priority = 1000,
        config = function()
            -- vim.cmd.colorscheme("tokyonight")
        end,
    },


    { "blazkowolf/gruber-darker.nvim" },

    { "ramojus/mellifluous.nvim"},

    {"kdheepak/monochrome.nvim"},

    -- make something like the dark-orchid theme

    {
        'everviolet/nvim', name = 'evergarden',
        priority = 1000,
    },

    { "catppuccin/nvim", name = "catppuccin", priority = 1000 },

    {
        'ribru17/bamboo.nvim',
        lazy = false,
        priority = 1000,
        config = function()
            require('bamboo').setup {
                -- optional configuration here
            }
            require('bamboo').load()
        end,
    },

    {
        "dgox16/oldworld.nvim",
        lazy = false,
        priority = 1000,
    },

    {
        "xero/miasma.nvim",
        lazy = false,
        priority = 1000,
        config = function()
            vim.cmd("colorscheme miasma")
        end,
    },
    -- Fidget (LSP progress)
    {
        "j-hui/fidget.nvim",
        tag = "legacy", -- Use the stable version
        config = function()
            require("fidget").setup({
                text = {
                    spinner = "dots", -- Use a smaller spinner
                },
                window = {
                    blend = 0, -- No transparency
                    border = "none", -- Remove border
                },
                fmt = {
                    max_width = 20, -- Limit the width of the progress bar
                },
                sources = {
                    ["rust-analyzer"] = {
                        ignore = true, -- Completely hide rust-analyzer progress
                    },
                    ["jdtls"] = {
                        ignore = true, -- Completely hide progress notifications from jdtls
                    },
                },
            })
        end,
    },

    -- Lualine (statusline)
    {
        "nvim-lualine/lualine.nvim",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        lazy = false,
        priority = 1000,
        config = function()
            require("lualine").setup({
                options = {
                    theme = "nordic",
                    section_separators = { left = "", right = "" },
                    component_separators = { left = "", right = "" },
                },
                sections = {
                    lualine_a = { "mode" },
                    lualine_b = { "branch", "diff", "diagnostics" },
                    lualine_c = { "filename" },
                    lualine_x = { "encoding", "fileformat", "filetype" },
                    lualine_y = { "progress" },
                    lualine_z = { "location" },
                },
                inactive_sections = {
                    lualine_a = {},
                    lualine_b = {},
                    lualine_c = { "filename" },
                    lualine_x = { "location" },
                    lualine_y = {},
                    lualine_z = {},
                },
            })
        end,
    },

    {
        "nvim-neotest/nvim-nio",
        lazy = true,
    },

    {
        "mfussenegger/nvim-dap",
        dependencies = {
            "nvim-neotest/nvim-nio",
        },
        config = function()
            local dap = require("dap")

            -- C / C++ with codelldb
            if not dap.adapters["codelldb"] then
                dap.adapters["codelldb"] = {
                    type = "server",
                    host = "localhost",
                    port = "${port}",
                    executable = {
                        command = "codelldb",
                        args = { "--port", "${port}" },
                    },
                }
            end

            for _, lang in ipairs({ "c", "cpp" }) do
                dap.configurations[lang] = {
                    {
                        type = "codelldb",
                        request = "launch",
                        name = "Launch file",
                        program = function()
                            return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
                        end,
                        cwd = "${workspaceFolder}",
                    },
                    {
                        type = "codelldb",
                        request = "attach",
                        name = "Attach to process",
                        pid = require("dap.utils").pick_process,
                        cwd = "${workspaceFolder}",
                    },
                }
            end

            -- Java remote debug
            dap.configurations.java = {
                {
                    type = "java",
                    request = "attach",
                    name = "Debug (Attach) - Remote",
                    hostName = "127.0.0.1",
                    port = 5005,
                },
            }
        end,
    },


    {
        "rcarriga/nvim-dap-ui",
        dependencies = { "mfussenegger/nvim-dap" },
        config = function()
            local dap = require("dap")
            local dapui = require("dapui")
            dapui.setup()

            -- Auto open/close
            dap.listeners.after.event_initialized["dapui_config"] = function()
                dapui.open()
            end
            dap.listeners.before.event_terminated["dapui_config"] = function()
                dapui.close()
            end
            dap.listeners.before.event_exited["dapui_config"] = function()
                dapui.close()
            end
        end,
    },

    {
        "williamboman/mason.nvim",
        cmd = "Mason",
        build = ":MasonUpdate",
        opts = {
            ensure_installed = {
                "typescript-language-server",
                "eslint-lsp",
                "codelldb",
                "java-debug-adapter",
                "java-test",
                "prettier",
                "pyright",
                "ruff",
                "gopls",
            },
            ui = {
                border = "rounded",
                icons = {
                    package_installed = "✓",
                    package_pending = "➜",
                    package_uninstalled = "✗",
                },
            },
        },
    },
}
