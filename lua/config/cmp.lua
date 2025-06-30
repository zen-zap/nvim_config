local cmp = require('cmp')

cmp.setup({
  mapping = {
    -- Confirm suggestion only when one is explicitly selected.
    ['<CR>'] = cmp.mapping.confirm({ select = false }),

    -- Use arrow keys to navigate suggestions.
    ['<Down>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      else
        fallback()
      end
    end, { "i", "s" }),

    ['<Up>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      else
        fallback()
      end
    end, { "i", "s" }),
  },
  sources = cmp.config.sources({
    { name = 'nvim_lsp' },
    { name = 'buffer' },
  }),
}) 