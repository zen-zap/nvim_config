-- lua/config/nvimtree.lua
require("nvim-tree").setup({
    view = {
      side = "left",  -- File explorer appears on the left side
      width = 30,     -- Adjust width as needed
    },
    renderer = {
      icons = {
        show = {
          git = true,
          folder = true,
          file = true,
        },
      },
    },
  })
  