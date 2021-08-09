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

" Block cursor all the time.
set guicursor=a:block

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
set textwidth=99
 
" c  Auto-wrap comments using textwidth, inserting the current comment leader
"       automatically.
" q  Allow formatting of comments with "gq".
" r  Automatically insert the current comment leader after hitting <Enter> in
"       Insert mode. 
" t  Auto-wrap text using textwidth (does not apply to comments)
set formatoptions=c,q,r,t
 
" Color preferences
set background=light
highlight Statement ctermfg=Yellow
highlight Visual cterm=reverse ctermbg=NONE
highlight Search ctermfg=Black ctermbg=Yellow
highlight DiffText ctermfg=Black

" Map redraw screen command to also turn off search highlighting until the next
" search
nnoremap <C-L> :nohl<CR><C-L>

" Buffer mappings
nnoremap [b :bprev<CR>
nnoremap ]b :bnext<CR>

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

" Toggle error highlighting for overlength lines
nnoremap <silent> <Leader>l
    \ :if exists('w:long_line_match') <Bar>
    \   silent! call matchdelete(w:long_line_match) <Bar>
    \   unlet w:long_line_match <Bar>
    \ elseif &textwidth > 0 <Bar>
    \   let w:long_line_match = matchadd('ErrorMsg','\%>'.&tw.'v.\+',-1) <Bar>
    \ else <Bar>
    \   let w:long_line_match = matchadd('ErrorMsg','\%>100v.\+',-1) <Bar>
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

" NVim-Tree mappings
nnoremap <leader>n :NvimTreeToggle<CR>
nnoremap <leader>r :NvimTreeRefresh<CR>
nnoremap <C-n> :NvimTreeFindFile<CR>

" clang-format mappings
autocmd FileType c,cpp,objc,h,hpp nnoremap <buffer> <Leader>cf :<C-u>ClangFormat<CR>
autocmd FileType c,cpp,objc,h,hpp vnoremap <buffer> <Leader>cf :ClangFormat<CR>
