# compl-local-filename.vim

Make `<C-x><C-f>` completion relative from a parent directory of a current buffer.

## Options

### `b:compl_local_filename_disable`

Set this buffer local variable to `1` to get the builtin `<C-x><C-f>` behavior
in that buffer.  File names are then completed relative to the current working
directory.

Set it to `0` to always complete relative to the parent directory of the
buffer, even when `g:compl_local_filename_ignore_tempdir` would say otherwise.

This is useful for buffers that live in an unrelated directory, when it is not
a temporary directory:

```vim
augroup my_compl_local_filename
  autocmd!
  autocmd BufRead,BufNewFile ~/.cache/my-tool/prompt-*.txt
        \ let b:compl_local_filename_disable = 1
augroup END
```

### `g:compl_local_filename_ignore_tempdir`

When a buffer is a file in a temporary directory, the builtin `<C-x><C-f>`
behavior is used and file names are completed relative to the current working
directory.

Such a buffer is usually created by another program, that uses Vim as an
external editor.  For example, when a shell opens Vim to edit a command line,
the paths in the command are relative to the current working directory and not
to the temporary directory that holds the buffer.

Temporary directories are `$TMPDIR`, `$TEMP`, `$TMP` and, on Unix, `/tmp` and
`/var/tmp`.

Set it to `0` to complete relative to the parent directory of the buffer
regardless of where the buffer is (default: `1`):

```vim
let g:compl_local_filename_ignore_tempdir = 0
```
