
"keymaps for manage the file"
nmap <Leader>q :q<CR>
nmap <Leader>w :w<CR>
nmap <Leader>vv :put<CR> 
nmap <Leader>wq :wq<CR>
nmap <Leader>t :t.<CR>
nmap<leader>sal :%y <CR>
map<A-w> :><CR>
map<A-q> :<<CR>

"move current line to up or down"
nnoremap <S-Down> :move+<CR>
nnoremap <S-Up> :move-2<CR>

xnoremap <C-Down> xp`[V`]
xnoremap <C-Up> xkP`[V`]
"Reload File vimrc"
nmap <Leader>so :source ~/_vimrc<CR>
nmap <silent><leader>s "=nr2char(getchar())<cr>P
nnoremap gu <<Esc>
nnoremap gi ><Esc>



noremap <leader>lca :Lspsaga code_action<cr>
nnoremap <leader>lcr :Lspsaga range_code_action<cr>
nnoremap <leader>lre :Lspsaga rename<cr>
nnoremap <leader>ldf :Lspsaga preview_definition<cr>
nnoremap <leader>lsd :Lspsaga show_line_diagnostics<cr>
" nnoremap <leader>ter :Lspsaga open_floaterm<cr>
" tnoremap <leader>ct :Lspsaga close_floaterm<cr>
nnoremap <leader>lsp :Lspsaga open_floaterm<cr>
tnoremap <leader>csp :Lspsaga close_floaterm<cr>


"keymap for nerdtree"
nnoremap<leader>nt :NERDTree<CR>


nmap <Leader>tb :TagbarOpen<CR>


" ======= KEYMAP FOR DEBUG ======== 
autocmd Filetype java set makeprg=javac\ %
set errorformat=%A%f:%l:\ %m,%-Z%p^,%-C%.%#
map <F9> :make<Return>:copen<Return>
map <F10> :cprevious<Return>
map <F11> :cnext<Return>
map <Leader>rn :!node %<CR>
map <Leader>rj :!java -cp "%:p:h" "%:t:r"<CR>
map <Leader>so :source %<CR>
map <Leader>rc :Lspsaga open_floaterm ./compile.sh<CR>
map <Leader>rp :Lspsaga open_floaterm ./compile.sh<CR>
" autocmd filetype cpp nnoremap <Leader>rc :!g++ -std=c++11 %:p -o %:p:r :Lspsaga open_floaterm ./%:p:r<CR>


"autocomplete
inoremap ( ()<Esc>i
inoremap { {}<Esc>i
inoremap [ []<Esc>i
inoremap ' ''<Esc>i
inoremap " ""<Esc>i
