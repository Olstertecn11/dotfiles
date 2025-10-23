-- =========================
-- General setup
-- =========================
local protocol = require("vim.lsp.protocol")

local augroup_format = vim.api.nvim_create_augroup("Format", { clear = true })
local enable_format_on_save = function(_, bufnr)
  vim.api.nvim_clear_autocmds({ group = augroup_format, buffer = bufnr })
  vim.api.nvim_create_autocmd("BufWritePre", {
    group = augroup_format,
    buffer = bufnr,
    callback = function()
      vim.lsp.buf.format({ bufnr = bufnr })
    end,
  })
end

local on_attach = function(client, bufnr)
  local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
  local opts = { noremap = true, silent = true }
  -- tus keymaps aquí si quieres
end

-- Icons para completion
protocol.CompletionItemKind = {
  "", "", "", "", "", "", "", "ﰮ", "", "",
  "", "", "", "", "﬌", "", "", "", "", "",
  "", "", "", "ﬦ", "",
}

-- =========================
-- Servidores
-- =========================
local servers = {
  astro = {
    cmd = { "astro-ls", "--stdio" },
  },
  ts_ls = {
    cmd = { "typescript-language-server", "--stdio" },
    filetypes = {
      "typescript", "typescriptreact", "typescript.tsx",
      "javascript", "javascriptreact", "javascript.jsx",
    },
  },
  clangd = {
    filetypes = { "c", "cpp", "h", "isa" },
  },
  sqlls = {
    cmd = { "sql-language-server", "up", "--method", "--stdio" },
    filetypes = { "sql", "mysql" },
    root_dir = function() return vim.loop.cwd() end,
  },
  lua_ls = {
    settings = {
      Lua = {
        diagnostics = { globals = { "vim" } },
        workspace = {
          library = vim.api.nvim_get_runtime_file("", true),
          checkThirdParty = false,
        },
        completion = { callSnippet = "Replace" },
      },
    },
  },
  html = {
    capabilities = vim.lsp.protocol.make_client_capabilities(),
  },
  cssls = {
    capabilities = vim.lsp.protocol.make_client_capabilities(),
    single_file_support = true,
  },
  dartls = {
    cmd = { "dart", "language-server", "--protocol=lsp" },
    filetypes = { "dart" },
    init_options = {
      closingLabels = true,
      flutterOutline = true,
      onlyAnalyzeProjectsWithOpenFiles = true,
      outline = true,
      suggestFromUnimportedLibraries = true,
    },
  },
  rust_analyzer = {},
  jsonls = {},
  pylsp = {
    settings = {
      pylsp = {
        plugins = {
          pycodestyle = {
            ignore = { "W391" },
            maxLineLength = 100,
          },
        },
      },
    },
  },
  vimls = {
    cmd = { "vim-language-server", "--stdio" },
    filetypes = { "vim" },
  },
}

-- Registrar y habilitar todos
for server, config in pairs(servers) do
  vim.lsp.config(server, vim.tbl_extend("force", config, {
    on_attach = function(client, bufnr)
      on_attach(client, bufnr)
      enable_format_on_save(client, bufnr)
    end,
  }))
  vim.lsp.enable(server)
end

-- =========================
-- Diagnostics config
-- =========================
vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
  vim.lsp.diagnostic.on_publish_diagnostics, {
    underline = true,
    update_in_insert = false,
    virtual_text = { spacing = 4, prefix = "●" },
    severity_sort = true,
  }
)

local signs = { Error = " ", Warn = " ", Hint = " ", Info = " " }
for type, icon in pairs(signs) do
  local hl = "DiagnosticSign" .. type
  vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
end

vim.diagnostic.config({
  virtual_text = { prefix = "●" },
  update_in_insert = true,
  float = { source = "always" },
})
