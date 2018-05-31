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

let s:cursor_mark = '{{{c}}}'

function! yoshinani#yoshinani() abort
    if !yoshinani#is_empty_buffer()
        echoerr 'cannot use yoshinani because this is not empty buf.'
        return
    endif
    let fname = input('template file (' . yoshinani#template_path() . ') : ')
    if fname == ''
        return
    endif
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
    let s = glob(yoshinani#template_path() . a:fname)
    if s == ''
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
    let f = yoshinani#template_path() . a:fname
    return f
endfunction

function! yoshinani#write_buf(f) abort
    let cnt = 0
    let pos = {'x': 0, 'y': 0}
    for line in readfile(a:f)
        let cnt = cnt + 1
        let ppos = stridx(line, s:cursor_mark)
        if ppos != -1
            let pos['x'] = ppos
            let pos['y'] = cnt
            let line = substitute(line, s:cursor_mark, '', 'g')
        endif
        call setline(cnt, line)
    endfor
    call cursor(pos['y'], pos['x'])
endfunction

function! yoshinani#template_path() abort
    if exists('g:yoshinani_template_path') == 0
        return $HOME . '/.yoshinani/'
    endif
    if g:yoshinani_template_path !~ '.*/$'
        return g:yoshinani_template_path . '/'
    endif
    return g:yoshinani_template_path
endfunction

function! yoshinani#is_empty_buffer() abort
    let lines = getline(1, '$')
    if len(lines) == 1 && lines[0] == ''
        return v:true
    endif
    return v:false
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo
