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
      -- can Enable clippy diagnostics on save
      checkOnSave = {
        enable = false,
      },
      cachePriming = { enable = true },
      -- Enable inlay hints
      inlayHints = {
        enable = true,
        typeHints = true,
        chainingHints = true,
        parameterHints = true, -- Show parameter hints
        maxLength = 30, -- Limit the length of inlay hints
      },
      -- Enable proc macro support
      -- This is necessary for procedural macros to work correctly
      -- in Rust projects using macros like `serde_derive` or `rocket`
      procMacro = {
        enable = true,
      },
      -- Enable automatic formatting
      rustfmt = {
        overrideCommand = { "rustfmt", "--edition", "2024" },
        config = "~/.config/rustfmt/rustfmt.toml",
      },
      cargo = {
        allFeatures = true,
        -- targetDir = "target/rust-analyzer",
      },
      imports = {
        group = {
          enable = false,
        },
      },
      lsp = {
        progress = {
          enable = false, -- Disable progress notifications
        },
      },
      completion = {
        postfix = {
          enable = true, -- Enable postfix completions like `.unwrap`
        },
        autoimport = {
          enable = true, -- Automatically import missing items
        },
      },
      experimental = {
        enable = true,
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
    buf_map("n", "rf", "<cmd>lua vim.lsp.buf.format({ async = true })<CR>") -- Format Code

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
    -- Print a message when Rust LSP attaches
    print("rust-ready")
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

-- vim.api.nvim_create_autocmd("CursorHold", {
--   callback = conditional_hover,
-- })
