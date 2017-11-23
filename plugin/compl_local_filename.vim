if exists('g:loaded_compl_local_filename')
  finish
endif
let g:loaded_compl_local_filename = 1

if get(g:, 'compl_local_filename_default_mapping', 1)
  inoremap <silent><expr> <C-x><C-f> compl_local_filename#start()
endif
