"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Start with the defaults.

unlet! skip_defaults_vim
source $VIMRUNTIME/defaults.vim

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Disable Newtr plug-in.

let loaded_netrwPlugin=1

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Install plugins.

call plug#begin(expand('~/.vim/plugged'))

	" The default plugin directory will be as follows:
	"   - Vim (Linux/macOS): '~/.vim/plugged'
	"   - Vim (Windows): '~/vimfiles/plugged'
	"   - Neovim (Linux/macOS/Windows): stdpath('data') . '/plugged'
	" You can specify a custom plugin directory by passing it as the argument
	"   - e.g. `call plug#begin('~/.vim/plugged')`
	"   - Avoid using standard Vim directory names like 'plugin'

	" Display
	Plug 'NLKNguyen/papercolor-theme'
	Plug 'sainnhe/edge'             " theme based on Material
	Plug 'ryanoasis/vim-devicons'   " symbols and icons
	Plug 'bluz71/vim-mistfly-statusline'

	" Programming
	" Plug 'sheerun/vim-polyglot'    " improved highlighting but huge
	Plug 'airblade/vim-gitgutter'   " git integration
	Plug 'dense-analysis/ale'       " language server, linting, etc
	Plug 'LunarWatcher/auto-pairs'  " maintained fork of jiangmiao/auto-pairs
	Plug 'tpope/vim-fugitive'       " git integration
	Plug 'tpope/vim-surround'       " surround actions
	Plug 'tpope/vim-commentary'     " comment stuff out
	" Plug 'preservim/nerdcommenter'  " lots of features but missing motions
	Plug 'preservim/tagbar'         " tag browser

	" Utilities
	Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
	Plug 'junegunn/fzf.vim'         " fuzzy search
	Plug 'junegunn/vim-easy-align'  " alignment
	Plug 'preservim/nerdtree', { 'on': [ 'NERDTree', 'NERDTreeToggle' ] }
	Plug 'simeji/winresizer'        " window resizer

call plug#end()

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" General configuration.

"" https://github.com/liuchengxu/vim-better-default/blob/master/plugin/default.vim

syntax on                      " syntax highlighting
filetype plugin indent on      " automatically detect file types

set autoindent                 " indent at the same level of the previous line
set smartindent                " do the right thing (mostly) in programs
set tabstop=4                  " redefine tab as four spaces
set softtabstop=4              " number of spaces in tab when editing
set shiftwidth=4               " change the number of space characters for indentation

set autoread                   " automatically read a file changed outside of vim
set encoding=UTF-8             " set default encoding
set history=10000              " maximum history record

"" https://learnvim.irian.to/basics/views_sessions_viminfo

set viminfo=!,%,<800,'10,/50,:100,h,f0,n~/.vim/cache/.viminfo
"           | | |    |   |   |    | |  + viminfo file path
"           | | |    |   |   |    | + file marks 0-9,A-Z 0=NOT stored
"           | | |    |   |   |    + disable 'hlsearch' loading viminfo
"           | | |    |   |   + command-line history saved
"           | | |    |   + search history saved
"           | | |    + files marks saved
"           | | + lines saved each register (new name for ", vi6.2)
"           | + save/restore buffer list
"           + save/restore upper case global variables

set background=light           " light background"
set backspace=indent,eol,start " backspace through everything
set cursorline                 " highlight current line
set display=lastline           " show as much as possible of the last line
set laststatus=2               " always show status line
set mousehide                  " hide the mouse cursor while typing
set nowrap                     " do not wrap long lines
set number                     " line numbers on
set relativenumber             " relative numbers on
set ruler                      " show the ruler
set scrolljump=5               " line to scroll when cursor leaves screen
set scrolloff=3                " minimum lines to keep above and below cursor
set showmatch                  " show matching brackets/parenthesis
set signcolumn=yes             " show sign column"
set splitbelow                 " puts new split windows to the bottom of the current
set splitright                 " puts new vsplit windows to the right of the current

set listchars=eol:¬,trail:·,tab:▸\ ,extends:↷,precedes:↶ list

set hlsearch                   " highlight search terms
set incsearch                  " find as you type search
set ignorecase                 " case insensitive search
set smartcase                  " ... but case sensitive when upper case is present

"" https://medium.com/usevim/set-complete-e76b9f196f0f
"" https://medium.com/usevim/vim-101-completion-compendium-97b4ebc3a45a

set complete-=i                " disable completion based on included files
set complete+=k,kspell         " enable dictionary completion
set completeopt=fuzzy,menuone,preview,noselect,noinsert
set omnifunc=syntaxcomplete#Complete
set spell spelllang=en_gb      " set language to proper English"
set wildmenu                   " show list instead of just completing
set wildmode=list:longest,full " list all matches, complete next full match

"" https://alldrops.info/posts/vim-drops/2018-04-25_javascript-folding-on-vim/

set foldmethod=syntax          " syntax enabled folds
set foldcolumn=1               " use the first column to indicate folding
set foldlevelstart=99          " start file with all folds opened

if has('persistent_undo')
	set undofile               " persistent undo
	set undolevels=1000        " maximum number of changes that can be undone
	set undoreload=10000       " maximum number lines to save for undo on a buffer reload
endif

if $TERM == 'truecolor'
	set termguicolors
	let g:edge_material_background = 'soft'
	let g:edge_better_performace = 1
	colorscheme edge
else
	colorscheme PaperColor
endif

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Override auto comment continuation feature for all file types.

augroup NoAutoComment
  au!
  au FileType * setlocal formatoptions-=cro
augroup end

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Close the tab if NERDTree is the only window remaining in it.

autocmd BufEnter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree())
			\    |   call feedkeys(":quit\<CR>:\<BS>")
			\    | endif

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Language server configuration.

let g:ale_completion_enabled = 1
let g:ale_open_list = 1
let g:ale_virtualtext_cursor = 'disabled'

let g:ale_linters_explicit = 1
let g:ale_linters = {
			\ 'python': ['ruff'],
			\ 'sml': ['sml'],
			\ 'rust': ['analyzer'],
			\ }

let g:ale_fix_on_save = 1
let g:ale_fixers = {
			\ '*': ['remove_trailing_lines', 'trim_whitespace'],
			\ 'python': ['ruff'],
			\ 'rust': ['rustfmt'],
			\ }

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Mappings.

" https://stackoverflow.com/questions/3776117/what-is-the-difference-between-the-remap-noremap-nnoremap-and-vnoremap-mapping

"" change the leader to comma
let mapleader = ','

"" open terminal
map <Leader>' :terminal<CR>

"" cycle through buffers
nnoremap <Leader>bp :bprevious<CR>
nnoremap <Leader>bn :bnext<CR>
nnoremap <Leader>bf :bfirst<CR>
nnoremap <Leader>bl :blast<CR>
nnoremap <Leader>bd :bd<CR>
nnoremap <Leader>bk :bw<CR>

"" folding
nnoremap <Leader>0 :set foldlevel=0<CR>
nnoremap <Leader>1 :set foldlevel=1<CR>
nnoremap <Leader>2 :set foldlevel=2<CR>
nnoremap <Leader>3 :set foldlevel=3<CR>
nnoremap <Leader>4 :set foldlevel=4<CR>
nnoremap <Leader>5 :set foldlevel=5<CR>
nnoremap <Leader>6 :set foldlevel=6<CR>
nnoremap <Leader>7 :set foldlevel=7<CR>
nnoremap <Leader>8 :set foldlevel=8<CR>
nnoremap <Leader>9 :set foldlevel=9<CR>

"" visual shifting (does not exit Visual mode)
vnoremap < <gv
vnoremap > >gv

"" NERDTree
"" https://github.com/preservim/nerdtree
nmap <F9> :NERDTreeToggle<CR>

"" FZF
"" https://thevaluable.dev/practical-guide-fzf-example/
nnoremap <leader>f :FZF <CR>
nnoremap <leader>F :Files <CR>

"" FZF selecting mappings
nmap <leader><tab> <plug>(fzf-maps-n)
xmap <leader><tab> <plug>(fzf-maps-x)
omap <leader><tab> <plug>(fzf-maps-o)

"" FZF insert mode completion
imap <C-x><C-k> <plug>(fzf-complete-word)
imap <C-x><C-f> <plug>(fzf-complete-path)
imap <C-x><C-l> <plug>(fzf-complete-line)

"" open Tagbar
nmap <F8> :TagbarToggle<CR>

"" start interactive EasyAlign in visual mode (e.g. vipga)
xmap ga <Plug>(EasyAlign)

"" start interactive EasyAlign for a motion/text object (e.g. gaip)
nmap ga <Plug>(EasyAlign)
