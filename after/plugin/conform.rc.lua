local status, conform = pcall(require, "conform")
if not status then
	return
end

local function has_file(names)
	return vim.fs.find(names, {
		upward = true,
		path = vim.api.nvim_buf_get_name(0),
	})[1] ~= nil
end

conform.setup({
	notify_on_error = true,
	format_on_save = function(bufnr)
		if not vim.g.format_on_save then
			return
		end

		return {
			bufnr = bufnr,
			timeout_ms = 3000,
			lsp_format = "fallback",
		}
	end,
	formatters_by_ft = {
		lua = { "stylua" },

		javascript = { "prettierd", "prettier", stop_after_first = true },
		javascriptreact = { "prettierd", "prettier", stop_after_first = true },
		typescript = { "prettierd", "prettier", stop_after_first = true },
		typescriptreact = { "prettierd", "prettier", stop_after_first = true },
		vue = { "prettierd", "prettier", stop_after_first = true },
		css = { "prettierd", "prettier", stop_after_first = true },
		scss = { "prettierd", "prettier", stop_after_first = true },
		html = { "prettierd", "prettier", stop_after_first = true },
		json = { "prettierd", "prettier", stop_after_first = true },
		jsonc = { "prettierd", "prettier", stop_after_first = true },
		markdown = { "prettierd", "prettier", stop_after_first = true },

		php = { "pint", "php_cs_fixer", stop_after_first = true },
		blade = { "blade-formatter" },
	},
	formatters = {
		pint = {
			condition = function()
				return has_file({ "pint.json", "composer.json", "artisan" })
			end,
		},
		php_cs_fixer = {
			condition = function()
				return has_file({ ".php-cs-fixer.php", ".php-cs-fixer.dist.php" })
			end,
		},
		prettierd = {
			condition = function()
				return has_file({
					".prettierrc",
					".prettierrc.json",
					".prettierrc.js",
					".prettierrc.cjs",
					".prettierrc.mjs",
					"prettier.config.js",
					"prettier.config.cjs",
					"prettier.config.mjs",
					"package.json",
				})
			end,
		},
	},
})
