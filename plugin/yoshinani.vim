"=============================================================================
" File: yoshinani.vim
" Author: noah
" Created: 2018-05-30
"=============================================================================

scriptencoding utf-8

if exists('g:loaded_yoshinani')
    finish
endif
let g:loaded_yoshinani = 1

let s:save_cpo = &cpo
set cpo&vim

command! Yoshinani call yoshinani#yoshinani()

let &cpo = s:save_cpo
unlet s:save_cpo
