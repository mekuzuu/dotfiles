call plug#begin('~/.vim/plugged')

Plug 'prabirshrestha/asyncomplete.vim'
Plug 'prabirshrestha/asyncomplete-lsp.vim'
Plug 'prabirshrestha/vim-lsp'
Plug 'mattn/vim-lsp-settings'
Plug 'mattn/vim-lsp-icons'
Plug 'hrsh7th/vim-vsnip'
Plug 'hrsh7th/vim-vsnip-integ'
Plug 'scrooloose/nerdtree', { 'on':  'NERDTreeToggle' }
Plug 'xuyuanp/nerdtree-git-plugin', { 'on': 'NERDTreeToggle' }
Plug 'thinca/vim-quickrun', {'on': 'QuickRun'}
Plug 'junegunn/fzf.vim'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'tpope/vim-surround'
Plug 'bling/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'dense-analysis/ale'
Plug 'skanehira/preview-markdown.vim'
Plug 'wfxr/minimap.vim'
Plug 'airblade/vim-gitgutter' 
Plug 'tpope/vim-fugitive'
Plug 'simeji/winresizer'
Plug 'liuchengxu/vista.vim'
Plug 'itchyny/lightline.vim'
Plug 'mattn/vim-goimports'
Plug 'rust-lang/rust.vim'


call plug#end()

set fileencodings=utf-8,euc-jp,sjis,cp932,iso-2022-jp
set fileformats=unix,dos,mac
set number
set cursorline
set hlsearch
set incsearch
set smartindent
set clipboard+=unnamed
set wildmenu
set splitright
set list
set listchars=tab:»-,trail:-,eol:↲,extends:»,precedes:«,nbsp:%
set mouse=a
syntax enable

" Git
set updatetime=100
highlight clear SignColumn

" Parenthesis Completion
"inoremap { {}<LEFT>
"inoremap [ []<LEFT>
"inoremap ( ()<LEFT>
"inoremap " ""<LEFT>
"inoremap ' ''<LEFT>

"Rust
let g:rustfmt_autosave = 1

" LSP
if executable('rls')
    au User lsp_setup call lsp#register_server({
        \ 'name': 'rls',
        \ 'cmd': {server_info->['rustup', 'run', 'stable', 'rls']},
        \ 'workspace_config': {'rust': {'clippy_preference': 'on'}},
        \ 'whitelist': ['rust'],
        \ })
endif

if empty(globpath(&rtp, 'autoload/lsp.vim'))
  finish
endif

function! s:on_lsp_buffer_enabled() abort
    setlocal omnifunc=lsp#complete
    setlocal signcolumn=no
    if exists('+tagfunc') | setlocal tagfunc=lsp#tagfunc | endif
    nmap <buffer> gd <plug>(lsp-definition)
    nmap <buffer> gs <plug>(lsp-document-symbol-search)
    nmap <buffer> gS <plug>(lsp-workspace-symbol-search)
    nmap <buffer> gr <plug>(lsp-references)
    nmap <buffer> gi <plug>(lsp-implementation)
    nmap <buffer> gt <plug>(lsp-type-definition)
    nmap <buffer> <leader>rn <plug>(lsp-rename)
    nmap <buffer> [g <plug>(lsp-previous-diagnostic)
    nmap <buffer> ]g <plug>(lsp-next-diagnostic)
    nmap <buffer> K <plug>(lsp-hover)
    nnoremap <buffer> <expr><c-f> lsp#scroll(+4)
    nnoremap <buffer> <expr><c-d> lsp#scroll(-4)

    let g:lsp_diagnostics_enabled = 0
    let g:lsp_diagnostics_signs_enabled = 0
    let g:lsp_document_highlight_enabled = 0
    let g:lsp_document_code_action_signs_enabled = 0

    let g:lsp_format_sync_timeout = 1000
    autocmd! BufWritePre *.rs,*.go call execute('LspDocumentFormatSync')

endfunction

augroup lsp_install
  au!
  autocmd User lsp_buffer_enabled call s:on_lsp_buffer_enabled()
augroup END
command! LspDebug let lsp_log_verbose=1 | let lsp_log_file = expand('~/lsp.log')

let g:lsp_diagnostics_enabled = 1
let g:lsp_diagnostics_echo_cursor = 1
let g:asyncomplete_auto_popup = 1
let g:asyncomplete_auto_completeopt = 1
let g:asyncomplete_popup_delay = 200
let g:lsp_text_edit_enabled = 1

"Vim QuickRun
set splitbelow
nnoremap <silent> <C-r> :QuickRun<CR>

"NERDTree
nnoremap <silent> <C-t> :NERDTreeToggle<CR>

" ALE(Asynchronous Lint Engine)
let g:ale_signs_error = '☠'
let g:ale_sign_warning = '⚠'
" エラー行にカーソルをあわせた際に表示されるメッセージフォーマット
let g:ale_echo_msg_format = '[%linter%] %s [%severity%]'
" エラー表示の列を常時表示
let g:ale_sign_column_always = 1
" ファイルを開いたときにlint実行
let g:ale_lint_on_enter = 1
" ファイルを保存したときにlint実行
let g:ale_lint_on_save = 1
" 変更がある度に更新されるとチカチカするのでOFF
let g:ale_lint_on_text_changed = 'never'
" ロケーションリストの代わりにQuickFix
let g:ale_set_loclist = 0
let g:ale_set_quickfix = 1
" エラーと警告の一覧を見るためにウィンドウを開いておきた
let g:ale_open_list = 1
let g:ale_keep_list_window_open = 0
" ウィンドウサイズ
let g:ale_list_window_size = 5
" C-jで次のエラー、C-kで前のエラーに移動
nmap <silent> <C-k> <Plug>(ale_previous_wrap)
nmap <silent> <C-j> <Plug>(ale_next_wrap)

let g:ale_linters = {'rust': ['analyzer']}

" MarkdownPreview
let g:preview_markdown_parser = 'glow'
let g:preview_markdown_vertical = 1
let g:preview_markdown_auto_update = 1

" AutoComplete
highlight Pmenu ctermfg=white ctermbg=black
highlight PmenuSel ctermfg=white ctermbg=gray

" Vista
let g:vista_default_executive = 'vim_lsp'
function! NearestMethodOrFunction() abort
  return get(b:, 'vista_nearest_method_or_function', '')
endfunction
set statusline+=%{NearestMethodOrFunction()}
map <C-m> :Vista <CR>

" MiniMap
let g:minimap_width = 10
let g:minimap_auto_start = 1
let g:minimap_auto_start_win_enter = 1
let g:minimap_git_colors = 1
let g:minimap_highlight_search = 1

" FZF
let g:fzf_action = {
  \ 'ctrl-t': 'tab split',
  \ 'ctrl-s': 'split',
  \ 'ctrl-v': 'vsplit' }

:nnoremap <Leader>f :FZF<CR>

" Ripgrep
:nnoremap <Leader>r :Rg

" Airline
let g:airline_theme = 'deus'
let g:airline_deus_bg = 'dark'
let g:airline_powerline_fonts = 1
let g:airline#extensions#branch#enabled = 1
let g:airline#extensions#tabline#enabled = 1
nmap <C-p> <Plug>AirlineSelectPrevTab
nmap <C-n> <Plug>AirlineSelectNextTab

