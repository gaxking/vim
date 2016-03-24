" Vundle
set nocompatible
filetype off 

let iCanHazVundle=1
let vundle_readme=expand('~/.vim/bundle/vundle/README.md')
if !filereadable(vundle_readme)
  echo "Installing Vundle.."
  echo ""
  silent !mkdir -p ~/.vim/bundle
  silent !git clone https://github.com/gmarik/vundle ~/.vim/bundle/vundle
  let iCanHazVundle=0
endif

set rtp+=~/.vim/bundle/vundle/
call vundle#rc()

Bundle 'gmarik/vundle'
"模版文件
Bundle 'honza/vim-snippets'
"js 自动补全
Bundle 'marijnh/tern_for_vim'
"目录树
Bundle 'scrooloose/nerdtree'
"主题
Bundle 'tomasr/molokai'
"自动打对称的符号
Bundle 'jiangmiao/auto-pairs'
"快速写html，css 前生是zendcoding
Bundle 'mattn/emmet-vim'
"ctrl-p 搜索文件
Bundle 'kien/ctrlp.vim'
"jslint 语法检查，配置简单，目前弃用
"Bundle 'Shutnik/jshint2.vim'
"javasript语法缩进配置
Bundle 'pangloss/vim-javascript'
"语法检查器,可检查多种语言
Bundle 'scrooloose/syntastic'
"自动补全插件
if has('gui_running')
	Bundle 'Valloric/YouCompleteMe'
endif
"html缩进
Bundle 'vim-scripts/indenthtml.vim'

" YCM
let g:ycm_global_ycm_extra_conf = '~/.vim/.ycm_extra_conf.py'

" 保留历史记录
set history=500

" 行控制
"set linebreak
"set nocompatible
"set textwidth=80
"set wrap

filetype indent on
set filetype=html
set smartindent
let g:html_indent_inctags = 'html,body,head,tbody'

" html格式化
filetype plugin indent on

" 制表符
set tabstop=4
set smarttab
set shiftwidth=4
set softtabstop=4
set autoindent
set smartindent

" 标签页
set tabpagemax=9
set showtabline=2

" 行号和标尺
set number
set ruler
set rulerformat=%15(%c%V\ %p%%%)

" NERDTree
nmap <C-d> :NERDTreeToggle<cr>

colorscheme molokai
let g:molokai_original = 1
let g:rehash256 = 1

"保持后自动加载vimrc
autocmd! bufwritepost _vimrc source $MYVIMRC
"
" 不产生swp
set noswapfile

"保存时弹出语法检查
"let jshint2_save = 1

"syntastic 语法检查
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 0
let g:syntastic_check_on_wq = 1
let g:syntastic_javascript_checkers = ['eslint']
let g:syntastic_javascript_eslint_exec = 'eslint'
let g:syntastic_mode_map = {"mode": "active", "active_filetypes": [""],"passive_filetypes": ["html"] }

"svn 上传快捷键
map <C-s> :call SVNCI()<CR>
map <C-w> :call SVNCIPUBLIC()<CR>

function! SVNCI()
    execute "w!"
    execute "! svn ci -m \"\" %"
endf

function! SVNADD()
    "execute "! svn st | awk '{if ( $1 == \"?\") { print $2}}' | xargs svn add"
    let path = split(expand("%:p"), '/')
    let len = len(split(expand("%:p"), '/')) - 2
    let pathPre = "/".join(path[0:len], '/')
    let name = path[-1]

    execute "! cd ". pathPre ." && svn add ". name
endf

function! SVNREVERT()
    execute "! svn revert ".expand("%:p")
endf

function! SVNUP()
    execute "! svn up ".expand("%:p")
endf

function! PX2REM()
    let cword = (expand("<cword>") + 0 ) /200.0
    let rem = string(cword) . 'rem'
    echo rem
    execute "normal! bdwi".rem 
endf
