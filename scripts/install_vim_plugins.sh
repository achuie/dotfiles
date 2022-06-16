#!/usr/bin/env sh

STARTDIR=~/.vim/pack/achuie/start
mkdir -p ${STARTDIR}

git clone https://github.com/tpope/vim-surround.git ${STARTDIR}/surround
vim -u NONE -c "helptags ${STARTDIR}/surround/doc" -c q

git clone https://github.com/tomtom/tcomment_vim.git ${STARTDIR}/tcomment
vim -u NONE -c "helptags ${STARTDIR}/tcomment/doc" -c q

git clone https://github.com/preservim/tagbar.git ${STARTDIR}/tagbar
vim -u NONE -c "helptags ${STARTDIR}/tagbar/doc" -c q

git clone https://github.com/sheerun/vim-polyglot.git ${STARTDIR}/polyglot
vim -u NONE -c "helptags ${STARTDIR}/polyglot/doc" -c q

git clone https://github.com/chaoren/vim-wordmotion ${STARTDIR}/wordmotion
vim -u NONE -c "helptags ${STARTDIR}/wordmotion/doc" -c q

git clone https://github.com/justinmk/vim-dirvish.git ${STARTDIR}/dirvish
vim -u NONE -c "helptags ${STARTDIR}/dirvish/doc" -c q

git clone https://github.com/nathanaelkane/vim-indent-guides.git ${STARTDIR}/indent-guides
vim -u NONE -c "helptags ${STARTDIR}/indent-guides/doc" -c q

git clone https://github.com/lukas-reineke/indent-blankline.nvim.git ${STARTDIR}/indent-blankline
nvim -u NONE -c "helptags ${STARTDIR}/indent-blankline/doc" -c q

git clone https://github.com/jeetsukumaran/vim-indentwise.git ${STARTDIR}/indentwise
vim -u NONE -c "helptags ${STARTDIR}/indentwise/doc" -c q

git clone https://github.com/rebelot/kanagawa.nvim.git ${STARTDIR}/kanagawa

git clone https://github.com/folke/tokyonight.nvim.git ${STARTDIR}/tokyonight
nvim -u NONE -c "helptags ${STARTDIR}/tokyonight/doc" -c q
