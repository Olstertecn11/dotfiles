-- 1. Autoinstalador automático de Lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable",
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

-- 2. Inicialización de los plugins con Lazy
require("lazy").setup({
	-- Infraestructura base
	"nvim-lualine/lualine.nvim",
	"nvim-lua/plenary.nvim",
	"onsails/lspkind-nvim",
	"neovim/nvim-lspconfig",
	"williamboman/mason.nvim",
	"williamboman/mason-lspconfig.nvim",
	"WhoIsSethDaniel/mason-tool-installer.nvim",

	-- Temas estéticos
	"EdenEast/nightfox.nvim",
	"folke/tokyonight.nvim",
	"AlexvZyl/nordic.nvim",
	{ "scottmckendry/cyberdream.nvim" },

	-- Treesitter y Apariencia
	{
		"nvim-treesitter/nvim-treesitter",
		branch = "master",
		build = ":TSUpdate",
		lazy = false,
		priority = 1000,

		config = function()
			require("nvim-treesitter.configs").setup({
				ensure_installed = {
					"vue",
					"html",
					"css",
					"scss",
					"javascript",
					"typescript",
					"tsx",
					"json",
					"lua",
					"vim",
					"vimdoc",
					"bash",
					"markdown",
					"markdown_inline",
					"php",
					"python",
					"kotlin",
				},

				sync_install = true,
				auto_install = false,

				highlight = {
					enable = true,
					additional_vim_regex_highlighting = false,
				},

				indent = {
					enable = false,
				},
			})

			vim.filetype.add({
				extension = {
					vue = "vue",
				},
			})
		end,
	},
	"kyazdani42/nvim-web-devicons",
	"norcalli/nvim-colorizer.lua",
	"sphamba/smear-cursor.nvim",
	{
		"echasnovski/mini.indentscope",
		config = function()
			require("mini.indentscope").setup()
		end,
	},

	-- Navegación y Búsqueda
	"nvim-telescope/telescope.nvim",
	"nvim-telescope/telescope-file-browser.nvim",
	"nvim-tree/nvim-tree.lua",

	-- Utilidades de edición
	"windwp/nvim-autopairs",
	"windwp/nvim-ts-autotag",
	{
		"stevearc/conform.nvim",
		event = { "BufWritePre" },
		cmd = { "ConformInfo" },
	},
	{
		"mfussenegger/nvim-lint",
		event = { "BufReadPost", "BufWritePost", "InsertLeave" },
	},
	"folke/neodev.nvim",
	{
		"numToStr/Comment.nvim",
		config = function()
			require("Comment").setup()
		end,
	},
	{ "kylechui/nvim-surround", version = "*" },

	-- Entorno PHP / Laravel / Blade
	"yuchanns/phpfmt.nvim",
	"jwalton512/vim-blade",
	{
		"aurum77/live-server.nvim",
		build = function()
			require("live_server.util").install()
		end,
		cmd = { "LiveServer", "LiveServerStart", "LiveServerStop" },
	},
	{ "github/copilot.vim", lazy = false },
	"mfussenegger/nvim-dap",

	-- UI y Layouts
	{ "startup-nvim/startup.nvim", dependencies = { "nvim-telescope/telescope.nvim", "nvim-lua/plenary.nvim" } },
	{
		"akinsho/bufferline.nvim",
		version = "*",
		dependencies = "nvim-tree/nvim-web-devicons",
		config = function()
			require("bufferline").setup({})
		end,
	},
	{
		"akinsho/toggleterm.nvim",
		version = "*",
		config = function()
			require("toggleterm").setup()
		end,
	},

	-- =========================================================================
	-- EL NUEVO MOTOR EN RUST (Lazy lo maneja de forma perfecta de forma nativa)
	-- =========================================================================
	{
		"saghen/blink.cmp",
		dependencies = {
			"rafamadriz/friendly-snippets",
		},
		version = "*",

		opts = {
			keymap = {
				preset = "default",

				["<C-space>"] = { "show", "show_documentation", "hide_documentation" },
				["<C-e>"] = { "hide", "fallback" },

				["<CR>"] = { "accept", "fallback" },

				["<Tab>"] = { "select_next", "snippet_forward", "fallback" },
				["<S-Tab>"] = { "select_prev", "snippet_backward", "fallback" },

				["<C-j>"] = { "select_next", "fallback" },
				["<C-k>"] = { "select_prev", "fallback" },

				["<C-b>"] = { "scroll_documentation_up", "fallback" },
				["<C-f>"] = { "scroll_documentation_down", "fallback" },
			},

			appearance = {
				nerd_font_variant = "mono",
				use_nvim_cmp_as_default = false,

				kind_icons = {
					Text = "󰉿",
					Method = "󰊕",
					Function = "󰊕",
					Constructor = "󰒓",

					Field = "󰜢",
					Variable = "󰆦",
					Property = "󰖷",

					Class = "󱡠",
					Interface = "󱡠",
					Struct = "󱡠",
					Module = "󰅩",

					Unit = "󰪚",
					Value = "󰦨",
					Enum = "󰦨",
					EnumMember = "󰦨",

					Keyword = "󰻾",
					Constant = "󰏿",

					Snippet = "󱄽",
					Color = "󰏘",
					File = "󰈔",
					Reference = "󰬲",
					Folder = "󰉋",
					Event = "󱐋",
					Operator = "󰪚",
					TypeParameter = "󰬛",
				},
			},

			completion = {
				accept = {
					auto_brackets = {
						enabled = true,
					},
				},

				list = {
					selection = {
						preselect = true,
						auto_insert = false,
					},
				},

				menu = {
					border = "rounded",
					draw = {
						columns = {
							{ "kind_icon" },
							{ "label", "label_description", gap = 1 },
							{ "source_name" },
						},

						components = {
							kind_icon = {
								text = function(ctx)
									local icon = ctx.kind_icon
									return icon .. " "
								end,
							},

							source_name = {
								text = function(ctx)
									return "[" .. ctx.source_name .. "]"
								end,
							},
						},
					},
				},

				documentation = {
					auto_show = true,
					auto_show_delay_ms = 250,
					window = {
						border = "rounded",
					},
				},

				ghost_text = {
					enabled = true,
				},
			},

			signature = {
				enabled = true,
				window = {
					border = "rounded",
				},
			},

			sources = {
				default = {
					"lsp",
					"path",
					"snippets",
					"buffer",
				},

				providers = {
					lsp = {
						name = "LSP",
						score_offset = 100,
					},

					path = {
						name = "Path",
						score_offset = 20,
					},

					snippets = {
						name = "Snip",
						score_offset = 10,
					},

					buffer = {
						name = "Buf",
						score_offset = -5,
					},
				},
			},
		},
	},
})
