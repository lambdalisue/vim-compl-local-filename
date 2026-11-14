# compl-local-filename.vim

Make `<C-x><C-f>` completion relative from a parent directory of a current buffer.

## Options

### `b:compl_local_filename_disable`

Set this buffer local variable to `1` to get the builtin `<C-x><C-f>` behavior
in that buffer.  File names are then completed relative to the current working
directory.

This is useful for buffers that live in an unrelated directory.  For example,
when fish opens Vim to edit a command line, the buffer is a file in a temporary
directory, while the paths in the command are relative to the current working
directory:

```vim
augroup my_compl_local_filename
  autocmd!
  autocmd BufRead,BufNewFile */fish.*/command-line.fish
        \ let b:compl_local_filename_disable = 1
augroup END
```
