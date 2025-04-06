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

-- Ensure the lspconfig module is required
local lspconfig = require('lspconfig')

-- Configure rust-analyzer
lspconfig.rust_analyzer.setup({
  settings = {
    ["rust-analyzer"] = {
      -- Enable clippy diagnostics on save
      checkOnSave = {
        command = "clippy",
      },
      -- Enable inlay hints
      inlayHints = {
        enable = true,
        typeHints = true,
        chainingHints = true,
      },
      -- Enable automatic formatting
      rustfmt = {
        enableRangeFormatting = true,
        extraArgs = { "--edition=2021" },
      },
      cargo = {
        allFeatures = true,
      },
      imports = {
        group = {
          enable = false,
        },
      },
      completion = {
        postfix = {
          enable = false,
        },
      },
    },
  },
  on_attach = function(client, bufnr)
    -- Key mappings for Rust LSP features
    local buf_map = function(mode, lhs, rhs, opts)
      opts = opts or { noremap = true, silent = true }
      vim.api.nvim_buf_set_keymap(bufnr, mode, lhs, rhs, opts)
    end

    -- Example mappings:
    buf_map("n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>")        -- Go to definition
    buf_map("n", "K", "<cmd>lua vim.lsp.buf.hover()<CR>")              -- Hover documentation
    buf_map("n", "<leader>ca", "<cmd>lua vim.lsp.buf.code_action()<CR>") -- Code actions
    buf_map("n", "<leader>rn", "<cmd>lua vim.lsp.buf.rename()<CR>")    -- Rename symbol

    if type(vim.lsp.buf.inlay_hint) == "function" then
      vim.api.nvim_create_autocmd("InsertLeave", {
        buffer = bufnr,
        callback = function()
          vim.lsp.buf.inlay_hint(bufnr, true)
        end,
      })
      vim.api.nvim_create_autocmd("InsertEnter", {
        buffer = bufnr,
        callback = function()
          vim.lsp.buf.inlay_hint(bufnr, false)
        end,
      })
    else
      print("Inlay hints--none")
    end
    -- Print a messagee when Rust LSP attaches
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
