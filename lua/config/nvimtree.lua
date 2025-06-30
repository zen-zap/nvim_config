-- lua/config/nvimtree.lua
require("nvim-tree").setup({
    view = {
        side = "left",  -- File explorer appears on the left side
        width = 30,     -- Adjust width as needed
    },
    renderer = {
        icons = {
            show = {
                git = true,       -- Show Git icons
                folder = true,    -- Show folder icons
                file = true,      -- Show file icons
            },
        },
        highlight_git = true,      -- Highlight Git changes
        group_empty = true,        -- Group empty folders
    },
	diagnostics = {
        enable = true,             -- Show diagnostics in the tree
        icons = {
            hint = "",
            info = "",
            warning = "",
            error = "",
        },
    },
	git = {
        enable = true,             -- Enable Git integration
        ignore = false,            -- Show ignored files
    },
  })