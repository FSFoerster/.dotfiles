" Disable compatibility with vi which can cause enexpected issues.
set nocompatible

" Enable type file detection. Vim will be able to try to detect the type of
" file in use.
filetype on

" Enable plugins and load plugin for the detected file type.
filetype plugin on

" Load an indent file for the detected file type.
filetype indent on

" Turn syntax highlighting on.
syntax on

" Add numbers to each line on the left-hand side.
set number

" Set tab width to 3 columns.
set tabstop=4

" When indenting with '>', use 4 spaces width
set shiftwidth=4

" On pressing tab, insert 4 spaces
set expandtab
