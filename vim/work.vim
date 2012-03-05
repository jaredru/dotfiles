
""""""""""""""""""""""""""""""""""""""""""""""""""
" Source Depot
"

let s:ignoreChange = 0

" run an sd command
function! SdExe(cmd)
    silent exec "!start /min sd.exe " . a:cmd
endfunction

" edit the current file
function! SdEdit()
    let s:ignoreChange = 1
    call SdExe("edit " . expand("%"))
endfunction

" revert the current file
function! SdRevert()
    call SdExe("revert " . expand("%"))
endfunction

" map these functions
noremap  <silent> <C-F11>      :call SdEdit()<CR>
inoremap <silent> <C-F11> <C-O>:call SdEdit()<CR>

noremap  <silent> <C-F12>      :call SdRevert()<CR>
inoremap <silent> <C-F12> <C-O>:call SdRevert()<CR>

" automatically attempt to check out read-only files
function! OnFileChangedRO()
    call SdEdit()
    set noreadonly
endfunction

autocmd FileChangedRO * call OnFileChangedRO()

function! OnFileChangedShell()
    if s:ignoreChange == 1
        let v:fcs_choice   = 0
        let s:ignoreChange = 0
    else
        let v:fcs_choice="ask"
    endif
endfunction

autocmd FileChangedShell * call OnFileChangedShell()

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
let g:FileList_IndexFile = $INETROOT . "/filetags"
let g:FileList_MaxToShow = 72

