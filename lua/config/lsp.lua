-- lsp.lua
-- LSP configuration for Java, Rust, and C

-- Ensure you have installed nvim-lspconfig:
-- e.g., with your package manager or Lazy.nvim later.
local lspconfig = require("lspconfig")

-- Configure Java LSP (jdtls) - make sure jdtls is installed on your system.
lspconfig.jdtls.setup({
  -- Basic configuration for jdtls; add your own settings if needed.
  cmd = { "jdtls" },
  root_dir = lspconfig.util.root_pattern("gradlew", "mvnw", ".git"),
})

-- Configure Rust LSP (rust-analyzer) - make sure rust-analyzer is installed.
lspconfig.rust_analyzer.setup({
  settings = {
    ["rust-analyzer"] = {
      checkOnSave = {
        command = "clippy",  -- use clippy for linting
      },
    },
  },
  on_attach = function(client, bufnr)
    print("Rust LSP attached!")
  end,
})

-- Configure C/C++ LSP (clangd) - ensure clangd is installed.
lspconfig.clangd.setup({})

-- Show documentation when you hover the cursor:
-- Automatically show a floating window with LSP hover info after the cursor is held still.
vim.o.updatetime = 100  -- update time in milliseconds
vim.cmd([[
  augroup LspHover
    autocmd!
    " When the cursor stays idle, call LSP hover function
    autocmd CursorHold * lua vim.lsp.buf.hover()
  augroup END
]])
