set runtimepath^=~/.vim runtimepath+=~/.vim/after
let &packpath = &runtimepath
source ~/.vimrc

" Bind Esc to go back to Normal mode in a terminal buffer
tnoremap <Esc> <C-\><C-n>

let g:indent_blankline_char_blankline='┊'

set cursorline

" let g:tokyonight_style="storm"
" colorscheme tokyonight

" let g:catppuccin_flavour="macchiato"
" colorscheme catppuccin

lua <<EOF
local default_colors = require("kanagawa.colors").setup()
local overrides = {
    EndOfBuffer = { fg = default_colors.bg_light2 },
    CursorLineNr = { fg = default_colors.bg_light3 }
}
require'kanagawa'.setup({ overrides = overrides })
EOF
colorscheme kanagawa
