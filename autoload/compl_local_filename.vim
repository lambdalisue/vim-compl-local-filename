function! compl_local_filename#start() abort
  if exists('s:saved_cwd')
    return "\<C-x>\<C-f>"
  endif
  let s:saved_cwd = getcwd()
  silent execute printf('lcd %s', fnameescape(expand('%:p:h')))
  augroup compl_local_filename_internal
    autocmd! * <buffer>
    autocmd CompleteDone <buffer>
          \ augroup compl_local_filename_internal |
          \   autocmd! * <buffer> |
          \   autocmd InsertLeave,CursorMovedI <buffer> call s:reset() |
          \ augroup END
  augroup END
  return "\<C-x>\<C-f>"
endfunction

function! s:reset() abort
  if !exists('s:saved_cwd')
    return
  endif
  silent execute printf('lcd %s', fnameescape(s:saved_cwd))
  silent unlet s:saved_cwd
  augroup compl_local_filename_internal
    autocmd! * <buffer>
  augroup END
endfunction
