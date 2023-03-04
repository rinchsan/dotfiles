set number
set signcolumn=yes
set expandtab
set tabstop=4
set shiftwidth=4
set smartindent
set wildmenu
set encoding=utf-8
set fileencoding=utf-8
set fileencodings=utf-8,shift-jis
set fileformats=unix,dos,mac
set clipboard+=unnamed,unnamedplus
set wildmode=longest,full
set ruler
set cursorline

cnoremap init :<C-u>edit $HOME/.config/nvim/init.vim<CR>

noremap <Space>s :source $HOME/.config/nvim/init.vim<CR>

inoremap <silent> <ESC> <ESC>:<C-u>w<CR>:

