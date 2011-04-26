
""""""""""""""""""""""""""""""""""""""""""""""""""
" Commenting
"

"
" Configuration Options
"

" Comment token for various languages
autocmd FileType c,cpp,java let b:CommentToken = '//'
autocmd FileType dosbatch   let b:CommentToken = '::'
autocmd FileType javascript let b:CommentToken = '//'
autocmd FileType makefile   let b:CommentToken = '#'
autocmd FileType python     let b:CommentToken = '#'
autocmd FileType snippet    let b:CommentToken = '#'
autocmd FileType vim        let b:CommentToken = '"'

"
" Commands
"

command! CommentLine   call s:CommentLine(0)
command! UnCommentLine call s:CommentLine(1)

command! CommentSelectedLines   call s:CommentSelectedLines(0)
command! UnCommentSelectedLines call s:CommentSelectedLines(1)

"
" Mappings
"

if !hasmapto(":CommentLine<CR>")
    noremap  <C-K>      :CommentLine<CR>
    inoremap <C-K> <C-O>:CommentLine<CR>
endif

if !hasmapto(":UnCommentLine<CR>")
    noremap  <C-J>      :UnCommentLine<CR>
    inoremap <C-J> <C-O>:UnCommentLine<CR>
endif

if !hasmapto(":CommentSelectedLine<CR>")
    xnoremap <C-K> <C-C>:CommentSelectedLines<CR>gv
    snoremap <C-K> <C-C>:CommentSelectedLines<CR>gv<C-G>
endif

if !hasmapto(":UnCommentSelectedLine<CR>")
    xnoremap <C-J> <C-C>:UnCommentSelectedLines<CR>gv
    snoremap <C-J> <C-C>:UnCommentSelectedLines<CR>gv<C-G>
endif

""""""""""""""""""""""""""""""""""""""""""""""""""
" Private
"

"
" Functions
"

" Comments/Uncomments multiple lines

function! s:CommentLines(first, last, uncomment)
    let l:WhiteSpace    = ""
    let l:WhiteSpaceLen = 1000 " this feels like a safe 'max' for whitespace

    " if we're commenting, we want to find the fewest whitespace characters at
    " the start of any given line.  we do this so we can later indent our
    " comments as much as possible while ensuring all our comments start in
    " the same column.
    if !a:uncomment
        let l:i = a:first
        while l:i <= a:last
            let l:line = getline(l:i)

            if strlen(l:line) > 0
                let l:LineWhiteSpace    = matchstr(l:line, '^\s*')
                let l:LineWhiteSpaceLen = strlen(l:LineWhiteSpace)
                if l:LineWhiteSpaceLen < l:WhiteSpaceLen
                    let l:WhiteSpace    = l:LineWhiteSpace
                    let l:WhiteSpaceLen = l:LineWhiteSpaceLen
                endif
            endif

            let l:i = l:i + 1
        endwhile
    endif

    " now we'll loop through the lines and comment or uncomment as appropriate
    let l:i = a:first
    while l:i <= a:last
        " are we commenting?
        if !a:uncomment
            " yes, add a comment
            " is this an empty line?
            if strlen(getline(l:i)) == 0
                " add whitespace for this line
                exec "normal " . l:i . "ggi" . l:WhiteSpace . b:CommentToken
            else
                exec l:i . 's/^\(.\{' . l:WhiteSpaceLen . '\}\)/\1' . escape(b:CommentToken, '/') . ' /'
            endif
        else
            " no, remove any comments we find
            silent! exec l:i . 's/^\(\s*\)' . escape(b:CommentToken, '/') . ' \?/\1/'

            " if the line is now only whitespace, delete the whitespace
            silent! exec l:i . 's/^\s*$//'
        endif

        let l:i = l:i + 1
    endwhile
endfunction

" Comments/Uncomments the cursor's line

function! s:CommentLine(uncomment)
    " save the cursor's position
    let l:col  = col(".")
    let l:line = line(".")

    " adjust for if we're commenting or not
    if a:uncomment
        let l:col = l:col - 2
    else
        let l:col = l:col + 2
    endif

    " comment our line
    call s:CommentLines(l:line, l:line, a:uncomment)

    " move the cursor back to the right column
    call cursor(0, l:col)
endfunction

" Comments/Uncomments visually selected lines

function! s:CommentSelectedLines(uncomment)
    let l:first   = line("'<")
    let l:last    = line("'>")

    " if you select an entire line (including an ending newline), your cursor
    " is technically on two lines.  generally you don't want the last line
    " commented in that case.
    if col("'>") == 1
        let l:last = l:last - 1
    endif

    " do the actual commenting
    call s:CommentLines(l:first, l:last, a:uncomment)
endfunction

" vim:ft=vim:ff=unix
