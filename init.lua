-- bootstrap lazy.nvim, LazyVim and your plugins
-- init.lua
-- Load lazy.nvim configuration first
require("config.lazy")

-- Load basic options
require("config.options")

-- Load theme (font, colors, transparency)
require("config.theme")

-- Load key mappings
require("config.keymaps")

-- Load autocommands
require("config.autocmds")

-- Load LSP configuration (for Java, Rust, C)
require("config.lsp")

-- Load file explorer configuration
require("config.nvimtree")

require("config.devicons")

require("config.colorscheme")   -- loads the colorscheme persistence snippet