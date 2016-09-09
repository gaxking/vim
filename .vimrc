" Vundle
set nocompatible             " not compatible with the old-fashion vi mode
filetype off                 " required!

" http://www.erikzaadi.com/2012/03/19/auto-installing-vundle-from-your-vimrc/
" Setting up Vundle - the vim plugin bundler
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

" let Vundle manage Vundle
" required!
Bundle 'gmarik/vundle'

" My Bundles here:
"
" original repos on github
Bundle 'honza/vim-snippets'
Bundle 'marijnh/tern_for_vim'
Bundle 'scrooloose/nerdtree'
Bundle 'tomasr/molokai'
Bundle 'jiangmiao/auto-pairs'
Bundle 'mattn/emmet-vim'
"ctrl-p 搜索文件
Bundle 'kien/ctrlp.vim'
Bundle 'Mark'
Bundle 'terryma/vim-multiple-cursors'
Bundle 'Shutnik/jshint2.vim'
Bundle 'pangloss/vim-javascript'
Bundle 'scrooloose/syntastic'

"Bundle 'wookiehangover/jshint.vim'
"Bundle 'xolox/vim-session'
if has('gui_running')
	Bundle 'Valloric/YouCompleteMe'
endif
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
"如果打开的文件除了NERDTree没有其他文件时，它自动关闭
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTreeType") &&b:NERDTreeType == "primary") | q | endif

colorscheme molokai
let g:molokai_original = 1
let g:rehash256 = 1

"保存后自动加载vimrc
autocmd! bufwritepost _vimrc source $MYVIMRC

" 不产生swp
"set noswapfile
set directory=/tmp
set backupdir=/tmp

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
"let g:syntastic_javascript_checkers = ['standard']
"let g:syntastic_javascript_standard_generic = 1
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

let g:svn_public = 0
function! SVNSWITCH()
    let path = split(expand("%:p"), '/')
    let Pathindex = index(path, 'web')
    call remove(path, 0, Pathindex)

    if g:svn_public == 0
        echo '正式branch'
        execute "! svn sw svn://120.25.104.207/web_20150928/". join(path, '/') ." /Users/gax/work/htdocs/zfw_new/web/" . join(path, '/'). " --ignore-ancestry"
        let g:svn_public = 1
    else
        echo '测试branch'
        execute "! svn sw svn://120.25.104.207/web/". join(path, '/') ." /Users/gax/work/htdocs/zfw_new/web/" . join(path, '/'). " --ignore-ancestry"

        let g:svn_public = 0
    endif
endf

function! SVNCIPUBLIC()
    let path = split(expand("%:p"), '/')
    let Pathindex = index(path, 'web')
    call remove(path, 0, Pathindex)

    let isWap = stridx(expand("%:p"), 'zfw_new/web/Public/wap')
    if isWap > 0
        "echo '正式branch'
        "let Pathindex = index(path, 'wap')
        "call remove(path, 0, Pathindex)

        "execute "! svn up /Users/gax/work/htdocs/zfw_public/web/Public/wap"
        "execute "! rm -r /Users/gax/work/htdocs/zfw_public/web/Public/wap/dist"
        "execute "! cp -r /Users/gax/work/htdocs/zfw_new/web/Public/wap/dist /Users/gax/work/htdocs/zfw_public/web/Public/wap"
        "execute "! svn ci -m \"\" /Users/gax/work/htdocs/zfw_public/web/Public/wap/dist"
    else
        echo '正式branch'
        execute "! svn up /Users/gax/work/htdocs/zfw_public/web/" . join(path, '/')
        execute "! cp /Users/gax/work/htdocs/zfw_new/web/" . join(path, '/') ." /Users/gax/work/htdocs/zfw_public/web/" . join(path, '/')
        execute "! svn ci -m \"\" /Users/gax/work/htdocs/zfw_public/web/" . join(path, '/')
    endif
endf

function! SVNADDPUBLIC()
    let path = split(expand("%:p"), '/')
    let Pathindex = index(path, 'web')
    call remove(path, 0, Pathindex)

    echo '正式branch Add'
    execute "! cp /Users/gax/work/htdocs/zfw_new/web/" . join(path, '/') ." /Users/gax/work/htdocs/zfw_public/web/" . join(path, '/')
    execute "! svn add /Users/gax/work/htdocs/zfw_public/web/" . join(path, '/')
endf

function! VSPLITEPUBLIC()
    let path = split(expand("%:p"), '/')
    let Pathindex = index(path, 'web')
    call remove(path, 0, Pathindex)

    echo '正式branch Public'
    execute "vsplit /Users/gax/work/htdocs/zfw_public/web/" . join(path, '/')
endf

function! PX2REM()
    let cword = (expand("<cword>") + 0 ) /200.0
    let rem = string(cword) . 'rem'
    echo rem
    execute "normal! bdwi".rem 
endf

function! COPYIMG2PUBLIC()

    let path = split(expand("%:p"), '/')
    let Pathindex = index(path, 'web')
    call remove(path, 0, Pathindex)
    call remove(path, len(path)-1, len(path)-1)

    echo '正式branch'
    echo join(path, '/')

    let testPath = "/Users/gax/work/htdocs/zfw_new/web/" . join(path, '/') 
    let publicPath = "/Users/gax/work/htdocs/zfw_public/web/" . join(path, '/') 

    execute "! rm -rf " . publicPath . "/*"
    execute "! cp -rf " . testPath . "/* " . publicPath
    execute "! svn st " . publicPath . "| awk '{if ( $1 == \"!\") { print $2}}' | xargs svn rm "
    execute "! svn st " . publicPath . "| awk '{if ( $1 == \"?\") { print $2}}' | xargs svn add "
    execute "! svn ci -m \"\" " . publicPath
endf

function! BALEL()
    execute "w!"
    execute "cd /Users/gax/work/htdocs/zfw_new/web/Public/wap"
    execute "! npm run build"
    execute "! svn ci -m \"\" /Users/gax/work/htdocs/zfw_new/web/Public/wap/js/main.js "
endf
