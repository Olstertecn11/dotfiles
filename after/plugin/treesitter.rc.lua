require'nvim-treesitter.configs'.setup {
  ensure_installed = { "cpp", "lua", "python", "javascript", "typescript"},
  sync_install = false,
  highlight = {
    enable = true,
    additional_vim_regex_highlighting = false,
  },
}
