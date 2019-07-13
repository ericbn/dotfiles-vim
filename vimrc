" vim:et sts=2 sw=2
set encoding=utf-8
if has('win32')
  let s:vim_home=$USERPROFILE.'/vimfiles'
else
  let s:vim_home=$HOME.'/.vim'
endif

" To install vim-plug:
" curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
call plug#begin(s:vim_home.'/bundle')
if executable('fzf')
  Plug '/usr/local/opt/fzf' | Plug 'junegunn/fzf.vim'
endif
Plug 'ericbn/vim-solarized'
Plug 'junegunn/vim-peekaboo'
Plug 'markonm/traces.vim'
Plug 'mbbill/undotree', { 'on': 'UndotreeToggle' }
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-dispatch'
Plug 'tpope/vim-endwise'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-rhubarb'
Plug 'tpope/vim-sensible'
Plug 'tpope/vim-sleuth'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-unimpaired'
Plug 'tpope/vim-vinegar'
Plug 'wellle/targets.vim'
call plug#end()

" Backup and undo files
set backup
let &backupdir=s:vim_home.'/tmp//'
let &directory=s:vim_home.'/tmp//'
if has('persistent_undo')
  set undofile
  let &undodir=s:vim_home.'/tmp//'
endif

set colorcolumn=+1
set diffopt+=vertical " Diff mode defaults to vertical splits
set diffopt+=algorithm:histogram " Use histogram algorithm
set diffopt+=indent-heuristic " Use indent heuristics
set expandtab
set hlsearch
set ignorecase smartcase
set iskeyword+=-
set keymodel=startsel " SHIFT-<special key> starts visual selection
set list listchars=tab:»\ ,trail:·,extends:→,precedes:←
set showbreak=↪ " Show break at start of wrapped lines
if has('mouse')
  set mouse=a
endif
set pastetoggle=<F10>
set showcmd
set spelllang=en_us
set wildignore+=.DS_Store,.git,.svn,node_modules

function! RemoveTrailingSpace()
  let l:pos = getpos('.')
  %s/\s\+$//e
  call setpos('.', l:pos)
endfunction

if exists('$ITERM_PROFILE')
  " Change cursor shape between modes
  let &t_EI = "\<Esc>]50;CursorShape=0\x7" " Block in normal mode
  let &t_SI = "\<Esc>]50;CursorShape=1\x7" " Bar in insert mode
  let &t_SR = "\<Esc>]50;CursorShape=2\x7" " Underline in replace mode
endif

if executable('rg')
  set grepprg=rg\ --vimgrep
  set grepformat^=%f:%l:%c:%m
endif

augroup vimrc
  autocmd!
  " Automatically open the location/quickfix window after `:make`, `:grep`,
  " `:lvimgrep` and friends if there are valid locations/errors:
  autocmd QuickFixCmdPost [^l]* cwindow
  autocmd QuickFixCmdPost l*    lwindow
  " Automatically clean fugitive buffers
  autocmd BufReadPost fugitive://* set bufhidden=delete
augroup END

" Requires `stty -ixon -ixoff`
" inoremap <silent> <C-s> <Esc>:up<CR>
" nnoremap <silent> <C-s> :up<CR>

nnoremap Y y$

let mapleader=' '
nnoremap <leader>d :windo <C-r>=&diff ? 'diffoff' : 'diffthis'<CR><CR>
nnoremap <leader>l :lcd <C-r>=expand('%:h')<CR><CR>
nnoremap <leader>q :qall<CR>
nnoremap <leader>s :%s/<C-r>///g<Left><Left>
nnoremap <leader>u :UndotreeToggle<CR>
nnoremap <leader>w :call RemoveTrailingSpace()<CR>

" 'in document' (from first line to last; cursor at top--ie, gg)
xnoremap <silent> id :<C-u>normal! G$Vgg0<CR>
onoremap <silent> id :<C-u>normal! GVgg<CR>

if !has('gui_running')
  " Copy and paste
  if has('clipboard')
    vnoremap <C-c> "+y
    vnoremap <C-x> "+d
    vnoremap <C-v> "+p
    " inoremap <C-v> <C-r><C-o>+
  endif
endif

" Fzf
if executable('fzf')
  nnoremap <silent> <leader>f :Files<CR>
  nnoremap <silent> <leader>/ :History/<CR>
  nnoremap <silent> <leader>: :History:<CR>
  nnoremap <silent> <leader>b :Buffers<CR>
  nnoremap <silent> <leader>h :History<CR>
endif

" Netrw
let g:netrw_dirhistmax=0 " Don't write to .netrwhist
let g:netrw_liststyle=1 " Show time stamp and file size

" Solarized
set background=dark
colorscheme solarized

" Statusline
hi User1 ctermfg=14 ctermbg=0 guifg=#93a1a1 guibg=#073642
augroup statusline
  autocmd!
  autocmd TerminalOpen * setlocal statusline=%f
augroup END
