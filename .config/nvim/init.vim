" Use ~/.vim directories and source gool ol' .vimrc.
set runtimepath^=~/.vim runtimepath+=~/.vim/after
let &packpath = &runtimepath
source ~/.vimrc

" Bind Esc to go back to Normal mode in a terminal buffer
tnoremap <Esc> <C-\><C-n>

set termguicolors

set cursorline

lua <<EOF
function longBuffer(lang, bufnr)
    return vim.api.nvim_buf_line_count(bufnr) > 30000
end

require'indent_blankline'.setup({
  char_blankline = '┊',
  show_current_context = true,
  use_treesitter = true,
  use_treesitter_scope = true,
})

require'nvim-treesitter.configs'.setup({
  auto_install = true,
  highlight = {
    enable = true,
    additional_vim_regex_highlighting = true,
    disable = longBuffer,

  },
  indent = {
    enable = true,
    disable = longBuffer,
  },
  incremental_selection = {
    enable = true,
    keymaps = {
      init_selection = "gnn",
      node_incremental = "grn",
      scope_incremental = "grc",
      node_decremental = "grm",
    },
    disable = longBuffer,
  },
  textobjects = {
    enable = true,
    disable = longBuffer,
    },
})

local default_colors = require("kanagawa.colors").setup()
local overrides = {
  EndOfBuffer = { fg = default_colors.bg_light2 },
  CursorLineNr = { fg = default_colors.bg_light3 }
}
require'kanagawa'.setup({ statementStyle = { bold = false }, overrides = overrides })
EOF

colorscheme kanagawa
