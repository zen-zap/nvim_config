-- lua/config/lsp.lua
-- Language Server Protocol Configuration using Neovim native API

local util = require("lspconfig.util")

-- Load Telescope; on_attach will fall back to native LSP mappings if unavailable.
local has_telescope, telescope = pcall(require, "telescope.builtin")

-- Helper to check if command exists
local function has_cmd(cmd)
    return vim.fn.executable(cmd) == 1
end

-- Common on_attach function for all servers
local function on_attach(client, bufnr)
    local buf_map = function(mode, lhs, rhs, desc)
        vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = desc })
    end

    if has_telescope then
        buf_map('n', 'gd', telescope.lsp_definitions, "Go to Definition")
        buf_map('n', 'gD', vim.lsp.buf.declaration, "Go to Declaration") -- Native (Telescope doesn't have this)
        buf_map('n', 'gi', telescope.lsp_implementations, "Go to Implementation")      
        buf_map('n', 'gR', telescope.lsp_references, "Go to References") 
        buf_map('n', 'gy', telescope.lsp_type_definitions, "Go to Type Definition")
        buf_map('n', '<leader>s', telescope.lsp_dynamic_workspace_symbols, "Search Workspace Symbols")
    else
        buf_map('n', 'gd', vim.lsp.buf.definition, "Go to Definition")
        buf_map('n', 'gD', vim.lsp.buf.declaration, "Go to Declaration")
        buf_map('n', 'gi', vim.lsp.buf.implementation, "Go to Implementation")     
        buf_map('n', 'gR', vim.lsp.buf.references, "Go to References") 
        buf_map('n', 'gy', vim.lsp.buf.type_definition, "Go to Type Definition")
        buf_map('n', '<leader>s', vim.lsp.buf.workspace_symbol, "Search Workspace Symbols")
    end

    -- Core LSP actions (These don't use Telescope)
    buf_map('n', 'gl', vim.diagnostic.open_float, "Show Diagnostics")     
    buf_map('n', 'K', vim.lsp.buf.hover, "Hover Documentation")
    buf_map('n', '<leader>rn', vim.lsp.buf.rename, "Rename Symbol")
    buf_map('n', '<leader>ca', vim.lsp.buf.code_action, "Code Action")
    
    buf_map('n', '[d', function() vim.diagnostic.jump({ count = -1, float = true }) end, "Previous Diagnostic")
    buf_map('n', ']d', function() vim.diagnostic.jump({ count = 1, float = true }) end, "Next Diagnostic")

    -- Inlay hints toggle if supported
    if client:supports_method("textDocument/inlayHint") then
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

-- Enable file watching so rust-analyzer (and others) get notified when
-- Cargo.toml / Cargo.lock change after `cargo add` or manual edits.
capabilities.workspace = vim.tbl_deep_extend("force", capabilities.workspace or {}, {
  didChangeWatchedFiles = {
    dynamicRegistration = true,
    relativePatternSupport = true,
  },
})

-- Java (jdtls)
if has_cmd('jdtls') then
  vim.api.nvim_create_autocmd("FileType", {
    pattern = "java",
    callback = function(ev)
      local bufname = vim.api.nvim_buf_get_name(ev.buf)
      local root_dir = util.root_pattern(".git", "pom.xml", "build.gradle", "settings.gradle")(bufname) or vim.fn.getcwd()
      
      vim.lsp.start({
        name = 'jdtls',
        cmd = { "jdtls" },
        root_dir = root_dir,
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
                workspace = { fileWatch = { enable = true } },
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
    end,
  })
end

-- Rust (rust-analyzer)
if has_cmd('rust-analyzer') then
  local function find_rust_root(fname)
    return util.root_pattern("rust-project.json")(fname)
        or util.root_pattern("Cargo.lock")(fname)
        or util.root_pattern("Cargo.toml")(fname)
  end

  vim.api.nvim_create_autocmd("FileType", {
    pattern = "rust",
    callback = function(ev)
      local bufname = vim.api.nvim_buf_get_name(ev.buf)
      local root_dir = find_rust_root(bufname)

      if not root_dir then return end

      local ra_cmd = vim.fn.expand("~/.cargo/bin/rust-analyzer")
      if vim.fn.executable(ra_cmd) ~= 1 then
        ra_cmd = "rust-analyzer" 
      end

      vim.lsp.start({
        name = 'rust_analyzer',
        cmd = { ra_cmd },
        root_dir = root_dir,
        capabilities = capabilities,
        settings = {
          ["rust-analyzer"] = {
            checkOnSave = { enable = true },          
            check = { command = "clippy" },
            cargo = { features = "all", buildScripts = { enable = true } },
            procMacro = { enable = true },
            rustfmt = { rangeFormatting = { enable = true } },
            inlayHints = {
              enable = true,
              typeHints = { enable = true },
              chainingHints = { enable = true },
              parameterHints = { enable = true },
              maxLength = 30,
              closureReturnTypeHints = { enable = "with_block" },
              lifetimeElisionHints = { enable = "skip_trivial", useParameterNames = true },
              discriminantHints = { enable = "fieldless" },
              closingBraceHints = { enable = true, minLines = 20 },
            },
            lens = { enable = true, run = { enable = true }, debug = { enable = true }, implementations = { enable = true } },
            diagnostics = { enable = true, styleLints = { enable = true } },
            completion = { fullFunctionSignatures = { enable = true } },
            workspace = { symbol = { search = { scope = "workspace_and_dependencies", kind = "all_symbols" } } },
          },
        },
        on_attach = function(client, bufnr)
          on_attach(client, bufnr)
          vim.keymap.set('n', 'rf', vim.lsp.buf.format, { buffer = bufnr, desc = "Format Rust" })

          local fmt_group = vim.api.nvim_create_augroup("rust_format_" .. bufnr, { clear = true })
          
          vim.api.nvim_create_autocmd("BufWritePre", {
            buffer = bufnr,
            group = fmt_group,
            callback = function()
              vim.lsp.buf.format({ async = false, bufnr = bufnr })
            end,
          })

          vim.api.nvim_create_autocmd("InsertLeave", {
            buffer = bufnr,
            group = fmt_group,
            callback = function()
              vim.lsp.buf.format({ async = true, bufnr = bufnr })
            end,
          })
        end,
      })
    end,
  })
end

-- C/C++ (clangd)
if has_cmd('clangd') then
  vim.api.nvim_create_autocmd("FileType", {
    pattern = { "c", "cpp", "objc", "objcpp", "cuda" },
    callback = function(ev)
      local bufname = vim.api.nvim_buf_get_name(ev.buf)
      local root_dir = util.root_pattern("compile_commands.json", "compile_flags.txt", "CMakeLists.txt", ".git")(bufname) or vim.fn.getcwd()
      
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
        on_attach = on_attach,
      })
    end,
  })
end

-- TypeScript/JavaScript (ts_ls)
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

-- ESLint
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
            local lint_group = vim.api.nvim_create_augroup("eslint_fix_" .. bufnr, { clear = true })
            vim.api.nvim_create_autocmd("BufWritePre", {
                buffer = bufnr,
                group = lint_group,
                command = "EslintFixAll",
            })
            on_attach(client, bufnr)
        end,
      })
    end,
  })
end

-- Python (pyright)
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

-- Ruff
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

-- Lua
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

-- Bash
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

-- YAML
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

-- Go (gopls)
if has_cmd('gopls') then
  vim.api.nvim_create_autocmd("FileType", {
    pattern = { "go", "gomod" },
    callback = function(ev)
      local bufname = vim.api.nvim_buf_get_name(ev.buf)
      local root_dir = util.root_pattern("go.mod")(bufname) or util.root_pattern(".git")(bufname)
      
      if not root_dir then return end
      
      vim.lsp.start({
        name = 'gopls',
        cmd = { "gopls" },
        root_dir = root_dir,
        capabilities = capabilities,
        workspace_folders = {
          { uri = vim.uri_from_fname(root_dir), name = vim.fn.fnamemodify(root_dir, ":t") },
        },
        settings = {
          gopls = {
            completeUnimported = true,
            usePlaceholders = true,
            staticcheck = true,
            gofumpt = true,
            buildFlags = { "-tags=integration" },
            env = { GOFLAGS = "-mod=readonly" },
            directoryFilters = { "-**/vendor" },
            analyses = { unusedparams = true, unreachable = true, nilness = true },
            codelenses = { generate = true, tidy = true },
          },
        },
        on_attach = on_attach,
      })
    end,
  })
end