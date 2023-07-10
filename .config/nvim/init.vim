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
  show_trailing_blankline_indent = false,
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

-- local overrides = function(colors)
--   return {
--     EndOfBuffer = { fg = colors.palette.sumiInk6 },
--     CursorLineNr = { fg = colors.palette.springViolet1 }
--   }
-- end
-- require'kanagawa'.setup({ statementStyle = { bold = false }, theme = "wave", colors = { theme = { all = { ui = { bg_gutter = "none" }}}}, overrides = overrides })

require("tokyonight").setup({
  style = "moon",
  on_highlights = function(hl, c)
    hl.EndOfBuffer = { fg = c.bg_highlight }
  end
})
EOF

" colorscheme kanagawa
colorscheme tokyonight
