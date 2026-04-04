
"
" XDG Environment
"

if empty($XDG_CACHE_HOME)
    let $XDG_CACHE_HOME  = $HOME . "/.cache"
endif

if empty($XDG_CONFIG_HOME)
    let $XDG_CONFIG_HOME = $HOME . "/.config"
endif

""""""""""""""""""""""""""""""""""""""""""""""""""
" General
"

function! s:cache_path(suffix)
    return $XDG_CACHE_HOME . '/nvim/' . a:suffix
endfunction

function! s:ensure_dir(dir)
    if !isdirectory(a:dir) | call mkdir(a:dir, "p") | endif
endfunction

let &directory = s:cache_path('swap')
let &backupdir = s:cache_path('backup')
let &undodir   = s:cache_path('undo')
let &shadafile = s:cache_path('nviminfo')

call s:ensure_dir(&directory)
call s:ensure_dir(&backupdir)
call s:ensure_dir(&undodir)

set undofile

""""""""""""""""""""""""""""""""""""""""""""""""""
" Plugins
"

lua << EOF
local gh = function(repo) return "https://github.com/" .. repo end

vim.pack.add({
    gh("nvim-treesitter/nvim-treesitter"),
    gh("mbbill/undotree"),
    gh("jaredru/vim-commenter"),
    gh("junegunn/vim-easy-align"),
    gh("easymotion/vim-easymotion"),
    gh("derekwyatt/vim-fswitch"),
    gh("tpope/vim-fugitive"),
    gh("mhinz/vim-signify"),
    gh("tpope/vim-surround"),
    { src = "https://bitbucket.org/fouvrai/vim-filelist.git" },

    -- interesting things that i'm not actively using
    -- gh("airblade/vim-gitgutter"),
    -- gh("junegunn/gv.vim"),
    -- gh("tpope/vim-endwise"),
    -- gh("tpope/vim-jdaddy"),
    -- gh("tpope/vim-capslock"),
    -- gh("AndrewRadev/splitjoin.vim"),
    -- gh("junegunn/vim-after-object"),
    -- gh("justinmk/vim-gtfo"),
    -- gh("jiangmiao/auto-pairs"),
    -- gh("chrisbra/NrrwRgn"),
    -- gh("nathanaelkane/vim-indent-guides"),
}, { confirm = false })

-- treesitter highlight is built-in; parsers install via :TSInstall
vim.api.nvim_create_autocmd("FileType", {
    callback = function()
        pcall(vim.treesitter.start)
    end,
})
EOF

""""""""""""""""""""""""""""""""""""""""""""""""""
" Colors
"

set notermguicolors
colorscheme terminal


""""""""""""""""""""""""""""""""""""""""""""""""""
" Indentation
"

set tabstop=4
set softtabstop=4
set shiftwidth=4
set expandtab

""""""""""""""""""""""""""""""""""""""""""""""""""
" User Interface
"

set number
set signcolumn=yes
set nowrap
set nofoldenable
set selection=exclusive
set listchars=tab:»·,trail:•
set list
set showmatch
set visualbell
" set lazyredraw
set showcmd
set completeopt=menu,menuone,preview
set wildoptions=

""""""""""""""""""""""""""""""""""""""""""""""""""
" Movement
"

set scrolloff=3
set whichwrap+=<,>,[,],h,l
set virtualedit=block,onemore

""""""""""""""""""""""""""""""""""""""""""""""""""
" Searching
"

set ignorecase
set smartcase
set nohlsearch
set gdefault
set inccommand=nosplit

""""""""""""""""""""""""""""""""""""""""""""""""""
" Files
"

set autochdir

""""""""""""""""""""""""""""""""""""""""""""""""""
" Mappings
"

let mapleader=','

function! MultiMap(lhs, rhs)
    exec "nnoremap <silent>" . a:lhs . "      " . a:rhs . "<CR>"
    exec "inoremap <silent>" . a:lhs . " <C-O>" . a:rhs . "<CR>"
    exec "xnoremap <silent>" . a:lhs . "      " . a:rhs . "<CR>gv"
endfunction

call MultiMap("<C-F1>", ":e " . expand("<sfile>:p"))
call MultiMap("<Leader>hl", ":set hlsearch!")
call MultiMap("<Leader>w", ":bd")

vnoremap <D-c> "+ygv

noremap <C-TAB>   :bn<CR>
noremap <C-S-TAB> :bp<CR>

vnoremap > >gv
vnoremap < <gv

vnoremap p "_dp
vnoremap P "_dP

nnoremap <S-J> <PageDown>
nnoremap <S-K> <PageUp>
xnoremap <S-J> <S-PageDown>
xnoremap <S-K> <S-PageUp>

nnoremap j gj
nnoremap k gk
xnoremap j gj
xnoremap k gk

nnoremap <expr> 0 &wrap ? 'g0'  : '0'
nnoremap <expr> $ &wrap ? 'g$l' : '$l'
xnoremap <expr> 0 &wrap ? 'g0'  : '0'
xnoremap <expr> $ &wrap ? 'g$'  : '$'

noremap <Leader><S-J> <S-J>

nnoremap <Leader>json :.!python -m json.tool<CR>
vnoremap <Leader>json :!python -m json.tool<CR>

""""""""""""""""""""""""""""""""""""""""""""""""""
" Buffer Movement
"
" When a buffer is deleted, go to the next buffer (not the previous).
"

let s:nextBufnr = -1

function! s:OnBufEnter(buffer)
    if (s:nextBufnr != -1)
        exec "b " . s:nextBufnr
    endif
    let s:nextBufnr = -1
endfunction

function! s:OnBufDelete(buffer)
    let s:nextBufnr = -1
    if (winbufnr(2) == -1)
        let l:bufnrs = range(1, bufnr('$'))
        call filter(l:bufnrs, 'buflisted(v:val)')
        let l:bufnr = str2nr(a:buffer)
        let l:index = index(l:bufnrs, l:bufnr)
        if (l:index != -1)
            let l:nextIndex = l:index + 1
            if (len(l:bufnrs) <= l:nextIndex)
                let l:nextIndex = l:nextIndex - 2
            endif
            let s:nextBufnr = l:bufnrs[l:nextIndex]
        endif
    endif
endfunction

augroup BufferMovement
    autocmd!
    autocmd BufEnter  * call s:OnBufEnter(expand("<abuf>"))
    autocmd BufDelete * call s:OnBufDelete(expand("<abuf>"))
augroup end

""""""""""""""""""""""""""""""""""""""""""""""""""
" Syntax Highlighting
"

function! s:ShowSyntaxGroups()
    let l:id    = synID(line('.'), col('.'), 0)
    let l:names = []
    while 1
        call add(l:names, synIDattr(l:id, 'name'))
        let l:next = synIDtrans(l:id)
        if l:next != l:id
            let l:id = l:next
        else
            break
        endif
    endwhile
    echo join(l:names, ' -> ')
endfunction

nnoremap <Leader>sg :call <SID>ShowSyntaxGroups()<CR>

""""""""""""""""""""""""""""""""""""""""""""""""""
" Find & Replace
"

function! FindAndReplace()
    normal gv"hy
    if @h =~ "\n"
        return "'<,'>s/"
    else
        return "%s/" . escape(@h, '"\/') . "/"
    endif
endfunction

nnoremap <C-H>      :%s/<C-R><C-W>/
inoremap <C-H> <C-O>:%s/<C-R><C-W>/
vnoremap <C-H> <C-C>:<C-R>=FindAndReplace()<CR>

""""""""""""""""""""""""""""""""""""""""""""""""""
" Plugin Config
"

" filelist
call MultiMap("<Leader>f", ":FileList")
let g:FileList_CacheGenerationCommand = 'fd -t f . {dir} | sed -E "s#(.*)/([^/]+$)#\2 (\1)#" | sort -f > {out}'

" filetypes
augroup CustomFiletypes
    autocmd!
    autocmd BufRead,BufNewFile *.panel  setlocal filetype=json
    autocmd BufRead,BufNewFile Fastfile setlocal filetype=ruby
augroup end

augroup SourceHeaderPairs
    autocmd!
    autocmd BufEnter *.cpp,*.cxx,*.cc,*.c let b:fswitchdst  = "h,hpp"
    autocmd BufEnter *.hpp,*.hxx,*.h      let b:fswitchdst  = "cpp,cxx,cc,c"
    autocmd BufEnter *                     let b:fswitchlocs = "./"
augroup end

call MultiMap("<C-F10>", ":FSHere")

" commenter
nnoremap <silent> <C-K>      :Comment<CR>
inoremap <silent> <C-K> <C-O>:Comment<CR>
xnoremap <silent> <C-K>      :Comment<CR>gv

nnoremap <silent> <C-J>      :Uncomment<CR>
inoremap <silent> <C-J> <C-O>:Uncomment<CR>
xnoremap <silent> <C-J>      :Uncomment<CR>gv

" easymotion
let g:EasyMotion_enter_jump_first = 1
let g:EasyMotion_smartcase        = 1
let g:EasyMotion_use_upper        = 1
let g:EasyMotion_keys             = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ;'

map  <Leader><Leader> <Plug>(easymotion-prefix)
map  f                <Plug>(easymotion-f)
nmap s                <Plug>(easymotion-s2)
map  /                <Plug>(easymotion-sn)

noremap <Leader>/ /

" easy-align
nmap <Leader>a <Plug>(EasyAlign)ip
vmap <Leader>a <Plug>(EasyAlign)

""""""""""""""""""""""""""""""""""""""""""""""""""
" Autocommands
"

augroup RestoreCursor
    autocmd!
    autocmd BufReadPost * call RestorePosition()
augroup end

function! RestorePosition()
    if line("'\"") <= line("$")
        normal `"
    else
        normal G
    endif
endfunction

" for windows, if the file is a symbolic link, set backupcopy to yes
if has("win32")
    augroup WindowsSymlinks
        autocmd!
        autocmd BufReadPost * call s:HandleSymLinksOnWindows()
    augroup end

    function! s:HandleSymLinksOnWindows()
        let l:dir = system("dir " . expand("<afile>"))
        if (match(l:dir, "SYMLINK") != -1)
            setlocal backupcopy=yes
        endif
    endfunction
endif

augroup FormatOptions
    autocmd!
    autocmd FileType * setlocal formatoptions-=o formatoptions-=r
augroup end

" vim:ft=vim:ff=unix
