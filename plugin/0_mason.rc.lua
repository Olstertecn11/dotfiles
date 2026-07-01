local status, mason = pcall(require, "mason")
if not status then
	return
end
local status2, lspconfig = pcall(require, "mason-lspconfig")
if not status2 then
	return
end

mason.setup({})

local tools_ok, mason_tool_installer = pcall(require, "mason-tool-installer")
if not tools_ok then
	return
end

mason_tool_installer.setup({
	ensure_installed = {
		"prettierd",
		"prettier",
		"eslint_d",
		"stylua",
		"blade-formatter",
		"php-cs-fixer",
	},
	auto_update = false,
	run_on_start = true,
	start_delay = 3000,
})
