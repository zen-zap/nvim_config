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
else
    vim.notify('jdtls not found in PATH. Install with :Mason or pacman -S jdtls', vim.log.levels.WARN)
end

-- Rust (rust-analyzer)
vim.lsp.config('rust_analyzer', {
  settings = {
    ["rust-analyzer"] = {
      checkOnSave = {
        enable = false,
      },
      cachePriming = { enable = false },
      inlayHints = {
        enable = true,
        typeHints = true,
        chainingHints = true,
        parameterHints = true,
        maxLength = 30,
      },
      procMacro = {
        enable = true,
      },
      rustfmt = {
        overrideCommand = { "rustfmt", "--edition", "2024" },
        config = "~/.config/rustfmt/rustfmt.toml",
      },
      cargo = {
        allFeatures = false,
      },
      imports = {
        group = {
          enable = false,
        },
      },
      lsp = {
        progress = {
          enable = false,
        },
      },
      completion = {
        postfix = {
          enable = true,
        },
        autoimport = {
          enable = true,
        },
      },
      experimental = {
        enable = true,
      },
    },
  },
  on_attach = function(client, bufnr)
    local buf_map = function(mode, lhs, rhs, opts)
      opts = opts or { noremap = true, silent = true }
      vim.api.nvim_buf_set_keymap(bufnr, mode, lhs, rhs, opts)
    end

    buf_map("n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>")
    buf_map("n", "K", "<cmd>lua vim.lsp.buf.hover()<CR>")
    buf_map("n", "<leader>ca", "<cmd>lua vim.lsp.buf.code_action()<CR>")
    buf_map("n", "<leader>rn", "<cmd>lua vim.lsp.buf.rename()<CR>")
    buf_map("n", "rf", "<cmd>lua vim.lsp.buf.format({ async = true })<CR>")

    function _G.toggle_inlay_hints()
      local bufnr = vim.api.nvim_get_current_buf()
      local enabled = vim.lsp.inlay_hint.is_enabled({ bufnr = bufnr })
      vim.lsp.inlay_hint.enable(not enabled, { bufnr = bufnr })
    end

    buf_map("n", "<leader>ih", "<cmd>lua toggle_inlay_hints()<CR>")

    if client.supports_method("textDocument/inlayHint") then
      vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
    end

    print("rust-ready")
  end,
})
vim.lsp.enable('rust_analyzer')

-- C/C++ (clangd)
vim.lsp.config('clangd', {
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
vim.lsp.enable('clangd')

-- TypeScript/JavaScript (tsserver via typescript-language-server)
vim.lsp.config('ts_ls', {
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
vim.lsp.enable('ts_ls')

-- ESLint (formatting + linting)
vim.lsp.config('eslint', {
    on_attach = function(client, bufnr)
        vim.api.nvim_create_autocmd("BufWritePre", {
            buffer = bufnr,
            command = "EslintFixAll",
        })
        on_attach(client, bufnr)
    end,
    capabilities = capabilities,
})
vim.lsp.enable('eslint')

-- Python (pyright)
vim.lsp.config('pyright', {
    on_attach = on_attach,
    capabilities = capabilities,
})
vim.lsp.enable('pyright')

-- Ruff (linting/formatting for Python)
vim.lsp.config('ruff', {
    on_attach = on_attach,
    capabilities = capabilities,
})
vim.lsp.enable('ruff')

-- Lua (neovim runtime)
vim.lsp.config('lua_ls', {
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
vim.lsp.enable('lua_ls')

-- Bash (shell scripts)
vim.lsp.config('bashls', {
    on_attach = on_attach,
    capabilities = capabilities,
})
vim.lsp.enable('bashls')

-- YAML
vim.lsp.config('yamlls', {
    settings = { yaml = { keyOrdering = false } },
    on_attach = on_attach,
    capabilities = capabilities,
})
vim.lsp.enable('yamlls')

-- Go (gopls)
vim.lsp.config('gopls', {
  cmd = { "gopls" },
  filetypes = { "go", "gomod" },
  root_dir = util.root_pattern("go.mod", ".git"),
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
  on_attach = function(client, bufnr)
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
vim.lsp.enable('gopls')
