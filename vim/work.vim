
" use my tags
set tags+=$INETROOT/tags

""""""""""""""""""""""""""""""""""""""""""""""""""
" Source Depot
"

" edit the current file
function! SDEdit()
    call system("sd edit " . expand("%"))
endfunction

" revert the current file
function! SDRevert()
    call system("sd revert " . expand("%"))
endfunction

" map these functions
noremap  <silent> <C-F11>      :call SDEdit()<CR>
inoremap <silent> <C-F11> <C-O>:call SDEdit()<CR>

noremap  <silent> <C-F12>      :call SDRevert()<CR>
inoremap <silent> <C-F12> <C-O>:call SDRevert()<CR>

""""""""""""""""""""""""""""""""""""""""""""""""""
" Source Search
"

" search for the word with mouse focus
function! SourceSearch(term)
    let exe  = '\\wlxindex\Search\tools\search.exe'
    let cmd  = ' -e:neutral -s wlxindex;mod;\\wlxindex\modern\'
    let path = substitute($COREXTBRANCH, 'working.modern.', '', 'g') . ' '
    exec "silent !start " . exe . cmd . path . a:term
endfunction

" map this function
noremap  <silent>       :call SourceSearch(expand("<cword>"))<CR>
inoremap <silent>  <C-O>:call SourceSearch(expand("<cword>"))<CR>

""""""""""""""""""""""""""""""""""""""""""""""""""
" Plugins
"

" filelist
let g:FileList_IndexFile    = $INETROOT . "/filetags"
let g:FileList_MaxToShow    = 72

