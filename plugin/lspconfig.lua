-- =========================
-- General setup
-- =========================
local protocol = require("vim.lsp.protocol")
local lspconfig_avail, lspconfig = pcall(require, "lspconfig") -- Fallback seguro si usas lspconfig detrás de escena

local augroup_format = vim.api.nvim_create_augroup("Format", { clear = true })
local enable_format_on_save = function(client, bufnr)
  vim.api.nvim_clear_autocmds({ group = augroup_format, buffer = bufnr })
  vim.api.nvim_create_autocmd("BufWritePre", {
    group = augroup_format,
    buffer = bufnr,
    callback = function()
      vim.lsp.buf.format({
        bufnr = bufnr,
        filter = function(f_client)
          -- Evita colisiones de formateo en archivos .vue dejando que solo vue_ls maneje el buffer
          if vim.bo[bufnr].filetype == "vue" then
            return f_client.name == "vue_ls"
          end
          -- Evitamos que Copilot intente formatear el código si se mete como cliente activo
          if f_client.name == "GitHub Copilot" or f_client.name == "copilot" then
            return false
          end
          return true
        end,
      })
    end,
  })
end

local on_attach = function(client, bufnr)
  -- Ignorar configuraciones conflictivas de Copilot en comandos globales
  if client.name == "GitHub Copilot" then
    return
  end

  local opts = { noremap = true, silent = true }
  -- Aquí puedes añadir tus atajos nativos como vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
end

-- Icons para completion
protocol.CompletionItemKind = {
  "", "", "", "", "", "", "", "ﰮ", "", "",
  "", "", "", "", "﬌", "", "", "", "", "",
  "", "", "", "ﬦ", "",
}

-- Definición de la ruta de Vue Language Server corregida de forma nativa para el PATH de Windows
local mason_apps_path = vim.fs.normalize(vim.fn.stdpath("data") ..
  "/mason/packages/vue-language-server/node_modules/@vue/language-server")

-- =========================
-- Servidores
-- =========================
local servers = {
  astro = {
    cmd = { "astro-ls", "--stdio" },
  },

  -- Soporte para TypeScript, React y Vue (Modo Híbrido)
  ts_ls = {
    cmd = { "typescript-language-server", "--stdio" },
    filetypes = {
      "typescript", "typescriptreact", "typescript.tsx",
      "javascript", "javascriptreact", "javascript.jsx",
      "vue",
    },
    root_dir = function()
      return vim.fs.dirname(vim.fs.find({ "package.json", "tsconfig.json", ".git" }, { upward = true })[1])
          or vim.uv.cwd()
    end,
    init_options = {
      plugins = {
        {
          name = "@vue/language-server",
          location = mason_apps_path,
          languages = { "vue" },
          configNamespace = "typescript",
          enableForWorkspaceTypeScriptVersions = true,
        },
      },
    },
  },

  vue_ls = {
    cmd = { "vue-language-server", "--stdio" },
    filetypes = { "vue" },
    root_dir = function()
      return vim.fs.dirname(vim.fs.find({ "package.json", "tsconfig.json", ".git" }, { upward = true })[1])
          or vim.uv.cwd()
    end,
    init_options = {
      vue = {
        hybridMode = true,
      },
    },
  },

  clangd = {
    filetypes = { "c", "cpp", "h", "isa" },
  },

  sqlls = {
    cmd = { "sql-language-server", "up", "--method", "--stdio" },
    filetypes = { "sql", "mysql" },
    root_dir = function() return vim.uv.cwd() end,
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

-- =========================
-- Registrar y habilitar servidores de forma segura
-- =========================
for server, config in pairs(servers) do
  -- Condición de seguridad extrema: No inicializar servidores que no tengan su binario ejecutable disponible
  local executable_allowed = true
  if config.cmd and config.cmd[1] then
    if vim.fn.executable(config.cmd[1]) == 0 then
      executable_allowed = false
    end
  end

  if executable_allowed then
    -- NUEVO: Obtener las capabilities de blink.cmp si está instalado,
    -- de lo contrario usar las nativas por defecto.
    local capabilities = {}
    local blink_avail, blink = pcall(require, "blink.cmp")
    if blink_avail then
      capabilities = blink.get_lsp_capabilities(config.capabilities)
    else
      capabilities = vim.lsp.protocol.make_client_capabilities()
    end

    -- Estructura unificada para configuraciones nativas modernas de Neovim
    local base_config = {
      capabilities = capabilities, -- <--- NUEVO: Inyectamos las capabilities aquí
      on_attach = function(client, bufnr)
        on_attach(client, bufnr)
        enable_format_on_save(client, bufnr)
      end,
    }

    local final_config = vim.tbl_extend("force", base_config, config)

    -- Soporte híbrido tanto si usas la API nativa moderna v0.10+ o lspconfig tradicional
    if vim.lsp.config then
      vim.lsp.config(server, final_config)
      vim.lsp.enable(server)
    elseif lspconfig_avail then
      lspconfig[server].setup(final_config)
    end
  end
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

vim.diagnostic.config({
  virtual_text = { prefix = "●" },
  update_in_insert = true,
  float = { source = "always" },
  severity_sort = true,
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = " ",
      [vim.diagnostic.severity.WARN]  = " ",
      [vim.diagnostic.severity.HINT]  = " ",
      [vim.diagnostic.severity.INFO]  = " ",
    },
  },
})

-- =========================
-- Comando de reinicio seguro anti-Copilot
-- =========================
vim.api.nvim_create_user_command('LspRestartSafe', function()
  for _, client in ipairs(vim.lsp.get_active_clients()) do
    if client.name ~= "GitHub Copilot" and client.name ~= "copilot" then
      vim.lsp.stop_client(client.id)
    end
  end
  vim.cmd("edit")
  vim.notify("LSP de Vue/TS reiniciado limpiamente", vim.log.levels.INFO)
end, {})
