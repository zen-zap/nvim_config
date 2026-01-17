-- Use new nvim 0.11+ LSP config API (not require('lspconfig'))
local util = require("lspconfig.util")

-- Helper to check if command exists
local function has_cmd(cmd)
    return vim.fn.executable(cmd) == 1
end

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

-- Java (jdtls) - only enable if executable exists
if has_cmd('jdtls') then
    vim.lsp.config('jdtls', {
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
                            path = "/usr/lib/jvm/java-17-openjdk/",
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
            bundles = vim.split(vim.fn.glob("~/.local/share/nvim/java-debug/com.microsoft.java.debug.plugin/target/com.microsoft.java.debug.plugin-*.jar"), '\n', true),
        },
        handlers = {
            ['language/status'] = function() end,
            ['$/progress'] = function() end,
        },
    })
    vim.lsp.enable('jdtls')
end
-- Note: jdtls silently skipped if not installed

-- Rust (rust-analyzer) - only enable for Rust files
if has_cmd('rust-analyzer') then
  -- Auto-start for Rust files
  vim.api.nvim_create_autocmd("FileType", {
    pattern = "rust",
    callback = function(ev)
      local bufname = vim.api.nvim_buf_get_name(ev.buf)
      local root_dir = util.root_pattern("Cargo.toml", "rust-project.json")(bufname)
      
      if not root_dir then
        return
      end
      
      vim.lsp.start({
        name = 'rust_analyzer',
        cmd = { "rust-analyzer" },
        root_dir = root_dir,
        capabilities = capabilities,
        settings = {
          ["rust-analyzer"] = {
            -- Note: Per-project rust-analyzer.toml will override these
            checkOnSave = {
              enable = false,
            },
            cargo = {
              allFeatures = false,
              -- Will be overridden by rust-analyzer.toml if present
            },
            procMacro = {
              enable = true,  -- Override in rust-analyzer.toml for blog_os
            },
            rustfmt = {
              overrideCommand = { "rustfmt", "--edition", "2024" },
            },
            inlayHints = {
              enable = true,
              typeHints = true,
              chainingHints = true,
              parameterHints = true,
              maxLength = 30,
            },
            lens = {
              enable = true,
              run = { enable = true },
              debug = { enable = true },
              implementations = { enable = true },
              references = {
                adt = { enable = true },
                enumVariant = { enable = true },
                method = { enable = true },
                trait = { enable = true },
              },
            },
          },
        },
        on_attach = function(client, bufnr)
          on_attach(client, bufnr)
          
          -- Rust-specific format keymap
          vim.keymap.set('n', 'rf', vim.lsp.buf.format, { buffer = bufnr, desc = "Format Rust" })

          -- Enable inlay hints
          if client.supports_method("textDocument/inlayHint") then
            vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
          end
          
          vim.notify("rust-analyzer ready", vim.log.levels.INFO)
        end,
      })
    end,
  })
end

-- C/C++ (clangd) - only enable for C/C++ files
if has_cmd('clangd') then
  vim.api.nvim_create_autocmd("FileType", {
    pattern = { "c", "cpp", "objc", "objcpp", "cuda" },
    callback = function(ev)
      local bufname = vim.api.nvim_buf_get_name(ev.buf)
      local root_dir = util.root_pattern("compile_commands.json", "compile_flags.txt", "CMakeLists.txt", ".git")(bufname)
                       or vim.fn.getcwd()
      
      vim.lsp.start({
        name = 'clangd',
        cmd = {
            "clangd",
            "--background-index",
            "--clang-tidy",
            "--completion-style=detailed",
            "--header-insertion=never",
            "-j=4",
            "--offset-encoding=utf-16",
        },
        root_dir = root_dir,
        capabilities = capabilities,
        on_attach = function(client, bufnr)
          on_attach(client, bufnr)
          vim.notify("clangd attached", vim.log.levels.INFO)
        end,
      })
    end,
  })
end

-- TypeScript/JavaScript - only enable for TS/JS files
if has_cmd('typescript-language-server') then
  vim.api.nvim_create_autocmd("FileType", {
    pattern = { "javascript", "javascriptreact", "typescript", "typescriptreact" },
    callback = function(ev)
      local bufname = vim.api.nvim_buf_get_name(ev.buf)
      local root_dir = util.root_pattern("package.json", "tsconfig.json", ".git")(bufname) or vim.fn.getcwd()
      
      vim.lsp.start({
        name = 'ts_ls',
        cmd = { "typescript-language-server", "--stdio" },
        root_dir = root_dir,
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
        capabilities = capabilities,
        on_attach = function(client, bufnr)
            client.server_capabilities.documentFormattingProvider = false
            on_attach(client, bufnr)
        end,
      })
    end,
  })
end

-- ESLint - only enable for JS/TS files
if has_cmd('vscode-eslint-language-server') then
  vim.api.nvim_create_autocmd("FileType", {
    pattern = { "javascript", "javascriptreact", "typescript", "typescriptreact", "vue", "svelte" },
    callback = function(ev)
      local bufname = vim.api.nvim_buf_get_name(ev.buf)
      local root_dir = util.root_pattern(".eslintrc", ".eslintrc.js", ".eslintrc.json", "package.json")(bufname) or vim.fn.getcwd()
      
      vim.lsp.start({
        name = 'eslint',
        cmd = { "vscode-eslint-language-server", "--stdio" },
        root_dir = root_dir,
        capabilities = capabilities,
        on_attach = function(client, bufnr)
            vim.api.nvim_create_autocmd("BufWritePre", {
                buffer = bufnr,
                command = "EslintFixAll",
            })
            on_attach(client, bufnr)
        end,
      })
    end,
  })
end

-- Python (pyright) - only enable for Python files
if has_cmd('pyright-langserver') then
  vim.api.nvim_create_autocmd("FileType", {
    pattern = "python",
    callback = function(ev)
      local bufname = vim.api.nvim_buf_get_name(ev.buf)
      local root_dir = util.root_pattern("pyproject.toml", "setup.py", "requirements.txt", ".git")(bufname) or vim.fn.getcwd()
      
      vim.lsp.start({
        name = 'pyright',
        cmd = { "pyright-langserver", "--stdio" },
        root_dir = root_dir,
        capabilities = capabilities,
        on_attach = on_attach,
      })
    end,
  })
end

-- Ruff (Python linting/formatting) - only enable for Python files
if has_cmd('ruff') then
  vim.api.nvim_create_autocmd("FileType", {
    pattern = "python",
    callback = function(ev)
      local bufname = vim.api.nvim_buf_get_name(ev.buf)
      local root_dir = util.root_pattern("pyproject.toml", "ruff.toml", ".git")(bufname) or vim.fn.getcwd()
      
      vim.lsp.start({
        name = 'ruff',
        cmd = { "ruff", "server" },
        root_dir = root_dir,
        capabilities = capabilities,
        on_attach = on_attach,
      })
    end,
  })
end

-- Lua - only enable for Lua files
if has_cmd('lua-language-server') then
  vim.api.nvim_create_autocmd("FileType", {
    pattern = "lua",
    callback = function(ev)
      local bufname = vim.api.nvim_buf_get_name(ev.buf)
      local root_dir = util.root_pattern(".luarc.json", ".stylua.toml", "stylua.toml", ".git")(bufname) or vim.fn.getcwd()
      
      vim.lsp.start({
        name = 'lua_ls',
        cmd = { "lua-language-server" },
        root_dir = root_dir,
        capabilities = capabilities,
        settings = {
            Lua = {
                runtime = { version = "LuaJIT" },
                diagnostics = { globals = { "vim" } },
                workspace = { library = vim.api.nvim_get_runtime_file("lua", true) },
                telemetry = { enable = false },
            },
        },
        on_attach = on_attach,
      })
    end,
  })
end

-- Bash - only enable for shell scripts
if has_cmd('bash-language-server') then
  vim.api.nvim_create_autocmd("FileType", {
    pattern = { "sh", "bash" },
    callback = function(ev)
      vim.lsp.start({
        name = 'bashls',
        cmd = { "bash-language-server", "start" },
        root_dir = vim.fn.getcwd(),
        capabilities = capabilities,
        on_attach = on_attach,
      })
    end,
  })
end

-- YAML - only enable for YAML files
if has_cmd('yaml-language-server') then
  vim.api.nvim_create_autocmd("FileType", {
    pattern = "yaml",
    callback = function(ev)
      vim.lsp.start({
        name = 'yamlls',
        cmd = { "yaml-language-server", "--stdio" },
        root_dir = vim.fn.getcwd(),
        capabilities = capabilities,
        settings = { yaml = { keyOrdering = false } },
        on_attach = on_attach,
      })
    end,
  })
end

-- Go (gopls) - only enable for Go files
if has_cmd('gopls') then
  vim.api.nvim_create_autocmd("FileType", {
    pattern = { "go", "gomod" },
    callback = function(ev)
      local bufname = vim.api.nvim_buf_get_name(ev.buf)
      local root_dir = util.root_pattern("go.mod", ".git")(bufname) or vim.fn.getcwd()
      
      vim.lsp.start({
        name = 'gopls',
        cmd = { "gopls" },
        root_dir = root_dir,
        capabilities = capabilities,
        settings = {
          gopls = {
            completeUnimported = true,
            usePlaceholders = true,
            staticcheck = true,
            gofumpt = true,
            buildFlags = { "-tags=integration" },
            env = { GOFLAGS = "-mod=readonly" },
            directoryFilters = { "-**/vendor" },
            analyses = {
              unusedparams = true,
              unreachable = true,
              nilness = true,
            },
            codelenses = {
              generate = true,
              tidy = true,
            },
          },
        },
        on_attach = on_attach,
      })
    end,
  })
end
