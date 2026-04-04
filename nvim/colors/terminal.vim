" terminal.vim — a colorscheme that uses the terminal's color palette directly
"
" Uses ANSI colors 0-15 and base24 extended palette 16-23.
" Designed for use with a base24-compatible terminal theme.
"
"   0  background              8  bright black (comments)
"   1  red (variables)         9  bright red
"   2  green (strings)        10  bright green
"   3  yellow (types)         11  bright yellow
"   4  blue (functions)       12  bright blue
"   5  purple (keywords)      13  bright purple
"   6  cyan (special)         14  bright cyan
"   7  foreground             15  bright white
"  16  orange                 20  dark foreground
"  17  brown                  21  light foreground
"  18  dark background        22  darker background
"  19  selection              23  darkest background
"
" Change your terminal theme and everything here updates.

hi clear
if exists('syntax_on') | syntax reset | endif
let g:colors_name = 'terminal'
set background=dark

""""""""""""""""""""""""""""""""""""""""""""""""""
" Syntax
"

hi Normal       ctermfg=7   ctermbg=0   cterm=NONE
hi Bold         cterm=bold
hi Italic       cterm=italic
hi Underlined   cterm=underline

hi Comment      ctermfg=8               cterm=NONE
hi Constant     ctermfg=9               cterm=NONE
hi String       ctermfg=2               cterm=NONE
hi Character    ctermfg=1               cterm=NONE
hi Number       ctermfg=9               cterm=NONE
hi Boolean      ctermfg=9               cterm=NONE
hi Float        ctermfg=9               cterm=NONE
hi Identifier   ctermfg=1               cterm=NONE
hi Function     ctermfg=4               cterm=NONE
hi Statement    ctermfg=5               cterm=NONE
hi Conditional  ctermfg=5               cterm=NONE
hi Repeat       ctermfg=3               cterm=NONE
hi Label        ctermfg=3               cterm=NONE
hi Operator     ctermfg=7               cterm=NONE
hi Keyword      ctermfg=5               cterm=NONE
hi Exception    ctermfg=1               cterm=NONE
hi PreProc      ctermfg=3               cterm=NONE
hi Include      ctermfg=4               cterm=NONE
hi Define       ctermfg=5               cterm=NONE
hi Macro        ctermfg=1               cterm=NONE
hi PreCondit    ctermfg=3               cterm=NONE
hi Type         ctermfg=3               cterm=NONE
hi StorageClass ctermfg=3               cterm=NONE
hi Structure    ctermfg=5               cterm=NONE
hi Typedef      ctermfg=3               cterm=NONE
hi Special      ctermfg=6               cterm=NONE
hi SpecialChar  ctermfg=6               cterm=NONE
hi Tag          ctermfg=3               cterm=NONE
hi Delimiter    ctermfg=8               cterm=NONE
hi SpecialComment ctermfg=6             cterm=NONE
hi Debug        ctermfg=1               cterm=NONE
hi Error        ctermfg=0  ctermbg=1    cterm=NONE
hi Todo         ctermfg=3  ctermbg=0    cterm=bold

""""""""""""""""""""""""""""""""""""""""""""""""""
" Treesitter
"
" Neovim links most @groups to standard groups by default.
" These override the ones that benefit from more specific colors.
"

hi @variable            ctermfg=1       cterm=NONE
hi @variable.builtin    ctermfg=6       cterm=NONE
hi @variable.parameter  ctermfg=1       cterm=NONE
hi @constant.builtin    ctermfg=9       cterm=NONE
hi @string.escape       ctermfg=6       cterm=NONE
hi @string.regex        ctermfg=6       cterm=NONE
hi @function.builtin    ctermfg=6       cterm=NONE
hi @function.method     ctermfg=4       cterm=NONE
hi @constructor         ctermfg=6       cterm=NONE
hi @keyword.function    ctermfg=5       cterm=NONE
hi @keyword.return      ctermfg=5       cterm=NONE
hi @keyword.operator    ctermfg=5       cterm=NONE
hi @type.builtin        ctermfg=3       cterm=NONE
hi @tag                 ctermfg=1       cterm=NONE
hi @tag.attribute       ctermfg=9       cterm=NONE
hi @tag.delimiter       ctermfg=8       cterm=NONE
hi @property            ctermfg=1       cterm=NONE
hi @punctuation         ctermfg=7       cterm=NONE
hi @punctuation.bracket ctermfg=7       cterm=NONE
hi @punctuation.delimiter ctermfg=8     cterm=NONE

""""""""""""""""""""""""""""""""""""""""""""""""""
" Editor UI
"
" Colors 16-23 provide base24's extended shades:
"   16 orange  17 brown  18 dark bg  19 selection
"   20 dark fg  21 light fg  22 darker bg  23 darkest bg
"

hi LineNr       ctermfg=8  ctermbg=18   cterm=NONE
hi CursorLine              ctermbg=19   cterm=NONE
hi CursorLineNr ctermfg=7  ctermbg=19   cterm=NONE
hi CursorColumn            ctermbg=19   cterm=NONE
hi Visual                  ctermbg=19   cterm=NONE
hi VisualNOS               ctermbg=19   cterm=NONE
hi ColorColumn             ctermbg=19   cterm=NONE
hi SignColumn   ctermfg=8  ctermbg=18   cterm=NONE
hi FoldColumn   ctermfg=6  ctermbg=18   cterm=NONE
hi Folded       ctermfg=8  ctermbg=18   cterm=NONE
hi VertSplit    ctermfg=8  ctermbg=0    cterm=NONE
hi WinSeparator ctermfg=8  ctermbg=0    cterm=NONE
hi Cursor       ctermfg=0  ctermbg=7    cterm=NONE
hi NonText      ctermfg=8               cterm=NONE
hi SpecialKey   ctermfg=8               cterm=NONE
hi MatchParen   ctermfg=15 ctermbg=8    cterm=bold
hi Title        ctermfg=4               cterm=NONE
hi Directory    ctermfg=4               cterm=NONE
hi Conceal      ctermfg=4  ctermbg=0    cterm=NONE

""""""""""""""""""""""""""""""""""""""""""""""""""
" Messages
"

hi Question     ctermfg=2               cterm=NONE
hi MoreMsg      ctermfg=2               cterm=NONE
hi WarningMsg   ctermfg=3               cterm=NONE
hi ErrorMsg     ctermfg=1  ctermbg=0    cterm=NONE
hi ModeMsg      ctermfg=2               cterm=NONE

""""""""""""""""""""""""""""""""""""""""""""""""""
" Search & Completion
"

hi IncSearch    ctermfg=0  ctermbg=9    cterm=NONE
hi Search       ctermfg=0  ctermbg=3    cterm=NONE
hi Pmenu        ctermfg=7  ctermbg=8    cterm=NONE
hi PmenuSel     ctermfg=0  ctermbg=4    cterm=NONE
hi PmenuSbar               ctermbg=8    cterm=NONE
hi PmenuThumb              ctermbg=7    cterm=NONE
hi WildMenu     ctermfg=0  ctermbg=4    cterm=NONE

""""""""""""""""""""""""""""""""""""""""""""""""""
" Floating Windows
"

hi NormalFloat  ctermfg=7  ctermbg=8    cterm=NONE
hi FloatBorder  ctermfg=8  ctermbg=NONE cterm=NONE

""""""""""""""""""""""""""""""""""""""""""""""""""
" Diff
"

hi DiffAdd      ctermfg=10 ctermbg=NONE cterm=NONE
hi DiffChange   ctermfg=8  ctermbg=NONE cterm=NONE
hi DiffDelete   ctermfg=9  ctermbg=NONE cterm=NONE
hi DiffText     ctermfg=12 ctermbg=NONE cterm=NONE

""""""""""""""""""""""""""""""""""""""""""""""""""
" Diagnostics
"

hi DiagnosticError ctermfg=1            cterm=NONE
hi DiagnosticWarn  ctermfg=3            cterm=NONE
hi DiagnosticInfo  ctermfg=4            cterm=NONE
hi DiagnosticHint  ctermfg=6            cterm=NONE

""""""""""""""""""""""""""""""""""""""""""""""""""
" Git Signs (vim-signify)
"

hi SignifySignAdd    ctermfg=2  ctermbg=NONE cterm=NONE
hi SignifySignChange ctermfg=3  ctermbg=NONE cterm=NONE
hi SignifySignDelete ctermfg=1  ctermbg=NONE cterm=NONE

""""""""""""""""""""""""""""""""""""""""""""""""""
" Statusline
"

" mode sections: dark text on syntax-derived color
hi StlNormal    ctermfg=0  ctermbg=4    cterm=bold
hi StlInsert    ctermfg=0  ctermbg=2    cterm=bold
hi StlVisual    ctermfg=0  ctermbg=5    cterm=bold
hi StlReplace   ctermfg=0  ctermbg=1    cterm=bold
hi StlCommand   ctermfg=0  ctermbg=3    cterm=bold

" powerline separators: mode color → mid section
hi StlSepN      ctermfg=4  ctermbg=18   cterm=NONE
hi StlSepI      ctermfg=2  ctermbg=18   cterm=NONE
hi StlSepV      ctermfg=5  ctermbg=18   cterm=NONE
hi StlSepR      ctermfg=1  ctermbg=18   cterm=NONE
hi StlSepC      ctermfg=3  ctermbg=18   cterm=NONE

" mid and right sections
hi StlMid       ctermfg=7  ctermbg=18   cterm=NONE
hi StlRSep      ctermfg=7  ctermbg=18   cterm=NONE
hi StlRight     ctermfg=0  ctermbg=7    cterm=NONE

hi StatusLine   ctermfg=7  ctermbg=18   cterm=NONE
hi StatusLineNC ctermfg=8  ctermbg=18   cterm=NONE

""""""""""""""""""""""""""""""""""""""""""""""""""
" Tabline
"

" inactive: dim on base01 background (matches statusbar); active: dark on cyan
hi TabLine      ctermfg=20 ctermbg=18   cterm=NONE
hi TabLineSel   ctermfg=0  ctermbg=6    cterm=bold
hi TabLineFill  ctermfg=18 ctermbg=18   cterm=NONE

" powerline separators around active tab (sel bg=6, fill/tab bg=18)
hi TLSepSelToFill ctermfg=6  ctermbg=18  cterm=NONE
hi TLSepFillToSel ctermfg=18 ctermbg=6   cterm=NONE
hi TLSepSelToTab  ctermfg=6  ctermbg=18  cterm=NONE
hi TLSepTabToSel  ctermfg=18 ctermbg=6   cterm=NONE

" thin subseparator between inactive tabs
hi TLSubSep     ctermfg=8  ctermbg=18   cterm=NONE

" vim:ft=vim:ff=unix
