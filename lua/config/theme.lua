-- theme.lua
-- Set your colorscheme and transparency
-- require("rose-pine").setup({
--     variant = "main", -- auto, main, moon, or dawn
--     dark_variant = "main", -- main, moon, or dawn
--     dim_inactive_windows = false,
--     extend_background_behind_borders = true,

--     enable = {
--         terminal = true,
--         legacy_highlights = true, -- Improve compatibility for previous versions of Neovim
--         migrations = true, -- Handle deprecated options automatically
--     },

--     styles = {
--         bold = true,
--         italic = true,
--         transparency = true,
--     },

--     groups = {
--         border = "muted",
--         link = "iris",
--         panel = "surface",

--         error = "love",
--         hint = "iris",
--         info = "foam",
--         note = "pine",
--         todo = "rose",
--         warn = "gold",

--         git_add = "foam",
--         git_change = "rose",
--         git_delete = "love",
--         git_dirty = "rose",
--         git_ignore = "muted",
--         git_merge = "iris",
--         git_rename = "pine",
--         git_stage = "iris",
--         git_text = "rose",
--         git_untracked = "subtle",

--         h1 = "iris",
--         h2 = "foam",
--         h3 = "rose",
--         h4 = "gold",
--         h5 = "pine",
--         h6 = "foam",
--     },

--     palette = {
--         -- Override the builtin palette per variant
--         -- moon = {
--         --     base = '#18191a',
--         --     overlay = '#363738',
--         -- },
--     },

--     highlight_groups = {
--         -- Comment = { fg = "foam" },
--         -- VertSplit = { fg = "muted", bg = "muted" },
--     },

--     before_highlight = function(group, highlight, palette)
--         -- Disable all undercurls
--         -- if highlight.undercurl then
--         --     highlight.undercurl = false
--         -- end
--         --
--         -- Change palette colour
--         -- if highlight.fg == palette.pine then
--         --     highlight.fg = palette.foam
--         -- end
--     end,
-- })

-- vim.cmd("colorscheme rose-pine-main")

-- -- Default options:
-- require('kanagawa').setup({
--     compile = false,             -- enable compiling the colorscheme
--     undercurl = true,            -- enable undercurls
--     commentStyle = { italic = true },
--     functionStyle = {},
--     keywordStyle = { italic = true},
--     statementStyle = { bold = true },
--     typeStyle = {},
--     transparent = true,         -- do not set background color
--     dimInactive = true,         -- dim inactive window `:h hl-NormalNC`
--     terminalColors = true,       -- define vim.g.terminal_color_{0,17}
--     colors = {                   -- add/modify theme and palette colors
--         palette = {},
--         theme = { dragon = {} },             -- wave = {}, lotus = {}, dragon = {}, all = {}
--     },
--     overrides = function(colors) -- add/modify highlights
--         return {}
--     end,
--     theme = "dragon",              -- Load "wave" theme when 'background' option is not set
--     background = {               -- map the value of 'background' option to a theme
--         dark = "dragon",           -- try "dragon" !
--         light = "dragon"
--     },
-- })

-- -- setup must be called before loading
-- vim.cmd("colorscheme kanagawa-dragon")

-- require("oldworld").setup({
--     styles = {
--         booleans = { italic = true, bold = true },
--     },
--     integrations = {
--         hop = true,
--         telescope = false,
--     },
--     highlight_overrides = {
--         Comment = { bg = "#ff0000" }
--     }
-- })

-- vim.cmd.colorscheme("oldworld")


-- vim.cmd("colorscheme rose-pine-main")
-- vim.cmd("colorscheme rose-pine-moon")
-- vim.cmd("colorscheme rose-pine-dawn")

-- Change the colorscheme to your favorite (e.g., tokyonight, gruvbox, etc.)
-- vim.cmd("colorscheme <>")  -- change this to your preferred theme

-- For GUI clients, make the background transparent:
-- This command clears the background so your terminal or GUI background shows through.
vim.cmd("highlight Normal guibg=NONE")

-- You can also change font settings for GUI here if not in options.lua.


-- Adjust the opacity of the background
vim.api.nvim_set_hl(0, "Normal", { bg = "#1e1e2e", blend = 40 }) -- Replace with your desired color and transparency level
vim.api.nvim_set_hl(0, "NormalNC", { bg = "#1e1e2e", blend = 40 }) -- For inactive windows


