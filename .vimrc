"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => General
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""


" Set 'nocompatible' to ward off unexpected things that your distro might
" have made, as well as sanely reset options when re-sourcing .vimrc
set nocompatible

" Set to auto read when a file is changed from the outside
set autoread

" Attempt to determine the type of a file based on its name and possibly its
" contents. Use this to allow intelligent auto-indenting for each filetype,
" and for plugins that are filetype specific.
filetype indent plugin on

" Enable syntax highlighting
syntax on

" With a map leader it's possible to do extra key combinations
" like <leader>w saves the current file
let mapleader = "`"

" Autosave when leaving insert mode
autocmd InsertLeave * write


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => VIM user interface
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""


" Highlight searches (use <C-L> to temporarily turn off highlighting; see the
" mapping of <C-L> below)
" incsearch ensures results are highlighted as charachters are entered
set incsearch
set hlsearch

" Use case insensitive search, except when using capital letters
set ignorecase
set smartcase

" Allow backspacing over autoindent, line breaks and start of insert action
set backspace=indent,eol,start

" When opening a new line and no filetype-specific indenting is enabled, keep
" the same indent as the line you're currently on. Useful for READMEs, etc.
set autoindent

" Indent line breaks like they should be.
set breakindent linebreak

" Stop certain movements from always going to the first character of a line.
" While this behaviour deviates from that of Vi, it does what most users
" coming from other editors would expect.
set nostartofline

" Display the cursor position on the last line of the screen or in the status
" line of a window
set ruler

" Instead of failing a command because of unsaved changes, instead raise a
" dialogue asking if you wish to save changed files.
set confirm

" Display line numbers on the left
set number relativenumber

" Always keep the cursor centred on the screen
set scrolloff=999

" Show current command in the bottom
set showcmd

" Ensure correct syntax highlighting in fortran
let fortran_free_source=1
let fortran_more_precise=1
let fortran_do_enddo=1


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Mappings
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""


" Fast saving
nmap <leader>w :w!<cr>

" Fast quitting
nmap <leader>q :q<cr>

" Fast commenting
nmap <leader>c gcc

" Map Y to act like D and C, i.e. to yank until EOL, rather than act as yy,
" which is the default
map Y y$

" Map B to beginning of line, and E to end of line
map B ^
map E $

" move vertically by visual line (don't skip wrapped lines)
nnoremap j gj
nnoremap k gk

map <Down> gj
map <Up> gk

imap <Down> <Esc>gji
imap <Up> <Esc>gki

" Recenter screen after jump commands
nnoremap <C-U> 11kzz
nnoremap <C-D> 11jzz

nnoremap n nzz
nnoremap N Nzz

" Map <C-L> (redraw screen) to also turn off search highlighting until the
" next search
nnoremap <C-L> :nohl<cr><C-L>

" Use F9 as a quick way to run python files
" autocmd FileType python map <buffer> <F9> :w<CR>:exec '!python3' shellescape(@%, 1)<CR>
" autocmd FileType python imap <buffer> <F9> <esc>:w<CR>:exec '!python3' shellescape(@%, 1)<CR>
autocmd FileType python map <buffer> <F9> :w<CR>:exec '!export DISPLAY=localhost:0.0; clear; python3' shellescape(@%, 1)<CR>

" Use F9 as a quick way to run fortran files using make
autocmd FileType fortran map <buffer> <F9> :w<CR>:exec '!clear; make' expand('%:r')<CR>

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Text, tab and indent related
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""


" Indentation settings for using hard tabs for indent. Display tabs as four
" characters wide
set shiftwidth=4
set tabstop=4

" Set the encoding to UTF-8
set encoding=utf-8

set textwidth=80
set formatoptions=crnj

" Shift-Tab will reverse indent a line
inoremap <S-Tab> <C-D>

" Remap tab to 4 spaces in fortran files
autocmd FileType fortran setlocal expandtab
autocmd FileType fortran setlocal softtabstop=4


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Spellcheck configuration
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""


autocmd FileType tex setlocal spell
set spelllang=en_gb

nmap <leader>f ma[s1z=`a
imap <C-f> <Esc>ma[s1z=`ai


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Plugins, via VimPlug
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

 
if empty(glob('~/.vim/autoload/plug.vim'))
	silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
		\ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
	autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin('~/.vim/plugged')

" VimTex pluggin for using latex in Vim
Plug 'lervag/vimtex'
let g:tex_flavor='latex'
let g:vimtex_view_method='zathura_simple'
let g:vimtex_quickfix_mode=0
let g:vimtex_view_zathura_use_synctex=0
set conceallevel=2
let g:tex_conceal='abdmgs'

" Vim Snips for latex snippets
Plug 'sirver/ultisnips'
let g:UltiSnipsExpandTrigger = '<tab>'
let g:UltiSnipsJumpForwardTrigger = '<tab>'
let g:UltiSnipsJumpBackwardTrigger = '<s-tab>'
let g:UltiSnipsEditSplit = 'vertical'

" Color scheme wal
Plug 'dylanaraps/wal'

"Copilot
" Plug 'github/copilot'

" Comment and uncomment using "gcc" command
Plug 'tpope/vim-commentary'

" Goyo, Distraction-free writing in Vim
Plug 'junegunn/goyo.vim'

call plug#end()

" Set colorscheme
colorscheme wal
set background=dark

" Clear weird tex conceal highlighting
hi clear Conceal

" Clean after you're finished in vimtex
augroup vimtex_config
	autocmd!
	autocmd User VimtexQuit call vimtex#latexmk#clean(0)
augroup END

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Goyo settings
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""


"Shortcut for entering Goyo
nmap <leader>g :Goyo<cr>

" Ensure :q to quit even when Goyo is active
" https://github.com/junegunn/goyo.vim/wiki/Customization
function! s:goyo_enter()
	let b:quitting = 0
	let b:quitting_bang = 0
	autocmd QuitPre <buffer> let b:quitting = 1
	cabbrev <buffer> q! let b:quitting_bang = 1 <bar> q!
endfunction

function! s:goyo_leave()
	" Quit Vim if this is the only remaining buffer
	if b:quitting && len(filter(range(1, bufnr('$')), 'buflisted(v:val)')) == 1
		if b:quitting_bang
			qa!
		else
			qa
		endif
	endif
endfunction

autocmd! User GoyoEnter call <SID>goyo_enter()
autocmd! User GoyoLeave call <SID>goyo_leave()
