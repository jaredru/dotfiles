set showtabline=2

function! BuildTabline()
    let l:bufs = filter(range(1, bufnr('$')), 'buflisted(v:val)')
    let l:cur = bufnr('%')
    let l:s = ''
    let l:prev_active = 0

    for l:i in range(len(l:bufs))
        let l:bufnr = l:bufs[l:i]
        let l:name = fnamemodify(bufname(l:bufnr), ':t')
        if empty(l:name) | let l:name = '[No Name]' | endif
        let l:active = (l:bufnr == l:cur)

        " separator before this tab
        if l:active && !l:prev_active && l:i > 0
            let l:s .= '%#TLSepFillToSel#' . "\ue0b0"
        elseif !l:active && l:prev_active
            let l:s .= '%#TLSepSelToTab#' . "\ue0b0"
        elseif !l:active && !l:prev_active && l:i > 0
            let l:s .= '%#TLSubSep#' . "\ue0b1"
        endif

        if l:active
            let l:s .= '%#TabLineSel# ' . l:bufnr . ' ' . l:name . ' '
        else
            let l:s .= '%#TabLine# ' . l:bufnr . ' ' . l:name . ' '
        endif

        let l:prev_active = l:active
    endfor

    " closing separator
    if l:prev_active
        let l:s .= '%#TLSepSelToFill#' . "\ue0b0"
    endif

    return l:s . '%#TabLineFill#'
endfunction

set tabline=%!BuildTabline()

" vim:ft=vim:ff=unix
