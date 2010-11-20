"
" Jared's Color Scheme
"

set background=dark
hi clear

if exists("syntax_on")
    syntax reset
endif

"
" Unused Colors
"

" #262d51
" #343434
" #808080
" #c5c5fe
" #f6f3e8

"
" General UI
"

" regular text
hi Normal           guifg=White     guibg=#111111   gui=None
hi Normal           guifg=#dddddd   guibg=#111111   gui=None

" characters that aren't real text (e.g. trailing ~s)
hi NonText          guifg=#333333   guibg=NONE      gui=None

" flashing cursor
hi Cursor           guifg=Black     guibg=White     gui=None

"
" Gutters
"

" line numbers
hi LineNr           guifg=#444444   guibg=Black     gui=None

" status bar
hi StatusLine       guifg=#cccccc   guibg=#333333   gui=None

" status bar (inactive)
hi StatusLineNC     guifg=Black     guibg=#333333   gui=None

" vertical split between windows
hi VertSplit        guifg=#333333   guibg=#333333   gui=None

" command completion
hi WildMenu         guifg=#333333   guibg=#cccccc   gui=None

"
" Action-Created Text
"
" Special text as a result of some action (e.g. searching, selecting, entering insert mode)
"

" current mode (e.g. -- INSERT --)
hi ModeMsg          guifg=#333333   guibg=#cccccc   gui=Bold

" selected text
hi Visual           guifg=NONE      guibg=#333333   gui=None

" last search highlight
hi Search           guifg=Black     guibg=Yellow    gui=None
hi Search           guifg=#333333   guibg=#cccccc   gui=None

" titles for output (e.g. --- Options --- from ':set all')
hi Title            guifg=#96cbfe   guibg=NONE      gui=Bold

"hi Folded           guifg=#a0a8b0   guibg=#384048   gui=None
"hi Ignore           guifg=gray      guibg=black     gui=None

"
" Errors
"

" invalid text in the document
hi Error            guifg=NONE      guibg=NONE      gui=undercurl   guisp=#FF6C60   " undercurl color

" error message as the result of a command
hi ErrorMsg         guifg=Red       guibg=NONE      gui=None

" warning message as the result of a command
hi WarningMsg       guifg=Yellow    guibg=NONE      gui=None

"
" Syntax
"

" #808080
" #c5c5fe
" #99cc99

hi Comment          guifg=#888888   guibg=NONE      gui=None

hi Constant         guifg=#dd5555   guibg=NONE      gui=None
hi String           guifg=#ffee55   guibg=NONE      gui=None

hi Identifier       guifg=#aaddff   guibg=NONE      gui=None
hi Function         guifg=#996644   guibg=NONE      gui=None

hi Statement        guifg=#6699cc   guibg=NONE      gui=None
hi Label            guifg=#77dd77   guibg=NONE      gui=None
hi Operator         guifg=White     guibg=NONE      gui=None
hi Keyword          guifg=#96CBFE   guibg=NONE      gui=None

hi PreProc          guifg=#77bbaa   guibg=NONE      gui=None

hi Type             guifg=#ffbb66   guibg=NONE      gui=None
hi StorageClass     guifg=#ffffbb   guibg=NONE      gui=None

hi Special          guifg=#dd6611   guibg=NONE      gui=None
hi Delimiter        guifg=#00A0A0   guibg=NONE      gui=None

hi Todo             guifg=#aaaaaa   guibg=NONE      gui=Underline

hi MatchParen       guifg=White     guibg=#555555   gui=Bold
hi SpecialKey       guifg=#666666   guibg=#222222   gui=None        

hi link Character       Constant
hi link Number          Constant
hi link Boolean         Constant
hi link Float           Number
hi link Conditional     Statement
hi link Repeat          Statement
hi link Exception       Statement
hi link Include         PreProc
hi link Define          PreProc
hi link Macro           PreProc
hi link PreCondit       PreProc
hi link Structure       Type
hi link Typedef         Type
hi link Tag             Special
hi link SpecialChar     Special
hi link SpecialComment  Special
hi link Debug           Special

