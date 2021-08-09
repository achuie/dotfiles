#!/usr/bin/env sh

STARTDIR=~/.config/nvim/pack/achuie/start
mkdir -p ${STARTDIR}

git clone https://github.com/tpope/vim-surround.git ${STARTDIR}/surround
nvim -u NONE -c "helptags ${STARTDIR}/surround/doc" -c q

git clone https://github.com/tomtom/tcomment_vim.git ${STARTDIR}/tcomment
nvim -u NONE -c "helptags ${STARTDIR}/tcomment/doc" -c q

git clone https://github.com/preservim/tagbar.git ${STARTDIR}/tagbar
nvim -u NONE -c "helptags ${STARTDIR}/tagbar/doc" -c q

git clone https://github.com/sheerun/vim-polyglot.git ${STARTDIR}/polyglot
nvim -u NONE -c "helptags ${STARTDIR}/polyglot/doc" -c q

git clone https://github.com/chaoren/vim-wordmotion ${STARTDIR}/wordmotion
nvim -u NONE -c "helptags ${STARTDIR}/wordmotion/doc" -c q

git clone https://github.com/justinmk/vim-dirvish.git ${STARTDIR}/dirvish
nvim -u NONE -c "helptags ${STARTDIR}/dirvish/doc" -c q

git clone https://github.com/kyazdani42/nvim-web-devicons.git

git clone https://github.com/kyazdani42/nvim-tree.lua.git ${STARTDIR}/nvim-tree
nvim -u NONE -c "helptags ${STARTDIR}/nvim-tree/doc" -c q
