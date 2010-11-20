
""""""""""""""""""""""""""""""""""""""""""""""""""
" FileList
"

"
" Requires version 7.0 or higher
"

if v:version < 700
    echomsg "FileList plugin requires Vim 7.0 or higher"
    finish
endif

"
" Configuration Options
"

" Location of the file index
if !exists("FileList_IndexFile")
    let g:FileList_IndexFile    = "filetags"
endif

" Width of the file list when it's opened
if !exists("FileList_WindowWidth")
    let g:FileList_WindowWidth  = 70
endif

" Number of milliseconds to wait without a keystroke before updating
" the file list.
if !exists("FileList_UpdateTime")
    let g:FileList_UpdateTime   = 120
endif

" Shortcut for edit command
if !exists("FileList_EditShortcut")
    let g:FileList_EditShortcut = "<CR>"
endif

" Shortcut for split command
if !exists("FileList_SplitShortcut")
    let g:FileList_SplitShortcut = "<C-S>"
endif

" Shortcut for vsplit command
if !exists("FileList_VsplitShortcut")
    let g:FileList_VsplitShortcut = "<C-V>"
endif

"
" Commands
"

command! FileList       call s:InitFileList()
command! CloseFileList  call s:CloseFileList()

"
" Mappings
"

if !hasmapto(":FileList<CR>")
    map      <unique> <silent> <C-O>      :FileList<CR>
    inoremap <unique> <silent> <C-O> <C-O>:FileList<CR>
endif

""""""""""""""""""""""""""""""""""""""""""""""""""
" Private
"

"
" Script Variables
"

let s:WindowName    = "-FileList-"
let s:LastSearch    = ""

"
" Functions
"

" Focuses the window containing the given buffer name.

function! s:FocusWindow(window)
    let l:focused = 0

    " get our buffer
    let l:bufnr = bufnr(a:window)

    " do we have a buffer?
    if l:bufnr != -1
        " yes, get the window it's in
        let l:winnr = bufwinnr(l:bufnr)

        " do we have a window?
        if l:winnr != -1
            " yes, give it focus
            exec l:winnr . " wincmd w"
            let l:focused = 1
        endif
    endif

    return l:focused
endfunction

" Shows the file list window based.
" Creates it if it doesn't already exist.

function! s:ShowWindow()
    " only create our window if we can't focus an existing one
    if !s:FocusWindow(s:WindowName)
        exec "silent keepalt botright vsplit " . s:WindowName
        call append(1, "")
    endif

    " ensure our temporary buffer is setup correctly
    setlocal noswapfile
    setlocal buftype=nofile
    setlocal bufhidden=delete
    setlocal nowrap
    setlocal foldcolumn=0
    setlocal nonumber

    " make sure we use the right amount of space
    exec "vertical resize " . g:FileList_WindowWidth
endfunction

" Returns a list of files filtered by the given terms.

function! s:FilterFiles(terms)
    " only do work if we have terms to filter on
    if a:terms != ""
        " split the space-delimited parameter into a list
        let l:terms = split(a:terms)

        " filter the files based on the terms
        let l:files = copy(s:FileList)
        for l:term in l:terms
            call filter(l:files, "v:val =~ '" . escape(l:term, '/.\') . "'")
        endfor

        " try to match the actual file name, if there is one
        let l:regex = '\w*\.\?\w*'
        let l:match = matchstr(a:terms, l:regex)

        " if we got a match, put the matching filenames at the top of the results
        if l:match != ""

            " this seems to be a tad faster than the option below

            let l:match = escape(l:match, '/.\')

            let l:sorted = filter(copy(l:files), "v:val =~ '^" . l:match . "'")
            call extend(l:sorted, filter(l:files, "v:val !~ '^" . l:match . "'"))

            let l:files = l:sorted

            " this is the slower option mentioned above

            " let l:match = escape(l:match, '/.\')
            " let l:position = 0
            "
            " for l:i in range(len(l:files))
            "     if l:files[l:i] =~ "^" . l:match
            "         call insert(l:files, remove(l:files, l:i), l:position)
            "         let l:position += 1
            "     endif
            " endfor
        endif
    else
        " no search terms, use the whole list
        let l:files = s:FileList
    endif

    return l:files
endfunction

" Highlights the currently selected line

function! s:HighlightSelected()
    " clear anything that's currently highlighted
    silent! syn clear FileListLine

    " match the current line
    exec 'syn match FileListLine /\%' . s:Selection . 'l.*/'

    " link it to look like a search result
    hi link FileListLine Search

    " update the status line
    let l:selected = (s:Page-1) * s:FilesPerPage + s:Selection - 2
    exec 'setlocal statusline=-\ File\ List\ -%=-\ Match:\ ' . l:selected . '/' . len(s:Matches) . '\ -'
endfunction

" Displays the supplied list of files in the active buffer.

function! s:DisplayFiles()
    " save the cursor's position
    let l:cursor = col(".")

    " clear the current file list
    silent! 3,$d _

    " only do work if there are files to display
    if len(s:Matches)
        " determine range of files to show
        let l:start = s:FilesPerPage * (s:Page-1)
        let l:end = min([l:start + s:FilesPerPage, len(s:Matches)]) - 1

        " output our list of filtered files
        call append(2, remove(copy(s:Matches), l:start, l:end))

        " ensure selection isn't past the bottom of the list
        let s:Selection = min([s:Selection, line("$")])
        call s:HighlightSelected()
    endif

    " restore the cursor position
    call cursor(1, l:cursor)
endfunction

" Filters and displays the file list based on the current search terms

function! s:NewSearch(terms)
    " filter the files
    let s:Matches = s:FilterFiles(a:terms)

    " select the first file to begin with
    let s:Selection = 3
    let s:Page = 1
    let s:TotalPages = (len(s:Matches) / s:FilesPerPage) + 1

    " display the filtered list of files
    call s:DisplayFiles()

    " save the last search term
    let s:LastSearch = a:terms
endfunction

" Starts a new search using on the current search terms

function! s:UpdateFileList()
    " copy the search text
    let l:search = getline(1)

    " only do work if the search term is actually different
    if l:search != s:LastSearch
        " perform the new search
        call s:NewSearch(l:search)
    endif
endfunction

" Moves the current file selection up or down by pages

function! s:ChangePage(jump, ...)
    " which page are we trying to get to
    let l:page = s:Page + a:jump

    " ensure we don't overstep our bounds
    if l:page < 1
        " we're on the first page
        " select the first line
        let s:Selection = 3
        call s:HighlightSelected()
    elseif l:page > s:TotalPages
        " we're on the last page
        " select the last line
        let s:Selection = line("$")
        call s:HighlightSelected()
    else
        " update selection if specified
        if a:0
            let s:Selection = a:1
        endif

        " change pages as requested
        let s:Page = l:page
        call s:DisplayFiles()
    endif
endfunction

" Moves the current file selection up or down

function! s:ChangeSelection(jump)
    " which file are we trying to get to
    let l:selection = s:Selection + a:jump

    " ensure we don't overstep our bounds
    if l:selection < 3
        " we're on the first line
        " move up a page and select the last line
        call s:ChangePage(-1, line("$"))
    elseif l:selection > line("$")
        " we're on the last line
        " move down a page and select the first line
        call s:ChangePage(1, 3)
    else
        " change lines as requested
        let s:Selection = l:selection
        call s:HighlightSelected()
    endif
endfunction

" Opens the currently selected file

function! s:ChooseFile(command)
    " in case the user hit enter before the timeout
    call s:UpdateFileList()

    " copy the search text
    let l:line = getline(s:Selection)

    " regex to match the file
    let l:regex = '\(\f\+\) (\(.*\))'

    " match the experssion
    let l:match = matchstr(l:line, l:regex)

    " get the file and path out of the match
    let l:path = substitute(l:match, l:regex, '\2', '')
    let l:file = substitute(l:match, l:regex, '\1', '')

    " close the file list and open the file
    call s:CloseFileList()
    exec a:command . " " . l:path . '/' . l:file

    " ensure we're out of insert mode
    stopinsert
endfunction

" Initializes the file list window

function! s:InitWindow()
    " show and resize the list window
    call s:ShowWindow()

    " first two lines are for the search term
    let s:FilesPerPage = winheight(0) - 2

    " display the whole list of files to start with
    call s:NewSearch("")

    " fix lame mappings
    imap <buffer> <silent> <ESC>OA  <UP>
    imap <buffer> <silent> <ESC>OB  <DOWN>
    imap <buffer> <silent> <ESC>OC  <RIGHT>
    imap <buffer> <silent> <ESC>OD  <LEFT>
    setlocal timeoutlen=1

    " setup mappings
    inoremap <buffer> <silent> <ESC>        <ESC>:CloseFileList<CR>
    inoremap <buffer> <silent> <UP>         <C-O>:call <SID>ChangeSelection(-1)<CR>
    inoremap <buffer> <silent> <DOWN>       <C-O>:call <SID>ChangeSelection(1)<CR>
    inoremap <buffer> <silent> <PAGEUP>     <C-O>:call <SID>ChangePage(-1)<CR>
    inoremap <buffer> <silent> <PAGEDOWN>   <C-O>:call <SID>ChangePage(1)<CR>
    inoremap <buffer> <silent> <C-HOME>     <C-O>:call <SID>ChangePage(-<SID>NumberOfPages)<CR>
    inoremap <buffer> <silent> <C-END>      <C-O>:call <SID>ChangePage(<SID>NumberOfPages)<CR>
    inoremap <buffer> <silent> <CR>         <C-O>:call <SID>ChooseFile()<CR>

    " edit/split/vsplit shortcut mappings
    exec "inoremap <buffer> <silent> " . g:FileList_EditShortcut   . " <C-O>:call <SID>ChooseFile('edit')<CR>"
    exec "inoremap <buffer> <silent> " . g:FileList_SplitShortcut  . " <C-O>:call <SID>ChooseFile('split')<CR>"
    exec "inoremap <buffer> <silent> " . g:FileList_VsplitShortcut . " <C-O>:call <SID>ChooseFile('vsplit')<CR>"

    " update the file list every so often
    exec "setlocal updatetime=" . g:FileList_UpdateTime
    autocmd! CursorHoldI <buffer> call s:UpdateFileList()

    " when the window loses focus, close it
    autocmd! BufLeave <buffer> call s:CloseFileList()

    " finally put us into insert mode
    startinsert
endfunction

" Displays the plugin in a default state

function! s:InitFileList()
    " need a file list for the script to work
    let l:file = findfile(g:FileList_IndexFile, ";")
    if filereadable(l:file)
        let s:FileList = readfile(l:file)
    else
        echoerr "File List index doesn't exist!"
        return
    endif

    " initialize the window
    call s:InitWindow()
endfunction

" Closes both windows of the file list and frees a bit of memory

function! s:CloseFileList()
    " close the window
    if s:FocusWindow(s:WindowName)
        close
    endif

    " free up some memory
    let s:FileList = []
    let s:Matches = []
    let s:LastSearch = ""
endfunction

" vim:ft=vim:ff=unix
