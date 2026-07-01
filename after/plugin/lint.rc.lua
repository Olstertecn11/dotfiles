local status, lint = pcall(require, "lint")
if not status then
	return
end

local function has_file(names)
	return vim.fs.find(names, {
		upward = true,
		path = vim.api.nvim_buf_get_name(0),
	})[1] ~= nil
end

lint.linters_by_ft = {
	javascript = { "eslint_d" },
	javascriptreact = { "eslint_d" },
	typescript = { "eslint_d" },
	typescriptreact = { "eslint_d" },
	vue = { "eslint_d" },
	php = { "php" },
}

local lint_group = vim.api.nvim_create_augroup("NvimLint", { clear = true })

vim.api.nvim_create_autocmd({ "BufReadPost", "BufWritePost", "InsertLeave" }, {
	group = lint_group,
	callback = function()
		local ft = vim.bo.filetype

		if vim.tbl_contains({ "javascript", "javascriptreact", "typescript", "typescriptreact", "vue" }, ft) then
			if
				not has_file({
					".eslintrc",
					".eslintrc.js",
					".eslintrc.cjs",
					".eslintrc.json",
					"eslint.config.js",
					"eslint.config.mjs",
					"eslint.config.cjs",
					"package.json",
				})
			then
				return
			end
		end

		lint.try_lint()
	end,
})
