#!/usr/bin/env sh

STARTDIR=~/.vim/pack/achuie/start
mkdir -p ${STARTDIR}

git clone git@github.com:tpope/vim-sleuth.git ${STARTDIR}/sleuth
vim -u NONE -c "helptags ${STARTDIR}/sleuth/doc" -c q

git clone git@github.com:tpope/vim-surround.git ${STARTDIR}/surround
vim -u NONE -c "helptags ${STARTDIR}/surround/doc" -c q

git clone git@github.com:tomtom/tcomment_vim.git ${STARTDIR}/tcomment
vim -u NONE -c "helptags ${STARTDIR}/tcomment/doc" -c q

git clone git@github.com:preservim/tagbar.git ${STARTDIR}/tagbar
vim -u NONE -c "helptags ${STARTDIR}/tagbar/doc" -c q

git clone git@github.com:wlangstroth/vim-racket ${STARTDIR}/racket
