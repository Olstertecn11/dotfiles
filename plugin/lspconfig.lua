-- ~/.config/nvim/after/plugin/lspconfig.rc.lua
-- o ~/.config/nvim/lua/olster/lspconfig.lua

-- =========================
-- Safe requires
-- =========================
local lspconfig_avail, lspconfig = pcall(require, "lspconfig")

pcall(function()
	require("mason").setup()
end)

pcall(function()
	require("mason-lspconfig").setup({
		ensure_installed = {
			"lua_ls",
			"vtsls",
			"vue_ls",
			"intelephense",
			"tailwindcss",
			"emmet_language_server",
			"html",
			"cssls",
			"jsonls",
			"pylsp",
			"clangd",
			"rust_analyzer",
			"vimls",
		},
	})
end)

-- =========================
-- Capabilities para blink.cmp
-- =========================
local capabilities = vim.lsp.protocol.make_client_capabilities()

local blink_ok, blink = pcall(require, "blink.cmp")
if blink_ok then
	capabilities = blink.get_lsp_capabilities(capabilities)
end

-- =========================
-- Helpers
-- =========================
local function path_from_root_arg(root_arg)
	if type(root_arg) == "number" then
		local name = vim.api.nvim_buf_get_name(root_arg)
		return name ~= "" and name or vim.uv.cwd()
	end

	if type(root_arg) == "string" and root_arg ~= "" then
		return root_arg
	end

	return vim.api.nvim_buf_get_name(0) ~= "" and vim.api.nvim_buf_get_name(0) or vim.uv.cwd()
end

local function get_root_dir(root_arg, on_dir)
	local root = vim.fs.find({
		"package.json",
		"tsconfig.json",
		"jsconfig.json",
		"composer.json",
		"artisan",
		"tailwind.config.js",
		"tailwind.config.ts",
		"vite.config.mjs",
		"vite.config.ts",
		"vite.config.js",
		".git",
	}, {
		upward = true,
		path = path_from_root_arg(root_arg),
	})[1]

	if root then
		local dir = vim.fs.dirname(root)

		if type(on_dir) == "function" then
			on_dir(dir)
			return
		end

		return dir
	end

	local cwd = vim.uv.cwd()

	if type(on_dir) == "function" then
		on_dir(cwd)
		return
	end

	return cwd
end

local function has_executable(cmd)
	if not cmd then
		return true
	end

	if type(cmd) == "table" then
		cmd = cmd[1]
	end

	if not cmd or cmd == "" then
		return true
	end

	return vim.fn.executable(cmd) == 1
end

-- =========================
-- Format on save
-- =========================
local format_group = vim.api.nvim_create_augroup("LspFormatOnSave", { clear = true })

vim.g.format_on_save = true

local formatters_by_ft = {
	vue = {},

	javascript = {},
	javascriptreact = {},
	typescript = {},
	typescriptreact = {},

	html = {},
	css = {},
	scss = {},
	json = {},
	jsonc = {},
	php = {},
	blade = {},

	lua = { "lua_ls" },
	python = { "pylsp" },

	c = { "clangd" },
	cpp = { "clangd" },
	rust = { "rust_analyzer" },
}

local function is_copilot(client)
	return client.name == "GitHub Copilot" or client.name == "copilot"
end

local function client_can_format(client)
	if is_copilot(client) then
		return false
	end

	if client.supports_method then
		return client.supports_method("textDocument/formatting")
	end

	return client.server_capabilities and client.server_capabilities.documentFormattingProvider
end

local function client_is_allowed_for_format(client, bufnr)
	if not client_can_format(client) then
		return false
	end

	local ft = vim.bo[bufnr].filetype
	local allowed_clients = formatters_by_ft[ft]

	if not allowed_clients then
		return true
	end

	if vim.tbl_isempty(allowed_clients) then
		return false
	end

	return vim.tbl_contains(allowed_clients, client.name)
end

local function format_buffer(bufnr)
	bufnr = bufnr or vim.api.nvim_get_current_buf()

	if not vim.g.format_on_save then
		return
	end

	vim.lsp.buf.format({
		bufnr = bufnr,
		async = false,
		timeout_ms = 3000,
		filter = function(client)
			return client_is_allowed_for_format(client, bufnr)
		end,
	})
end

local function enable_format_on_save(client, bufnr)
	if not client_can_format(client) then
		return
	end

	vim.api.nvim_clear_autocmds({
		group = format_group,
		buffer = bufnr,
	})

	vim.api.nvim_create_autocmd("BufWritePre", {
		group = format_group,
		buffer = bufnr,
		callback = function()
			format_buffer(bufnr)
		end,
	})
end

-- =========================
-- On attach
-- =========================
local function on_attach(client, bufnr)
	if is_copilot(client) then
		return
	end

	-- Evita hooks LSP que pueden hacer lento el guardado
	if type(client.server_capabilities.textDocumentSync) == "table" then
		client.server_capabilities.textDocumentSync.willSave = false
		client.server_capabilities.textDocumentSync.willSaveWaitUntil = false
	end

	local opts = {
		noremap = true,
		silent = true,
		buffer = bufnr,
	}

	vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
	vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
	vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
	vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
	vim.keymap.set("n", "K", function()
		vim.lsp.buf.hover({ border = "rounded" })
	end, opts)

	vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
	vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)

	vim.keymap.set("n", "<leader>f", function()
		format_buffer(bufnr)
	end, opts)

	enable_format_on_save(client, bufnr)
end

-- =========================
-- Vue language server path
-- =========================
local vue_language_server_path =
	vim.fs.normalize(vim.fn.stdpath("data") .. "/mason/packages/vue-language-server/node_modules/@vue/language-server")

local vue_typescript_plugin = {
	name = "@vue/typescript-plugin",
	location = vue_language_server_path,
	languages = { "vue" },
	configNamespace = "typescript",
}

vim.filetype.add({
	extension = {
		vue = "vue",
	},
	pattern = {
		[".*%.blade%.php"] = "blade",
	},
})

-- =========================
-- Servers
-- =========================
local servers = {

	--emmet
	emmet_language_server = {
		cmd = { "emmet-language-server", "--stdio" },
		filetypes = {
			"html",
			"css",
			"scss",
			"sass",
			"less",
			"vue",
			"javascriptreact",
			"typescriptreact",
			"javascript",
			"typescript",
			"php",
			"blade",
		},
		root_dir = get_root_dir,
		init_options = {
			includeLanguages = {
				vue = "html",
				javascript = "javascriptreact",
				typescript = "typescriptreact",
				php = "html",
				blade = "html",
			},
		},
	},
	-- Lua
	lua_ls = {
		settings = {
			Lua = {
				diagnostics = {
					globals = { "vim" },
				},
				workspace = {
					library = vim.api.nvim_get_runtime_file("", true),
					checkThirdParty = false,
				},
				completion = {
					callSnippet = "Replace",
				},
				telemetry = {
					enable = false,
				},
			},
		},
	},

	-- Vue
	vue_ls = {
		cmd = { "vue-language-server", "--stdio" },
		filetypes = { "vue" },
		root_dir = get_root_dir,
		init_options = {
			vue = {
				hybridMode = true,
			},
		},
	},

	-- TypeScript / JavaScript / Vue support
	vtsls = {
		cmd = { "vtsls", "--stdio" },
		filetypes = {
			"javascript",
			"javascriptreact",
			"typescript",
			"typescriptreact",
			"vue",
		},
		root_dir = get_root_dir,
		init_options = {
			hostInfo = "neovim",
		},
		settings = {
			vtsls = {
				tsserver = {
					globalPlugins = {
						vue_typescript_plugin,
					},
				},
			},
			javascript = {
				inlayHints = {
					includeInlayEnumMemberValueHints = true,
					includeInlayFunctionLikeReturnTypeHints = true,
					includeInlayFunctionParameterTypeHints = true,
					includeInlayParameterNameHints = "literals",
					includeInlayPropertyDeclarationTypeHints = true,
					includeInlayVariableTypeHints = false,
				},
			},
			typescript = {
				inlayHints = {
					includeInlayEnumMemberValueHints = true,
					includeInlayFunctionLikeReturnTypeHints = true,
					includeInlayFunctionParameterTypeHints = true,
					includeInlayParameterNameHints = "literals",
					includeInlayParameterNameHintsWhenArgumentMatchesName = false,
					includeInlayPropertyDeclarationTypeHints = true,
					includeInlayVariableTypeHints = false,
				},
				preferences = {
					importModuleSpecifier = "non-relative",
					includePackageJsonAutoImports = "auto",
				},
			},
		},
	},

	-- Fallback for machines where vtsls has not been installed yet.
	ts_ls = {
		cmd = { "typescript-language-server", "--stdio" },
		filetypes = {
			"javascript",
			"javascriptreact",
			"typescript",
			"typescriptreact",
		},
		root_dir = get_root_dir,
		init_options = {
			hostInfo = "neovim",
		},
	},

	-- HTML
	html = {
		filetypes = { "html", "vue", "blade" },
	},

	-- CSS / SCSS
	cssls = {
		filetypes = { "css", "scss", "less", "vue" },
		single_file_support = true,
	},

	-- JSON
	jsonls = {
		filetypes = { "json", "jsonc" },
	},

	-- PHP / Laravel
	intelephense = {
		cmd = { "intelephense", "--stdio" },
		filetypes = { "php" },
		root_dir = function(root_arg, on_dir)
			local root = vim.fs.find({ "composer.json", "artisan", ".git" }, {
				upward = true,
				path = path_from_root_arg(root_arg),
			})[1]

			local dir = root and vim.fs.dirname(root) or vim.uv.cwd()

			if type(on_dir) == "function" then
				on_dir(dir)
				return
			end

			return dir
		end,
		settings = {
			intelephense = {
				telemetry = {
					enabled = false,
				},
				files = {
					maxSize = 5000000,
				},
				stubs = {
					"apache",
					"bcmath",
					"bz2",
					"calendar",
					"Core",
					"curl",
					"date",
					"dom",
					"fileinfo",
					"filter",
					"gd",
					"hash",
					"iconv",
					"intl",
					"json",
					"libxml",
					"mbstring",
					"mysqli",
					"openssl",
					"pcre",
					"PDO",
					"pdo_mysql",
					"Phar",
					"readline",
					"redis",
					"Reflection",
					"session",
					"SimpleXML",
					"sockets",
					"sodium",
					"standard",
					"tokenizer",
					"xml",
					"xmlreader",
					"xmlwriter",
					"zip",
					"zlib",
				},
			},
		},
	},

	-- Tailwind classes in Vue, Blade and Laravel views
	tailwindcss = {
		filetypes = {
			"html",
			"css",
			"scss",
			"javascript",
			"javascriptreact",
			"typescript",
			"typescriptreact",
			"vue",
			"php",
			"blade",
		},
		root_dir = get_root_dir,
		settings = {
			tailwindCSS = {
				includeLanguages = {
					blade = "html",
					php = "html",
					vue = "html",
				},
				classAttributes = {
					"class",
					"className",
					"class:list",
					"classList",
					"ngClass",
				},
				lint = {
					cssConflict = "warning",
					invalidApply = "error",
					invalidConfigPath = "error",
					invalidScreen = "error",
					invalidTailwindDirective = "error",
					invalidVariant = "error",
					recommendedVariantOrder = "warning",
				},
			},
		},
	},

	-- Python
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

	-- C / C++
	clangd = {
		filetypes = { "c", "cpp", "objc", "objcpp", "h" },
	},

	-- Rust
	rust_analyzer = {},

	-- Vimscript
	vimls = {
		cmd = { "vim-language-server", "--stdio" },
		filetypes = { "vim" },
	},

	-- SQL
	sqlls = {
		cmd = { "sql-language-server", "up", "--method", "stdio" },
		filetypes = { "sql", "mysql" },
		root_dir = function()
			return vim.uv.cwd()
		end,
	},
}

-- =========================
-- Setup servers
-- =========================
for server_name, server_config in pairs(servers) do
	if server_name == "ts_ls" and has_executable({ "vtsls" }) then
		goto continue
	end

	local cmd = server_config.cmd

	if has_executable(cmd) then
		local final_config = vim.tbl_deep_extend("force", {
			capabilities = capabilities,
			on_attach = on_attach,
		}, server_config)

		if vim.lsp.config then
			vim.lsp.config(server_name, final_config)
			vim.lsp.enable(server_name)
		elseif lspconfig_avail and lspconfig[server_name] then
			lspconfig[server_name].setup(final_config)
		end
	else
		vim.notify("LSP no iniciado: " .. server_name .. " porque no se encontró el ejecutable.", vim.log.levels.WARN)
	end

	::continue::
end

-- =========================
-- Diagnostics
-- =========================
vim.diagnostic.config({
	virtual_text = {
		prefix = "●",
		spacing = 4,
	},
	signs = {
		text = {
			[vim.diagnostic.severity.ERROR] = " ",
			[vim.diagnostic.severity.WARN] = " ",
			[vim.diagnostic.severity.HINT] = "󰌵 ",
			[vim.diagnostic.severity.INFO] = " ",
		},
	},
	underline = true,
	update_in_insert = false,
	severity_sort = true,
	float = {
		source = "always",
		border = "rounded",
	},
})

-- =========================
-- Commands
-- =========================
vim.api.nvim_create_user_command("Format", function()
	format_buffer(vim.api.nvim_get_current_buf())
end, {})

vim.api.nvim_create_user_command("FormatToggle", function()
	vim.g.format_on_save = not vim.g.format_on_save

	if vim.g.format_on_save then
		vim.notify("Format on save activado", vim.log.levels.INFO)
	else
		vim.notify("Format on save desactivado", vim.log.levels.WARN)
	end
end, {})

vim.api.nvim_create_user_command("LspRestartSafe", function()
	local clients = {}

	if vim.lsp.get_clients then
		clients = vim.lsp.get_clients()
	else
		clients = vim.lsp.get_active_clients()
	end

	for _, client in ipairs(clients) do
		if not is_copilot(client) then
			vim.lsp.stop_client(client.id)
		end
	end

	vim.cmd("edit")
	vim.notify("LSP reiniciado limpiamente", vim.log.levels.INFO)
end, {})

vim.api.nvim_create_user_command("LspFormatStatus", function()
	local bufnr = vim.api.nvim_get_current_buf()
	local active_clients = {}

	if vim.lsp.get_clients then
		active_clients = vim.lsp.get_clients({ bufnr = bufnr })
	else
		active_clients = vim.lsp.get_active_clients({ bufnr = bufnr })
	end

	print("Filetype: " .. vim.bo[bufnr].filetype)
	print("Format on save: " .. tostring(vim.g.format_on_save))

	for _, client in ipairs(active_clients) do
		print(client.name .. " | formatting: " .. tostring(client_can_format(client)))
	end
end, {})
