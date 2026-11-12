function! compl_local_filename#start() abort
  if exists('s:saved_cwd') || s:is_disabled()
    return "\<C-x>\<C-f>"
  endif
  let s:saved_cwd = getcwd()
  silent! execute printf('cd %s', fnameescape(expand('%:p:h')))
  augroup compl_local_filename_internal
    autocmd! * <buffer>
    autocmd CompleteDone <buffer> ++once call timer_start(0, { -> s:reset() })
  augroup END
  return "\<C-x>\<C-f>"
endfunction

function! s:reset() abort
  if !exists('s:saved_cwd')
    return
  endif
  silent! execute printf('cd %s', fnameescape(s:saved_cwd))
  silent! unlet s:saved_cwd
endfunction

function! s:is_disabled() abort
  return get(b:, 'compl_local_filename_disable', 0)
endfunction
