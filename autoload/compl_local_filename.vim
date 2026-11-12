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
  if exists('b:compl_local_filename_disable')
    return b:compl_local_filename_disable
  endif
  return get(g:, 'compl_local_filename_ignore_tempdir', 1)
        \ && s:is_in_tempdir(expand('%:p:h'))
endfunction

function! s:is_in_tempdir(dir) abort
  let dir = s:normalize(a:dir)
  for tempdir in s:tempdirs()
    let n = len(tempdir)
    if s:is_same_path(dir[:n - 1], tempdir)
          \ && (len(dir) == n || dir[n] =~# '[/\\]')
      return 1
    endif
  endfor
  return 0
endfunction

function! s:tempdirs() abort
  let dirs = [$TMPDIR, $TEMP, $TMP]
  if has('unix')
    call extend(dirs, ['/tmp', '/var/tmp'])
  endif
  call map(filter(dirs, '!empty(v:val)'), 's:normalize(v:val)')
  " An empty value is a root directory, that would match everything.
  return uniq(sort(filter(dirs, '!empty(v:val)')))
endfunction

" Returns a full path with symbolic links resolved and without a trailing path
" separator.
function! s:normalize(path) abort
  return substitute(resolve(fnamemodify(a:path, ':p')), '[/\\]\+$', '', '')
endfunction

function! s:is_same_path(lhs, rhs) abort
  return has('win32') ? a:lhs ==? a:rhs : a:lhs ==# a:rhs
endfunction
