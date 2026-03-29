-- init.lua
-- bootstrap lazy.nvim, LazyVim and your plugins

-- Load lazy.nvim configuration first (This will automatically trigger nvim-tree and cmp setups!)
require("config.lazy")

-- Load core Neovim settings
require("config.options")

-- Load theme (font, colors, transparency)
require("config.theme")
require("config.colorscheme") -- loads the colorscheme persistence snippet

-- Load key mappings and autocommands
require("config.keymaps")
require("config.autocmds")

-- Load LSP configuration (for Java, Rust, C)
require("config.lsp")
