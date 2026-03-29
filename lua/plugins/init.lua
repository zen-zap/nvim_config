-- lua/plugins/init.lua
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
        dependencies = {
            'neovim/nvim-lspconfig',
            "hrsh7th/cmp-nvim-lsp",
            "hrsh7th/cmp-buffer",
            "hrsh7th/cmp-path",
            -- vsnip dependencies removed for native Neovim 0.12 snippets!
        },
        config = function()
            -- Delegate the setup to your external config file
            require("config.cmp")
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
        url = "https://codeberg.org/andyg/leap.nvim",
        config = function()
            -- Use the recommended plug mappings (modern API)
            vim.keymap.set({'n', 'x', 'o'}, 's',  '<Plug>(leap-forward)')
            vim.keymap.set({'n', 'x', 'o'}, 'S',  '<Plug>(leap-backward)')
            vim.keymap.set({'n', 'x', 'o'}, 'gs', '<Plug>(leap-from-window)')
        end,
    },

    -- Matchup (enhanced % matching)
    {
        "andymass/vim-matchup",
        config = function()
            vim.g.matchup_matchparen_offscreen = { method = "popup" }
            vim.g.matchup_matchparen_treesitter = 0 -- Disable Treesitter integration to avoid 0.12 crash, rely on regex matching instead
        end,
    },

    -- Notify (notification system)
    { "rcarriga/nvim-notify" },

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
            require("config.nvimtree")
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

    -- Mini icons (alternative icon provider used by which-key health checks)
    {
        "echasnovski/mini.nvim",
        version = false,
        config = function()
            require("mini.icons").setup()
        end,
    },

    -- Telescope (fuzzy finder)
    { "nvim-telescope/telescope.nvim", dependencies = { "nvim-lua/plenary.nvim" } },

    -- Noice & Notify (UI enhancements)
    {
        "folke/noice.nvim",
        dependencies = { 
            "MunifTanjim/nui.nvim", 
            "rcarriga/nvim-notify"
        },
        config = function()
            
            require("notify").setup({
                background_colour = "#000000", -- Fixes the background math error
                timeout = 2000,                -- Disappears fast (2 seconds)
                stages = "static",             -- No distracting sliding animations
                render = "compact",            -- Bare minimum text, no massive borders
            })

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
                
                -- This intercepts standard notifications and forces them into a 
                -- tiny, unobtrusive line of text at the bottom right of your screen.
                -- This also completely bypasses the Neovim 0.12 Treesitter crash!
                routes = {
                    {
                        filter = { event = "notify" },
                        view = "mini",
                    },
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
        end,
    },

    -- Nordic colorscheme
    {
        'AlexvZyl/nordic.nvim',
        lazy = false,
        priority = 1000,
        config = function()
            require('nordic').setup({
                on_palette = function(palette) end,
                after_palette = function(palette) end,
                on_highlight = function(highlights, palette) end,
                bold_keywords = false,
                italic_comments = true,
                transparent = {
                    bg = true,
                    float = true,
                },
                bright_border = false,
                reduced_blue = true,
                swap_backgrounds = false,
                cursorline = {
                    bold = false,
                    bold_number = true,
                    theme = 'dark',
                    blend = 0.80,
                },
                noice = { style = 'classic' },
                telescope = { style = 'flat' },
                leap = { dim_backdrop = true },
                ts_context = { dark_background = true }
            })
            vim.cmd.colorscheme('nordic')
        end
    },

    -- Treesitter
    {
        "nvim-treesitter/nvim-treesitter",
        branch = "main",
        build = ":TSUpdate",
        opts = {
            ensure_installed = { "rust", "ron", "cpp", "java", "json5", "bash", "regex", "lua", "vim", "vimdoc", "markdown", "markdown_inline" },
            highlight = { enable = true },
            indent = { enable = true },
            matchup = { enable = false }, -- breaking change in 0.12, disable until it's fixed
        },
        lazy = false,
        priority = 1000,
    },

    -- Sonokai colorscheme
    {
        "sainnhe/sonokai",
        lazy = false,
        priority = 1000,
        config = function()
            vim.g.sonokai_enable_italic = true
        end,
    },

    -- Everforest colorscheme
    {
        "sainnhe/everforest",
        lazy = false,
        priority = 1000,
        config = function()
            vim.g.everforest_enable_italic = true
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
                dark_variant = "main",
            })
        end,
    },

    -- Tokyo Night colorscheme
    { "folke/tokyonight.nvim", lazy = false, priority = 1000 },
    { "blazkowolf/gruber-darker.nvim" },
    { "ramojus/mellifluous.nvim" },
    { "kdheepak/monochrome.nvim" },
    { 'everviolet/nvim', name = 'evergarden', priority = 1000 },
    { "catppuccin/nvim", name = "catppuccin", priority = 1000 },

    {
        'ribru17/bamboo.nvim',
        lazy = false,
        priority = 1000,
        config = function()
            require('bamboo').setup {}
            require('bamboo').load()
        end,
    },

    { "dgox16/oldworld.nvim", lazy = false, priority = 1000 },

    {
        "xero/miasma.nvim",
        lazy = false,
        priority = 1000,
        config = function()
            vim.cmd("colorscheme miasma")
        end,
    },

    { 'embark-theme/vim', lazy = false, priority = 1000, name = 'embark' },
    { 'datsfilipe/vesper.nvim' },
    { "ficcdaf/ashen.nvim" },
    { "kuri-sun/yoda.nvim" },

    -- Fidget (LSP progress)
    {
        "j-hui/fidget.nvim",
        tag = "legacy", 
        config = function()
            require("fidget").setup({
                text = { spinner = "dots" },
                window = { blend = 0, border = "none" },
                fmt = { max_width = 20 },
                sources = {
                    ["rust-analyzer"] = { ignore = true },
                    ["jdtls"] = { ignore = true },
                },
            })
        end,
    },

    -- nvim-nio (dependency for DAP)
    {
        "nvim-neotest/nvim-nio",
        lazy = true,
    },

    -- nvim-dap (Debugger)
    {
        "mfussenegger/nvim-dap",
        dependencies = {
            "nvim-neotest/nvim-nio",
        },
        config = function()
            local dap = require("dap")
            local mason_codelldb = vim.fn.expand("~/.local/share/nvim/mason/bin/codelldb")
            local codelldb_cmd = nil
            if vim.fn.executable(mason_codelldb) == 1 then
                codelldb_cmd = mason_codelldb
            elseif vim.fn.executable("codelldb") == 1 then
                codelldb_cmd = "codelldb"
            end

            -- C / C++ with codelldb
            if codelldb_cmd and not dap.adapters["codelldb"] then
                dap.adapters["codelldb"] = {
                    type = "server",
                    host = "localhost",
                    port = "${port}",
                    executable = {
                        command = codelldb_cmd,
                        args = { "--port", "${port}" },
                    },
                }
            end

            if codelldb_cmd then
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

    -- nvim-dap-ui (Debugger UI)
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

    -- Mason (LSP/Formatter installer)
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