if &compatible
  set nocompatible               " Be iMproved
endif

" Required:
set runtimepath+=~/.vim/bundle/neobundle.vim/

" Required:
call neobundle#begin(expand('~/.vim/bundle/'))

" Let NeoBundle manage NeoBundle
" Required:
NeoBundleFetch 'Shougo/neobundle.vim'
NeoBundle 'The-NERD-tree'
NeoBundle 'davidhalter/jedi-vim'
NeoBundle 'nathanaelkane/vim-indent-guides'
NeoBundle 'vim-scripts/grep.vim'
NeoBundle 'vim-scripts/minibufexplorerpp'
NeoBundle 'easymotion/vim-easymotion'
"NeoBundle 'tomasr/molokai'

" My Bundles here:
" Refer to |:NeoBundle-examples|.
" Note: You don't set neobundle setting in .gvimrc!

call neobundle#end()

" Required:
filetype plugin indent on

" If there are uninstalled bundles found on startup,
" this will conveniently prompt you to install them.
NeoBundleCheck

colorscheme slate
"set t_Co=256
set hlsearch
set number
set nowrap

"set term=builtin_linux
"set ttytype=builtin_linux
syntax on

set tabstop=2
set softtabstop=2
set shiftwidth=2
set expandtab
set autoindent
"set autochdir
scriptencoding utf-8
"set list
"set listchars=tab:>-,trail:-,eol:\
"augroup highlightZenkakuSpace "全角スペースを緑色にする
"  autocmd!
"  autocmd VimEnter,ColorScheme * highlight ZenkakuSpace term=underline ctermbg=DarkCyan guibg=DarkCyan
"  autocmd VimEnter,WinEnter * match ZenkakuSpace /　/
"augroup END

set hid

set nobackup

" remove tool bar. for gvim
set guioptions-=T
" remove menu. for gvim
"set guioptions-=

autocmd FileType * setlocal formatoptions-=ro

let g:miniBufExplMapWindowNavVim = 1
let g:miniBufExplMapWindowNavArrows = 1
let g:miniBufExplMapCTabSwitchBuffs = 1
let g:miniBufExplModSelTarget = 1

set cursorline
highlight CursorLine cterm=underline ctermfg=NONE ctermbg=NONE

" ## Cursor operations ## "
let g:EasyMotion_do_mapping = 0 " Disable default mappings

" Jump to anywhere you want with minimal keystrokes, with just one key binding.
" `s{char}{label}`
nmap s <Plug>(easymotion-overwin-f)
" or
" `s{char}{char}{label}`
" Need one more keystroke, but on average, it may be more comfortable.
"nmap s <Plug>(easymotion-overwin-f2)

" Turn on case insensitive feature
let g:EasyMotion_smartcase = 1

" JK motions: Line motions
map <Leader>j <Plug>(easymotion-j)
map <Leader>k <Plug>(easymotion-k)

" ## File operations ## "
" jump to place where current file is at
nnoremap <Space>cd :cd %:p:h<CR>

" sync NERD tree window with current file
nnoremap <silent> <Space>r :NERDTreeFind<CR>

