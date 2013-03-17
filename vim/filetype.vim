
"
" Additional Filetypes
"

augroup Filetypes
    " Win32 CPP
    autocmd! BufNewFile,BufRead *.inl,*.tmh,*.w setfiletype cpp
    autocmd! BufNewFile,BufRead *.ui,*.xaml     setfiletype xml

    " CoreXT Build
    autocmd! BufNewFile,BufRead sources setfiletype makefile

    " MsBuild
    autocmd! BufNewFile,BufRead *.settings,*.targets,*.wwaproj setfiletype xml
augroup END

" vim:ft=vim:ff=unix
