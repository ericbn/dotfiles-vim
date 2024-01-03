" vim:et sts=2 sw=2
if &compatible
  set nocompatible
endif

" To install minpac
" git clone https://github.com/k-takata/minpac.git ~/.vim/pack/minpac/opt/minpac
packadd minpac
call minpac#init()
call minpac#add('k-takata/minpac', {'type': 'opt'})
if executable('fzf')
  set runtimepath+=/usr/local/opt/fzf
  call minpac#add('junegunn/fzf.vim')
endif
call minpac#add('bfrg/vim-jqplay') " Run jq interactively in Vim
call minpac#add('ericbn/vim-solarized')
call minpac#add('majutsushi/tagbar') " Vim plugin that displays tags in a window, ordered by scope
call minpac#add('markonm/traces.vim') " Range, pattern and substitute preview for Vim
call minpac#add('mbbill/undotree') "The undo history visualizer for VIM
call minpac#add('raimon49/requirements.txt.vim') " Requirements File Format syntax support for Vim
call minpac#add('ralismark/opsort.vim') " Custom operator that sorts lines
call minpac#add('tpope/vim-abolish') " Work with several variants of a word at once
call minpac#add('tpope/vim-commentary') " Comment stuff out
call minpac#add('tpope/vim-dispatch') " Asynchronous build and test dispatcher
call minpac#add('tpope/vim-endwise') " Wisely add endfunction/endif/more in vim script, etc
call minpac#add('tpope/vim-fugitive') " A Git wrapper so awesome, it should be illegal
call minpac#add('tpope/vim-repeat') " Enable repeating supported plugin maps with `.`
call minpac#add('tpope/vim-rhubarb') " GitHub extension for fugitive.vim
call minpac#add('tpope/vim-sensible') " Defaults everyone can agree on
call minpac#add('tpope/vim-sleuth') " Heuristically set buffer options
call minpac#add('tpope/vim-surround') " Quoting/parenthesizing made simple
call minpac#add('tpope/vim-unimpaired') " Pairs of handy bracket mappings
call minpac#add('tpope/vim-vinegar') " Combine with netrw to create a delicious salad dressing
call minpac#add('triglav/vim-visual-increment') "  Increase sequence of numbers or letters via visual mode
call minpac#add('wellle/targets.vim') " Vim plugin that provides additional text objects

" Backup and undo files
if has('win32')
  let s:vim_home=$USERPROFILE.'/vimfiles'
else
  let s:vim_home=$HOME.'/.vim'
endif
set backup
let &backupdir=s:vim_home.'/tmp//'
let &directory=s:vim_home.'/tmp//'
if has('persistent_undo')
  set undofile
  let &undodir=s:vim_home.'/tmp//'
endif

set colorcolumn=+1
set diffopt+=vertical " Diff mode defaults to vertical splits
if has('nvim-0.3.2') || has('patch-8.1.0360')
  set diffopt+=algorithm:histogram " Use histogram algorithm
  set diffopt+=indent-heuristic " Use indent heuristics
endif
set expandtab " Indent with spaces
set virtualedit=block " Allow virtual editing in Visual block mode
set hlsearch " Highlight all search matches
set ignorecase smartcase
set iskeyword+=-
set keymodel=startsel " SHIFT-<special key> starts visual selection
set list listchars=tab:»\ ,trail:·,extends:→,precedes:←
set showbreak=↪ " Show break at start of wrapped lines
set pastetoggle=<F10>
set showcmd " Show (partial) command in the last line.
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

nnoremap Y y$
" Don't use Ex mode, use Q for formatting.
nnoremap Q gq

" See https://www.reddit.com/r/neovim/comments/sf0hmc/im_really_proud_of_this_mapping_i_came_up_with/
nnoremap g. /\V<C-r>"<CR>cgn<C-a><Esc>

let mapleader=' '
nnoremap <leader>d :windo <C-r>=&diff ? 'diffoff' : 'diffthis'<CR><CR>
nnoremap <leader>jj :set ft=json<CR>gg=G
nnoremap <leader>jc :%!python3 -c 'import json, sys; print(json.dumps(json.loads(sys.stdin.read()), separators=(",", ":")))'<CR>:set ft=json<CR>
nnoremap <leader>jp :%!python3 -c 'import json, sys; print(json.loads(sys.stdin.read()))' \| black -q -<CR>:set ft=python<CR>
nnoremap <leader>jy :%!ruby -rjson -ryaml -e 'print YAML.dump(JSON.load(ARGF.read()))'<CR>:set ft=yaml<CR>
nnoremap <leader>pj :%!python3 -c 'import ast, json, sys; print(json.dumps(ast.literal_eval(sys.stdin.read()), indent=2))'<CR>:set ft=json<CR>
nnoremap <leader>pp :%!python3 -c 'import ast, sys; print(ast.literal_eval(sys.stdin.read()))' \| black -q -<CR>:set ft=python<CR>
nnoremap <leader>yj :%!ruby -rjson -rjson -ryaml -e 'print(JSON.pretty_generate(YAML.load(ARGF.read())))'<CR>:set ft=json<CR>
nnoremap <leader>l :lcd <C-r>=expand('%:h')<CR><CR>
nnoremap <leader>q :qall<CR>
nnoremap <leader>s :%s///g<Left><Left>
nnoremap <leader>t :TagbarToggle<CR>
nnoremap <leader>u :UndotreeToggle<CR>
nnoremap <leader>w :call RemoveTrailingSpace()<CR>
nnoremap <leader>yf :let @*=expand("%:p")<CR>
nnoremap <leader>yl :let @*=line(".")<CR>

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

" Make search results appear in the middle of the screen
nnoremap n nzz
nnoremap N Nzz
nnoremap * *zz
nnoremap # #zz
nnoremap g* g*zz
nnoremap g# g#zz

" Colorscheme
set background=dark
colorscheme solarized

augroup vimrc
  autocmd!
  " Statusline
  autocmd ColorScheme solarized highlight User1 ctermfg=14 ctermbg=0 guifg=#93a1a1 guibg=#073642
  " Automatically open the location/quickfix window after `:make`, `:grep`,
  " `:lvimgrep` and friends if there are valid locations/errors:
  autocmd QuickFixCmdPost [^l]* cwindow
  autocmd QuickFixCmdPost l*    lwindow
  " Automatically clean fugitive buffers
  autocmd BufReadPost fugitive://* set bufhidden=delete
augroup END
