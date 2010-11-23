
"
" Additional Filetypes
"

augroup Filetypes
    autocmd! BufNewFile,BufRead *.inl,*.tmh,*.w setfiletype cpp
    autocmd! BufNewFile,BufRead *.ui,*.xaml     setfiletype xml
    autocmd! BufNewFile,BufRead sources         setfiletype makefile
augroup END

