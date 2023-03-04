let $LANG = 'en_US.UTF-8'

set number
set signcolumn=yes
set expandtab
set tabstop=4
set shiftwidth=2
set autoindent
set smartindent
set list
set listchars=tab:»-,trail:-
set wildmenu
set encoding=utf-8
set fileencoding=utf-8
set fileencodings=utf-8,shift-jis
set fileformats=unix,dos,mac
set clipboard+=unnamed,unnamedplus
set wildmode=longest,full
set ruler
set cursorline
set guicursor=

noremap <Space>s :source $HOME/.config/nvim/init.vim<CR>
noremap <C-p> <Up>
noremap <C-n> <Down>
noremap <C-f> <Right>
noremap <C-b> <Left>
noremap <C-a> <Home>
noremap <C-e> <End>
noremap <C-h> <BS>
noremap <C-d> <Del>

inoremap <silent> <ESC> <ESC>:<C-u>
inoremap <silent> <C-p> <Up>
inoremap <silent> <C-n> <Down>
inoremap <silent> <C-f> <Right>
inoremap <silent> <C-b> <Left>
inoremap <silent> <C-a> <Home>
inoremap <silent> <C-e> <End>
inoremap <silent> <C-h> <BS>
inoremap <silent> <C-d> <Del>
inoremap <silent> <C-k> <ESC>:EmacsCtrlK<CR>i

command! -nargs=0 EmacsCtrlK call EmacsCtrlK()
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

