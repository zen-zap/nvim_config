local cmp = require('cmp')

cmp.setup({
  snippet = {
    expand = function(args)
      vim.fn["vsnip#anonymous"](args.body) -- Required for gopls placeholders
    end,
  },
  completion = {
    autocomplete = { require("cmp.types").cmp.TriggerEvent.InsertEnter }, -- less aggressive
    completeopt = 'menu,menuone,noinsert,noselect',
    get_trigger_characters = function(trigger_characters)
      return vim.tbl_filter(function(char)
        return char ~= ' '
      end, trigger_characters)
    end,
  },
  preselect = cmp.PreselectMode.None,
  mapping = {
    -- Confirm suggestion only when one is explicitly selected.
    ['<CR>'] = cmp.mapping(function(fallback)
      if cmp.visible() and cmp.get_selected_entry() then
        -- Replace the word at cursor with the selected completion
        cmp.confirm({ 
          behavior = cmp.ConfirmBehavior.Replace, 
          select = false 
        })
      else
        fallback()
      end
    end, { 'i', 's' }),

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
    -- Tab / Shift-Tab to navigate suggestions
    ['<Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      else
        fallback()
      end
    end, { 'i', 's' }),
    ['<S-Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      else
        fallback()
      end
    end, { 'i', 's' }),
  },
  sources = cmp.config.sources({
    { name = 'nvim_lsp', priority = 1000 }, -- LSP completions (highest priority)
    { name = 'vsnip', priority = 500 },    -- Snippet completions
  }, {
    { name = 'buffer', priority = 100, keyword_length = 3 }, -- Buffer completions (lower priority, min 3 chars)
    { name = 'path', priority = 200 },     -- Path completions
  }),
})

-- Filetype-specific config for Go to fix append issue
cmp.setup.filetype('go', {
  sources = cmp.config.sources({
    { name = 'nvim_lsp', priority = 1000 }, -- Only use LSP for Go (no buffer completions)
    { name = 'vsnip', priority = 500 },
  }, {
    { name = 'path', priority = 200 },
  }),
  mapping = {
    -- Override Enter for Go to force proper word replacement
    ['<CR>'] = cmp.mapping(function(fallback)
      if cmp.visible() and cmp.get_selected_entry() then
        local entry = cmp.get_selected_entry()
        local cursor = vim.api.nvim_win_get_cursor(0)
        local line = vim.api.nvim_get_current_line()
        local col = cursor[2]
        
        -- Find the start of the current word (identifier)
        local word_start = col
        while word_start > 0 and line:sub(word_start, word_start):match('[%w_]') do
          word_start = word_start - 1
        end
        word_start = word_start + 1
        
        -- Delete the partial word before confirming
        if word_start < col then
          vim.api.nvim_buf_set_text(0, cursor[1] - 1, word_start - 1, cursor[1] - 1, col, {''})
          vim.api.nvim_win_set_cursor(0, {cursor[1], word_start - 1})
        end
        
        -- Now confirm with Insert behavior (since we already deleted)
        cmp.confirm({ 
          behavior = cmp.ConfirmBehavior.Insert, 
          select = false 
        })
      else
        fallback()
      end
    end, { 'i', 's' }),
  },
})
 