let $LANG = 'en_US.UTF-8'
let g:mapleader = "\<Space>"

syntax enable

set number
set signcolumn=yes
set expandtab
set tabstop=4
set shiftwidth=4
set shiftround
set autoindent
set smartindent
set showmatch
set matchpairs& matchpairs+=<:>
set matchtime=3
set backspace=indent,eol,start
set virtualedit+=block
set list
set listchars=tab:»~,trail:~
set wildmenu
set encoding=utf-8
set fileencoding=utf-8
set fileencodings=utf-8,shift-jis
set fileformats=unix,dos,mac
set clipboard+=unnamed,unnamedplus
set wildmode=longest,full
set ruler
set cursorline
set colorcolumn=100
set guicursor=
set termguicolors
set undodir=$XDG_CONFIG_HOME/nvim/undo
set undofile
set splitbelow
set splitright
set hlsearch
set incsearch
set ignorecase
set wrapscan
set nowrap
set infercase
set nostartofline
set nowritebackup
set nobackup
set cmdheight=2
set laststatus=2
set updatetime=300
set autoread
set visualbell t_vb=
set noerrorbells
set foldmethod=manual

function! EmacsCtrlK()
  let s:currentLine = getline('.')
  let s:nextLine = getline(line('.')+1)
  let s:currentCol = col('.')
  let s:endCol = col('$')-1

  if s:currentLine == ""
    :normal dd
  else
    if s:currentCol == s:endCol
      if s:nextLine == ""
        :normal J
      else
        :normal Jh
      endif
    elseif s:currentCol == 1
      normal D
    else
      :normal lD
    endif
  endif
endfunction

function! s:install_vim_plug() abort
  let l:plug_url = 'https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
  let l:autoload_dir = expand('$XDG_DATA_HOME/nvim/site/autoload')
  if !isdirectory(l:autoload_dir) | call mkdir(l:autoload_dir, 'p', 0700) | endif
  let l:plug_path = expand(l:autoload_dir . '/plug.vim')
  call system('curl -fLo ' . l:plug_path . ' ' . l:plug_url)
endfunction

if empty(globpath(&runtimepath, '*/plug.vim'))
  call s:install_vim_plug()
endif

call plug#begin(expand('$XDG_DATA_HOME/nvim/plugged'))
Plug 'projekt0n/github-nvim-theme', { 'tag': 'v0.0.7' }
Plug 'mattn/vim-goimports'
Plug 'preservim/nerdtree', { 'on': 'NERDTreeToggle' }
Plug 'preservim/nerdcommenter'
Plug 'Xuyuanp/nerdtree-git-plugin'
Plug 'ryanoasis/vim-devicons'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'neoclide/coc.nvim', { 'branch': 'release' }
Plug 'cohama/lexima.vim'
Plug 'nvim-treesitter/nvim-treesitter', { 'do': ':TSUpdate' }
Plug 'junegunn/fzf'
Plug 'junegunn/fzf.vim'
call plug#end()

colorscheme github_dimmed

let g:goimports_simplify = 1
let g:goimports_cmd = 'gosimports'

let g:NERDTreeShowHidden = 1
augroup nerdtree
  autocmd!
  autocmd FileType nerdtree setlocal signcolumn=auto
augroup END

let g:airline_powerline_fonts = 1
let g:airline#extensions#tabline#enabled = 1

let g:coc_global_extensions = [
  \ 'coc-json',
  \ 'coc-yaml',
  \ 'coc-tsserver',
  \ 'coc-prettier',
  \ 'coc-eslint',
  \ 'coc-deno',
  \ 'coc-python',
  \ 'coc-tailwindcss',
  \ 'coc-sh',
  \ 'coc-diagnostic',
  \ 'coc-vimlsp',
  \ 'coc-go',
  \ 'coc-markdownlint',
  \ 'coc-lua',
  \ ]
noremap <silent> bb :call CocActionAsync('jumpDefinition')<CR>zz
noremap <silent> bi :call CocActionAsync('jumpImplementation')<CR>zz
noremap <silent> bu :call CocActionAsync('jumpReferences')<CR>zz
autocmd CursorHold * silent call CocActionAsync('highlight')

call lexima#add_rule({'char': '<', 'input_after': '>'})
call lexima#add_rule({'char': '<BS>', 'at': '<$#>', 'delete': 1})

nnoremap <silent> <C-y> :NERDTreeToggle<CR>

noremap <silent> <C-w> :bdelete<CR>
noremap <silent> <C-t> :bnext<CR>

inoremap <silent><expr> <CR> coc#pum#visible() ? coc#pum#confirm() : "\<C-g>u\<CR>\<C-r>=coc#on_enter()\<CR>"

lua <<EOF
require('nvim-treesitter.configs').setup {
  auto_install = true,
  highlight = {
    enable = true,
  },
  indent = {
    enable = true,
  },
}
EOF

nnoremap <C-[> <C-o>
nnoremap <C-]> <C-i>
nnoremap <C-o> :<C-u>Files<CR>

nnoremap <C-g> :terminal<CR>
tnoremap <ESC> <C-\><C-n>
autocmd TermOpen * startinsert
autocmd TermClose * execute 'bdelete! ' . expand('<abuf>>')

noremap s :source $XDG_CONFIG_HOME/nvim/init.vim<CR>
noremap ; :
noremap <C-p> <Up>
noremap <C-n> <Down>
noremap <C-f> <Right>
noremap <C-b> <Left>
noremap <C-a> <Home>
noremap <C-e> <End>
noremap <C-h> <BS>
noremap <C-d> <Del>
noremap de d$
noremap da d0
noremap dd dd<ESC>

inoremap <silent> <C-p> <Up>
inoremap <silent> <C-n> <Down>
inoremap <silent> <C-f> <Right>
inoremap <silent> <C-b> <Left>
inoremap <silent> <C-a> <Home>
inoremap <silent> <C-e> <End>
inoremap <silent> <C-h> <BS>
inoremap <silent> <C-d> <Del>
inoremap <silent> <C-k> <ESC>:call EmacsCtrlK()<CR>i
