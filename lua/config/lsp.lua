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

local function conditional_hover()
  local params = vim.lsp.util.make_position_params()
  vim.lsp.buf_request(0, "textDocument/hover", params, function(err, result, ctx, config)
    if err or not (result and result.contents) then
      return
    end
    local markdown_lines = vim.lsp.util.convert_input_to_markdown_lines(result.contents)
    markdown_lines = vim.lsp.util.trim_empty_lines(markdown_lines)
    if vim.tbl_isempty(markdown_lines) then
      return
    end
    local opts = { focusable = true, border = "rounded" }
    vim.lsp.util.open_floating_preview(markdown_lines, "markdown", opts)
  end)
end

vim.api.nvim_create_autocmd("CursorHold", {
  callback = conditional_hover,
})
