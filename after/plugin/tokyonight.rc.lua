require("tokyonight").setup({
  style = "night",
  transparent = true,
  terminal_colors = true,

  styles = {
    comments = { italic = true },
    keywords = { italic = true },
    functions = {},
    variables = {},
    sidebars = "transparent",
    floats = "transparent",
  },

  sidebars = { "qf", "help", "terminal", "NvimTree" },
  day_brightness = 0.3,
  hide_inactive_statusline = false,
  dim_inactive = false,
  lualine_bold = false,

  on_highlights = function(hl, c)
    hl.BlinkCmpMenu = { bg = c.bg_dark, fg = c.fg }
    hl.BlinkCmpMenuBorder = { fg = c.blue, bg = c.bg_dark }
    hl.BlinkCmpDoc = { bg = c.bg_dark, fg = c.fg }
    hl.BlinkCmpDocBorder = { fg = c.blue, bg = c.bg_dark }
    hl.BlinkCmpSignatureHelp = { bg = c.bg_dark, fg = c.fg }
    hl.BlinkCmpSignatureHelpBorder = { fg = c.magenta, bg = c.bg_dark }

    hl.BlinkCmpLabel = { fg = c.fg }
    hl.BlinkCmpLabelMatch = { fg = c.blue, bold = true }
    hl.BlinkCmpKind = { fg = c.cyan }
    hl.BlinkCmpSource = { fg = c.dark5 }
    -- Vue / HTML tags
    hl["@tag"] = { fg = c.blue }
    hl["@tag.vue"] = { fg = c.blue1 }
    hl["@tag.builtin"] = { fg = c.red }
    hl["@tag.builtin.vue"] = { fg = c.red }

    -- Delimitadores: < > </ />
    hl["@tag.delimiter"] = { fg = c.dark5 }
    hl["@tag.delimiter.vue"] = { fg = c.dark5 }

    -- Props / atributos: :row, v-if, @click
    hl["@tag.attribute"] = { fg = c.green1 }
    hl["@tag.attribute.vue"] = { fg = c.green1 }
    hl["@attribute"] = { fg = c.green1 }
    hl["@attribute.vue"] = { fg = c.green1 }

    -- Variables / propiedades
    hl["@variable"] = { fg = c.fg }
    hl["@variable.member"] = { fg = c.cyan }
    hl["@property"] = { fg = c.cyan }
    hl["@property.vue"] = { fg = c.cyan }

    -- Funciones
    hl["@function"] = { fg = c.blue }
    hl["@function.call"] = { fg = c.blue }
    hl["@function.method"] = { fg = c.blue }
    hl["@function.method.call"] = { fg = c.blue }

    -- Keywords / operadores
    hl["@keyword"] = { fg = c.purple, italic = true }
    hl["@keyword.conditional"] = { fg = c.purple, italic = true }
    hl["@keyword.repeat"] = { fg = c.purple, italic = true }
    hl["@operator"] = { fg = c.blue5 }

    -- Strings / números / booleanos
    hl["@string"] = { fg = c.green }
    hl["@number"] = { fg = c.orange }
    hl["@boolean"] = { fg = c.orange }

    -- Tipos / constructores
    hl["@type"] = { fg = c.yellow }
    hl["@type.builtin"] = { fg = c.yellow }
    hl["@constructor"] = { fg = c.magenta }
  end,
})

vim.cmd.colorscheme("tokyonight-night")
