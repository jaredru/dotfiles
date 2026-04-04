set noshowmode

function! BuildStatusLine()
    let l:m = mode()

    if l:m ==# 'i'
        let [l:mhl, l:shl, l:name] = ['StlInsert', 'StlSepI', 'INSERT']
    elseif l:m ==# 'v'
        let [l:mhl, l:shl, l:name] = ['StlVisual', 'StlSepV', 'VISUAL']
    elseif l:m ==# 'V'
        let [l:mhl, l:shl, l:name] = ['StlVisual', 'StlSepV', 'V-LINE']
    elseif l:m ==# "\<C-V>"
        let [l:mhl, l:shl, l:name] = ['StlVisual', 'StlSepV', 'V-BLOCK']
    elseif l:m ==# 'R'
        let [l:mhl, l:shl, l:name] = ['StlReplace', 'StlSepR', 'REPLACE']
    elseif l:m ==# 'c'
        let [l:mhl, l:shl, l:name] = ['StlCommand', 'StlSepC', 'COMMAND']
    elseif l:m ==# 't'
        let [l:mhl, l:shl, l:name] = ['StlNormal', 'StlSepN', 'TERMINAL']
    else
        let [l:mhl, l:shl, l:name] = ['StlNormal', 'StlSepN', 'NORMAL']
    endif

    let l:git = exists('*FugitiveHead') ? FugitiveHead() : ''
    let l:git_part = strlen(l:git)
        \ ? ' ' . "\ue0a0" . ' ' . l:git . ' ' . "\ue0b1"
        \ : ''

    return '%#' . l:mhl . '# ' . l:name . ' '
        \ . '%#' . l:shl . '#' . "\ue0b0"
        \ . '%#StlMid#' . l:git_part . ' %f %m'
        \ . '%='
        \ . '%#StlMid# %p%% '
        \ . '%#StlRSep#' . "\ue0b2"
        \ . '%#StlRight# %l:%c '
endfunction

let &statusline = '%{%BuildStatusLine()%}'

" vim:ft=vim:ff=unix
