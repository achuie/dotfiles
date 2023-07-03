#!/usr/bin/env sh

STARTDIR=~/.vim/pack/achuie/start
mkdir -p ${STARTDIR}

git clone https://github.com/tpope/vim-surround.git ${STARTDIR}/surround
vim -u NONE -c "helptags ${STARTDIR}/surround/doc" -c q

git clone https://github.com/tomtom/tcomment_vim.git ${STARTDIR}/tcomment
vim -u NONE -c "helptags ${STARTDIR}/tcomment/doc" -c q

git clone https://github.com/preservim/tagbar.git ${STARTDIR}/tagbar
vim -u NONE -c "helptags ${STARTDIR}/tagbar/doc" -c q

git clone https://github.com/sheerun/vim-polyglot.git ${STARTDIR}/vim-polyglot
vim -u NONE -c "helptags ${STARTDIR}/vim-polyglot/doc" -c q

git clone https://github.com/nvim-treesitter/nvim-treesitter.git ${STARTDIR}/nvim-treesitter
nvim -u NONE -c "helptags ${STARTDIR}/nvim-treesitter/doc" -c q

git clone https://github.com/chaoren/vim-wordmotion ${STARTDIR}/vim-wordmotion
vim -u NONE -c "helptags ${STARTDIR}/vim-wordmotion/doc" -c q

git clone https://github.com/justinmk/vim-dirvish.git ${STARTDIR}/vim-dirvish
vim -u NONE -c "helptags ${STARTDIR}/vim-dirvish/doc" -c q

git clone https://github.com/nathanaelkane/vim-indent-guides.git ${STARTDIR}/vim-indent-guides
vim -u NONE -c "helptags ${STARTDIR}/vim-indent-guides/doc" -c q

git clone https://github.com/lukas-reineke/indent-blankline.nvim.git ${STARTDIR}/indent-blankline.nvim
nvim -u NONE -c "helptags ${STARTDIR}/indent-blankline.nvim/doc" -c q

git clone https://github.com/jeetsukumaran/vim-indentwise.git ${STARTDIR}/vim-indentwise
vim -u NONE -c "helptags ${STARTDIR}/vim-indentwise/doc" -c q

git clone https://github.com/rebelot/kanagawa.nvim.git ${STARTDIR}/kanagawa.nvim

git clone https://github.com/folke/tokyonight.nvim.git ${STARTDIR}/tokyonight.nvim
nvim -u NONE -c "helptags ${STARTDIR}/tokyonight.nvim/doc" -c q
