"=============================================================================
" File: yoshinani.vim
" Author: noah
" Created: 2018-05-30
"=============================================================================

scriptencoding utf-8

if !exists('g:loaded_yoshinani')
    finish
endif
let g:loaded_yoshinani = 1

let s:save_cpo = &cpo
set cpo&vim

function! yoshinani#yoshinani() abort
    let fname = input('template file ($HOME/.yoshinani/) : ')
    if !yoshinani#exists_file(fname)
        echoerr 'no such template file(' . fname . ')'
        return
    endif
    if !yoshinani#check_filetype(fname)
        echoerr 'filetypes of ' . fname . ' and buffername do not match'
        return
    endif

    let f = yoshinani#read_file(fname)
    call yoshinani#write_buf(f)
    filetype on
endfunction

function! yoshinani#exists_file(fname) abort
    let s = glob($HOME . "/.yoshinani/" . a:fname)
    if s == ""
        return v:false
    endif
    return v:true
endfunction

function! yoshinani#check_filetype(fname) abort
    let fsp = split(a:fname, '\.')
    let bsp = split(bufname('%'), '\.')
    if len(fsp) == 0 || len(bsp) == 0
        return v:false
    endif
    if fsp[len(fsp)-1] == bsp[len(bsp)-1] 
        return v:true
    endif
    return v:false
endfunction

function! yoshinani#read_file(fname) abort
    let f = $HOME . "/.yoshinani/" . a:fname
    return f
endfunction

function! yoshinani#write_buf(f) abort
    let cnt = 0
    for line in readfile(a:f)
        let cnt = cnt + 1
        call setline(cnt, line)
    endfor
endfunction

function! yoshinani#set_filetype() abort

endfunction

let &cpo = s:save_cpo
unlet s:save_cpo
