local lspconfig = require("lspconfig")
local util = require("lspconfig.util")

-- Common on_attach function for all servers
local function on_attach(client, bufnr)
    local buf_map = function(mode, lhs, rhs, desc)
        vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = desc })
    end

    -- LSP keymaps
    buf_map('n', 'gd', vim.lsp.buf.definition, "Go to Definition")
    buf_map('n', 'K', vim.lsp.buf.hover, "Hover Documentation")
    buf_map('n', '<leader>rn', vim.lsp.buf.rename, "Rename Symbol")
    buf_map('n', '<leader>ca', vim.lsp.buf.code_action, "Code Action")
    buf_map('n', '[d', vim.diagnostic.goto_prev, "Previous Diagnostic")
    buf_map('n', ']d', vim.diagnostic.goto_next, "Next Diagnostic")

    -- Inlay hints toggle if supported
    if client.supports_method("textDocument/inlayHint") then
        vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
        buf_map('n', '<leader>ih', function()
            local enabled = vim.lsp.inlay_hint.is_enabled({ bufnr = bufnr })
            vim.lsp.inlay_hint.enable(not enabled, { bufnr = bufnr })
        end, "Toggle Inlay Hints")
    end
end

-- Capabilities (e.g., for cmp-nvim-lsp)
local capabilities = require('cmp_nvim_lsp').default_capabilities(vim.lsp.protocol.make_client_capabilities())
capabilities.offsetEncoding = { "utf-16" }

-- Java (jdtls)
lspconfig.jdtls.setup({
    cmd = { "jdtls" },
    root_dir = util.root_pattern(".git", "pom.xml", "build.gradle", "settings.gradle"),
    on_attach = on_attach,
    capabilities = capabilities,
    settings = {
        java = {
            configuration = {
                runtimes = {
                    {
                        name = "JavaSE-17",
                        path = "/usr/lib/jvm/java-17-openjdk/", -- Adjust this path to your Java installation
                    },
                },
            },
            workspace = {
                fileWatch = {
                    enable = true,
                },
            },
        },
    },
    init_options = {
        bundles = {
            vim.fn.glob("~/.local/share/nvim/java-debug/com.microsoft.java.debug.plugin/target/com.microsoft.java.debug.plugin-*.jar", 1),
        },
    },
    -- Custom handlers for progress notifications
    -- Get rid of the annoying progress notifications
    handlers = {
        ['language/status'] = function(_, result)
            vim.print('***')
        end,
        ['$/progress'] = function(_, result, ctx)
            vim.print('---')
        end,
    },
})

-- Rust (rust-analyzer)
lspconfig.rust_analyzer.setup({
  settings = {
    ["rust-analyzer"] = {
      -- can Enable clippy diagnostics on save
      checkOnSave = {
        enable = false,
      },
      cachePriming = { enable = false }, -- FIX: Disable to prevent "querying metadata" hang
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
        allFeatures = false, -- FIX: Changed from true to prevent slow metadata queries
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

    -- Define the function globally
    function _G.toggle_inlay_hints()
      local bufnr = vim.api.nvim_get_current_buf()
      local enabled = vim.lsp.inlay_hint.is_enabled({ bufnr = bufnr })
      vim.lsp.inlay_hint.enable(not enabled, { bufnr = bufnr })
    end


    -- Keymap to toggle inlay hints
    buf_map("n", "<leader>ih", "<cmd>lua toggle_inlay_hints()<CR>")

    -- Enable inlay hints by default if supported
    if client.supports_method("textDocument/inlayHint") then
      vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
    end

    -- Print a message when Rust LSP attaches
    print("rust-ready")
  end,
})


-- C/C++ (clangd)
lspconfig.clangd.setup({
    cmd = {
        "clangd",
        "--background-index",
        "--clang-tidy",
        "--completion-style=detailed",
        "--header-insertion=never",
        "-j=4",
        "--offset-encoding=utf-16",
    },
    root_dir = function(fname)
        return util.root_pattern("compile_commands.json", "compile_flags.txt", "CMakeLists.txt", ".git")(fname)
               or util.find_git_ancestor(fname)
    end,
    on_attach = on_attach,
    capabilities = capabilities,
})

-- TypeScript/JavaScript (tsserver via typescript-language-server)
lspconfig.ts_ls.setup({
    cmd = { "typescript-language-server", "--stdio" },
    root_dir = util.root_pattern("package.json", "tsconfig.json", ".git"),
    init_options = {
        preferences = {
            includeInlayParameterNameHints = "all",
            includeInlayParameterNameHintsWhenArgumentMatchesName = true,
            includeInlayFunctionParameterTypeHints = true,
            includeInlayVariableTypeHints = true,
            includeInlayPropertyDeclarationTypeHints = true,
            includeInlayFunctionLikeReturnTypeHints = true,
        },
    },
    on_attach = function(client, bufnr)
        client.server_capabilities.documentFormattingProvider = false
        on_attach(client, bufnr)
    end,
    capabilities = capabilities,
})

-- ESLint (formatting + linting)
lspconfig.eslint.setup({
    on_attach = function(client, bufnr)
        vim.api.nvim_create_autocmd("BufWritePre", {
            buffer = bufnr,
            command = "EslintFixAll",
        })
        on_attach(client, bufnr)
    end,
    capabilities = capabilities,
})

-- Python (pyright)
lspconfig.pyright.setup({
    on_attach = on_attach,
    capabilities = capabilities,
})

-- Ruff (linting/formatting for Python)
lspconfig.ruff.setup({
    on_attach = on_attach,
    capabilities = capabilities,
})

-- Lua (neovim runtime)
lspconfig.lua_ls.setup({
    settings = {
        Lua = {
            runtime = { version = "LuaJIT" },
            diagnostics = { globals = { "vim" } },
            workspace = { library = vim.api.nvim_get_runtime_file("lua", true) },
            telemetry = { enable = false },
        },
    },
    on_attach = on_attach,
    capabilities = capabilities,
})

-- Bash (shell scripts)
lspconfig.bashls.setup({
    on_attach = on_attach,
    capabilities = capabilities,
})

-- YAML
lspconfig.yamlls.setup({
    settings = { yaml = { keyOrdering = false } },
    on_attach = on_attach,
    capabilities = capabilities,
})

-- Go (gopls)
lspconfig.gopls.setup({
  cmd = { "gopls" },  -- if Mason installed it, this should just work
  filetypes = { "go", "gomod" },
  root_dir = util.root_pattern("go.mod", ".git"),
  settings = {
    gopls = {
      -- Core features
      completeUnimported = true,        -- suggest completions for packages not yet imported
      usePlaceholders = true,           -- for function/placeholders in completion responses
      staticcheck = true,               -- enable more static analyses (linting)

      -- Formatting / imports
      gofumpt = false,                  -- if you prefer `gofumpt` strict formatting
      -- local = "your.module/path",    -- (optional) for import grouping: sets local prefix 

      -- Build/Workspace control
      buildFlags = { "-tags=integration" },  -- example for custom build tags
      env = { GOFLAGS = "-mod=readonly" },   -- example: pass env through gopls
      directoryFilters = { "-**/vendor" },   -- exclude big vendor folders

      -- Experimental / advanced
      analyses = {
        unusedparams = true,
        unreachable = true,
        nilness = true,
      },
      codelenses = {
        generate = true,   -- show `//go:generate` lens
        tidy = true,       -- show `go mod tidy` lens
      },
    },
  },
  on_attach = function(client, bufnr)
    -- your keymaps for Go
    local buf_map = function(mode, lhs, rhs, opts)
      opts = opts or { noremap = true, silent = true }
      vim.api.nvim_buf_set_keymap(bufnr, mode, lhs, rhs, opts)
    end

    buf_map("n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>")
    buf_map("n", "K",  "<cmd>lua vim.lsp.buf.hover()<CR>")
    buf_map("n", "<leader>ca", "<cmd>lua vim.lsp.buf.code_action()<CR>")
    buf_map("n", "<leader>rn", "<cmd>lua vim.lsp.buf.rename()<CR>")
    buf_map("n", "rf", "<cmd>lua vim.lsp.buf.format({ async = true })<CR>")

    print("go-ls ready")
  end,
})

-- vim.diagnostic.config({
--     virtual_text = false, -- Disable inline diagnostics
--     signs = true,         -- Keep signs in the gutter
--     underline = true,     -- Underline problematic code
--     update_in_insert = false, -- Don't update diagnostics while typing
-- })

-- OLD config

-- -- lsp.lua
-- -- LSP configuration for Java, Rust, and C

-- -- Ensure you have installed nvim-lspconfig:
-- -- e.g., with your package manager or Lazy.nvim later.
-- local lspconfig = require("lspconfig")
-- local util = require("lspconfig.util")

-- -- Configure Java LSP (jdtls) - make sure jdtls is installed on your system.
-- lspconfig.jdtls.setup({
--   -- Basic configuration for jdtls; add your own settings if needed.
--   cmd = { "jdtls" },
--   root_dir = lspconfig.util.root_pattern("gradlew", "mvnw", ".git"),
-- })

-- -- Ensure the lspconfig module is required
-- local lspconfig = require('lspconfig')

-- -- Configure rust-analyzer
-- lspconfig.rust_analyzer.setup({
--   settings = {
--     ["rust-analyzer"] = {
--       -- can Enable clippy diagnostics on save
--       checkOnSave = {
--         enable = false,
--       },
--       cachePriming = { enable = false },
--       -- Enable inlay hints
--       inlayHints = {
--         enable = true,
--         typeHints = true,
--         chainingHints = true,
--         parameterHints = true, -- Show parameter hints
--         maxLength = 30, -- Limit the length of inlay hints
--       },
--       -- Enable proc macro support
--       -- This is necessary for procedural macros to work correctly
--       -- in Rust projects using macros like `serde_derive` or `rocket`
--       procMacro = {
--         enable = true,
--       },
--       -- Enable automatic formatting
--       rustfmt = {
--         overrideCommand = { "rustfmt", "--edition", "2024" },
--         config = "~/.config/rustfmt/rustfmt.toml",
--       },
--       cargo = {
--         allFeatures = true,
--         -- targetDir = "target/rust-analyzer",
--       },
--       imports = {
--         group = {
--           enable = false,
--         },
--       },
--       lsp = {
--         progress = {
--           enable = false, -- Disable progress notifications
--         },
--       },
--       completion = {
--         postfix = {
--           enable = true, -- Enable postfix completions like `.unwrap`
--         },
--         -- autoimport = {
--         --   enable = true, -- Automatically import missing items
--         -- },
--       },
--       experimental = {
--         enable = true,
--       },
--     },
--   },
--   on_attach = function(client, bufnr)
--     -- Key mappings for Rust LSP features
--     local buf_map = function(mode, lhs, rhs, opts)
--       opts = opts or { noremap = true, silent = true }
--       vim.api.nvim_buf_set_keymap(bufnr, mode, lhs, rhs, opts)
--     end

--     -- Example mappings:
--     buf_map("n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>")        -- Go to definition
--     buf_map("n", "K", "<cmd>lua vim.lsp.buf.hover()<CR>")              -- Hover documentation
--     buf_map("n", "<leader>ca", "<cmd>lua vim.lsp.buf.code_action()<CR>") -- Code actions
--     buf_map("n", "<leader>rn", "<cmd>lua vim.lsp.buf.rename()<CR>")    -- Rename symbol
--     buf_map("n", "rf", "<cmd>lua vim.lsp.buf.format({ async = true })<CR>") -- Format Code

--     -- Define the function globally
--     function _G.toggle_inlay_hints()
--       local bufnr = vim.api.nvim_get_current_buf()
--       local enabled = vim.lsp.inlay_hint.is_enabled({ bufnr = bufnr })
--       vim.lsp.inlay_hint.enable(not enabled, { bufnr = bufnr })
--     end


--     -- Keymap to toggle inlay hints
--     buf_map("n", "<leader>ih", "<cmd>lua toggle_inlay_hints()<CR>")

--     -- Enable inlay hints if supported
--     if client.supports_method("textDocument/inlayHint") then
--       -- vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
--       print("inlay-hints-available")
--     end

--     -- Print a message when Rust LSP attaches
--     print("rust-ready")
--   end,
-- })


-- -- Configure C/C++ LSP (clangd) - ensure clangd is installed
-- lspconfig.clangd.setup({
--   cmd = {
--     "clangd",                     -- The clangd binary must be in your PATH
--     "--background-index",         -- Persistent indexing for all files
--     "--clang-tidy",               -- Enable clang-tidy diagnostics
--     "--completion-style=detailed",-- Show parameter names & types in completion
--     "--header-insertion=never",   -- Disable auto-#include insertion (alt: "iwyu")
--     "-j=4",                       -- Four worker threads (adjust for your CPU)
--     "--offset-encoding=utf-16",
--     "--suggest-missing-includes",
--     "--log=info",
--   },

--   -- Determine project root by looking for compile_commands.json, CMakeLists.txt, or .git
--   root_dir = function(fname)
--     return util.root_pattern(
--       "compile_commands.json",
--       "compile_flags.txt",
--       "CMakeLists.txt",
--       ".git"
--     )(fname) or util.find_git_ancestor(fname)
--   end,

--   -- Setup client capabilities (use utf-16)
--   capabilities = (function()
--     local caps = vim.lsp.protocol.make_client_capabilities()
--     caps.offsetEncoding = { "utf-16" }
--     return caps
--   end)(),

--   -- -- Provide fallback flags if compile_commands.json is missing
--   -- init_options = {
--   --   fallbackFlags = { "-std=c++20", "-Wall", "-Wextra" },
--   -- },

--   -- on_attach: set up keymaps, inlay hints, etc.
--   on_attach = function(client, bufnr)
--     local buf_map = function(mode, lhs, rhs, desc)
--       vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = desc })
--     end

--     buf_map("n", "<leader>o", "<cmd>ClangdSwitchSourceHeader<CR>", "Switch Header/Source")
--     buf_map("n", "<leader>i", "<cmd>ClangdSymbolInfo<CR>", "Show Symbol Info")
--     buf_map("n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>", "Go To Definition")
--     buf_map("n", "K", "<cmd>lua vim.lsp.buf.hover()<CR>", "Hover Documentation")
--     buf_map("n", "<leader>rn", "<cmd>lua vim.lsp.buf.rename()<CR>", "Rename Symbol")
--     buf_map("n", "[d", "<cmd>lua vim.diagnostic.goto_prev()<CR>", "Previous Diagnostic")
--     buf_map("n", "]d", "<cmd>lua vim.diagnostic.goto_next()<CR>", "Next Diagnostic")
--   end,
-- })
