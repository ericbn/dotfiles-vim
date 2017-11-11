" vim:et sts=2 sw=2
if has('win32')
  let s:vim_home=$HOME.'/vimfiles'
else
  let s:vim_home=$HOME.'/.vim'
endif

" To install vim-plug:
" curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
call plug#begin(s:vim_home.'/bundle')
Plug '/usr/local/opt/fzf' | Plug 'junegunn/fzf.vim'
Plug 'ericbn/vim-solarized'
Plug 'mbbill/undotree', { 'on': 'UndotreeToggle' }
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-sensible'
Plug 'tpope/vim-sleuth'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-unimpaired'
Plug 'tpope/vim-vinegar'
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
set hlsearch
set expandtab
set ignorecase smartcase
set keymodel=startsel " SHIFT-<special key> starts visual selection
set list listchars=tab:»\ ,trail:·,extends:→,precedes:←
set showbreak=↪\ 
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

if !has('gui_running')
  " Copy and paste
  if has('clipboard')
    vnoremap <C-c> "+y
    vnoremap <C-x> "+d
    vnoremap <C-v> "+p
    " inoremap <C-v> <C-r><C-o>+
  endif

  " Change cursor shape between modes
  if exists('$ITERM_PROFILE')
    let &t_EI = "\<Esc>]50;CursorShape=0\x7" " Block in normal mode
    let &t_SI = "\<Esc>]50;CursorShape=1\x7" " Bar in insert mode
    let &t_SR = "\<Esc>]50;CursorShape=2\x7" " Underline in replace mode
  endif
endif

" Expand <C-x>% to the path of the active buffer on Ex command-line
" cnoremap <C-x>% <C-r>=expand('%:h').'/'<CR>

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
inoremap <silent> <C-s> <Esc>:up<CR>
nnoremap <silent> <C-s> :up<CR>
nnoremap <silent> <C-q> :qall<CR>

nnoremap Y y$

let mapleader=','
nnoremap <leader>/ :History/<CR>
nnoremap <leader>: :History:<CR>
nnoremap <leader>b :Buffers<CR>
nnoremap <leader>d :windo <C-R>=&diff ? 'diffoff' : 'diffthis'<CR><CR>
nnoremap <leader>h :History<CR>
nnoremap <leader>l :lcd <C-r>=expand('%:h')<CR><CR>
nnoremap <leader>s :%s/<C-r>///g<Left><Left>
nnoremap <leader>u :UndotreeToggle<CR>
nnoremap <leader>w :call RemoveTrailingSpace()<CR>

" Auto Pairs
let g:AutoPairsCenterLine=0

" Fzf
let g:fzf_buffers_jump=1 " [Buffers] Jump to the existing window if possible
nnoremap <silent> <C-t> :Files<CR>

" Netrw
let g:netrw_dirhistmax=0 " Don't write to .netrwhist

" Solarized
set background=dark
colorscheme solarized

" Statusline
set statusline=
" set statusline+=%(%{&filetype!='help'?bufnr('%'):''}\ \ %)
set statusline+=%< " Where to truncate line
set statusline+=%f\  " Path to the file in the buffer, as typed or relative to current directory
set statusline+=%{&modified?'+\ ':''}
set statusline+=%{&readonly?'\ ':''}
set statusline+=%1*\  " Set highlight group to User1
set statusline+=%{fugitive#statusline('','\ ')}
set statusline+=%= " Separation point between left and right aligned items
set statusline+=\ %{&filetype!=#''?&filetype:'none'}
set statusline+=%(\ %{(&bomb\|\|&fileencoding!~#'^$\\\|utf-8'?'\ '.&fileencoding.(&bomb?'-bom':''):'')
  \.(&fileformat!=#'unix'?'\ '.&fileformat:'')}%)
set statusline+=%(\ \ %{&modifiable?SleuthIndicator():''}%)
set statusline+=\ %* " Restore normal highlight
set statusline+=\ %{&number?'':printf('%2d,',line('.'))} " Line number
set statusline+=%-2v " Virtual column number
set statusline+=\ %2p%% " Percentage through file in lines as in |CTRL-G|
hi User1 ctermfg=14 ctermbg=0 guifg=#93a1a1 guibg=#073642
