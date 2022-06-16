" Prevent distro-level changes to settings; reset options when re-sourcing
" .vimrc
set nocompatible

" Filetype-based plugins and indenting
if has('filetype')
    filetype plugin indent on
endif

" Enable syntax highlighting
if has('syntax')
    syntax on
endif

" For hidden modified buffers
set hidden

" Commandline completion
set wildmenu

" Show (partial) command in status line
set showcmd

" When there is a previous search pattern, highlight all its matches
set hlsearch

" Ignore case in search patterns, except for patterns containing upper case
" characters
set ignorecase
set smartcase

" Allow backspacing over autoindents, linebreaks, and start of insert action
set backspace=indent,eol,start

" Copy indent from current line when starting a new line
set autoindent

" Show the line and column number of the cursor position
set ruler

" Ask to confirm instead of failing a command because of unsaved changes
set confirm

" Use visual bell and explicitly do nothing
set visualbell
set t_vb=

" Use the mouse, but not in Visual mode
if has('mouse')
    set mouse=nih
endif

" Mouse input mode required by some terminal emulators
if !has('nvim')
    set ttymouse=sgr
endif

" Show absolute line number of current line, and others as distance from
" current line
set number relativenumber

" Quickly time out on keycodes, but not on mappings
set notimeout ttimeout ttimeoutlen=200

" Use <F11> to toggle Paste Insert mode and numbers
function! TogglePaste()
    setlocal invnumber invrelativenumber invpaste
endfunction
nnoremap <F11> :call TogglePaste()<CR>

" Use 4 spaces instead of tabs
set expandtab
set smarttab
set shiftwidth=4
set softtabstop=4
set tabstop=8

" Show matching bracket on insert, if it is on-screen
set showmatch

" While typing a search command, immediately show matches as the pattern is
" typed
set incsearch

" Maximum width of text that is being inserted. A longer line will be broken
" after white space to get this width
set textwidth=100

" c  Auto-wrap comments using textwidth, inserting the current comment leader
"       automatically.
" q  Allow formatting of comments with "gq".
" r  Automatically insert the current comment leader after hitting <Enter> in
"       Insert mode. 
" t  Auto-wrap text using textwidth (does not apply to comments)
set formatoptions=c,q,r,t

" Show tabs and indicate long lines
set list listchars=tab:›—,extends:→,precedes:←,nbsp:·

" Color preferences
if !has('nvim')
    set background=light
    highlight Statement ctermfg=yellow
    highlight Visual cterm=reverse ctermbg=NONE
    highlight Search ctermfg=black ctermbg=yellow

    highlight DiffAdd ctermbg=black ctermfg=green cterm=reverse
    highlight DiffChange ctermbg=black ctermfg=yellow cterm=reverse
    highlight DiffDelete ctermbg=black ctermfg=darkred cterm=reverse
    highlight DiffText ctermbg=black ctermfg=red cterm=reverse

    highlight Folded ctermfg=black
    highlight FoldColumn ctermfg=black

    highlight Comment cterm=italic

    set cursorline
    highlight clear CursorLine
    " DarkOrange
    highlight CursorLineNR cterm=NONE ctermfg=208
endif

" Map redraw screen command to also turn off search highlighting until the next
" search
nnoremap <C-L> :nohl<CR><C-L>

" Buffer mappings
nnoremap [b :bprev<CR>
nnoremap ]b :bnext<CR>

" Window splits
set splitbelow
set splitright

" Tab mappings
nnoremap th :tabfirst<CR>
nnoremap [t :tabprev<CR>
nnoremap ]t :tabnext<CR>
nnoremap tl :tablast<CR>
nnoremap tt :tabedit<Space>
nnoremap tn :tabnew<CR>
nnoremap tm :tabm<Space>
nnoremap td :tabclose<CR>

" Search for visually selected text
vnoremap // y/\V<C-R>=escape(@",'/\')<CR><CR>

" Fold lines not matching previous search; `zr` for more context, `zm` for less
nnoremap <Leader>z :setlocal
    \ foldexpr=(getline(v:lnum)=~@/)?0:(getline(v:lnum-1)=~@/)\\|\\|(getline(v:lnum+1)=~@/)?1:2
    \ foldmethod=expr foldlevel=0 foldcolumn=2<CR>

" Toggle error highlighting for overlength lines
nnoremap <silent> <Leader>l
    \ :if exists('w:long_line_match') <Bar>
    \   silent! call matchdelete(w:long_line_match) <Bar>
    \   unlet w:long_line_match <Bar>
    \ elseif &textwidth > 0 <Bar>
    \   let w:long_line_match = matchadd('ErrorMsg','\%>'.&tw.'v.\+',-1) <Bar>
    \ else <Bar>
    \   let w:long_line_match = matchadd('ErrorMsg','\%>80v.\+',-1) <Bar>
    \ endif<CR>

" Fill line with char
function! FillLine(str)
    let reps = (&textwidth - col("$") + 1) / len(a:str)
    if reps > 0
        .s/$/\=(''.repeat(a:str, reps))/
    endif
endfunction

" ctags mappings
set tags=./tags;/
inoremap <c-x><c-]> <c-]>
nnoremap <Leader>t :TagbarToggle<CR>

" clang-format mappings
autocmd FileType c,cpp,objc,h,hpp nnoremap <buffer> <Leader>cf :<C-u>ClangFormat<CR>
autocmd FileType c,cpp,objc,h,hpp vnoremap <buffer> <Leader>cf :ClangFormat<CR>

" Indent guides colors
let g:indent_guides_auto_colors = 0
highlight Normal ctermbg=NONE
highlight IndentGuidesOdd ctermbg=0
highlight IndentGuidesEven ctermbg=8

" Force Vim to let Dirvish take precedence
if !has('nvim')
    let g:loaded_netrwPlugin = 1
endif
