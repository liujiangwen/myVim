"colorscheme jhdark_modified
set number	"显示行号
set tabstop=4	"设置tab制表符为四个空格
set shiftwidth=4	"设置缩进的空格数为4
set autoindent	"自动将当前行的缩进拷贝到新行，若在新行没有输入，那么这个缩进将自动删除
set cindent		"使用c/c++语言的自动缩进方式

"括号自动补全
inoremap ( ()<LEFT>
inoremap [ []<LEFT>
inoremap { {}<LEFT>
imap {<CR> {<CR>}<ESC>O
"inoremap { {}<ESC>lx<ESC>a
inoremap ' ''<ESC>i
"如果在自动补全后，又输入了一次右括号，我们需要的是忽略这个多余的右括号，将光标移动到右括号后面即可
"输入一个字符时，如果下一个字符也是括号，则删除它，避免出现重复字符
"代码如下
function! RemoveNextDoubleChar(char)
	let l:line = getline(".")
	let l:next_char = l:line[col(".")] " 取得当前光标后一个字符
	if a:char == l:next_char
		execute "normal! l"
	else
		execute "normal! a" . a:char . ""
	end
endfunction
"使用上面定义的函数
inoremap ) <ESC>:call RemoveNextDoubleChar(')')<CR>a
inoremap ] <ESC>:call RemoveNextDoubleChar(']')<CR>a
inoremap } <ESC>:call RemoveNextDoubleChar('}')<CR>a

"使用TAB跳出括号
func SkipPair()
	if getline('.')[col('.')- 1] == ')' ||  getline('.')[col('.')- 1] == ']' ||  getline('.')[col('.')- 1] == '"' ||  getline('.')[col('.')- 1] == "'" ||  getline('.')[col('.')- 1] == '}' 
		return "\<ESC>la"
	else
		return "\t"
	endif
endfunc
inoremap <TAB> <c-r>=SkipPair()<CR>
"+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
"为了使得vim的剪切板能够与外界的剪切板相互沟通，需要安装vim-gnome
"sudo apt-get install vim-gnome
"同时为了方便起见，使用了ctrl-c，ctrl-v快捷键
"虽然ctrl-v本来是用于块状选择的，但是我基本上用不着，所以就覆盖掉它
"原理 https://blog.csdn.net/sodawaterer/article/details/61918370
"参考 http://www.cnblogs.com/Ph-one/p/5620894.html
"CTRL-X is cut
vnoremap <C-X> "+x
"CTRL-C is copy
vnoremap <C-C> "+y
"CTRL-V is paste
map <C-V> "+gp
"set paste "设置粘贴模式状态，此时粘贴的内容可以保持原有的格式不变

"+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
map <F5> :call CompileRunGcc()<CR>
func! CompileRunGcc()
	exec "w"
	if &filetype == 'c'
		exec "!g++ % -o %<"
		exec "!./%<"
	elseif &filetype == 'cpp'
		exec "!g++ % -o %<"
		exec "!./%<"
	elseif &filetype == 'java'
		exec "!javac %"
		exec "!java %<"
	endif
endfunc
"vim中表示当前目录和当前文件名的方法
"% 当前完整的文件名
"%:h 文件名的头部，即文件目录.例如../path/test.c就会为../path
"%:t 文件名的尾部.例如../path/test.c就会为test.c
"%:r 无扩展名的文件名.例如../path/test就会成为test
"%:e 扩展名

"+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
"vundle下载方法     git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
"vundle插件相关配置
set nocompatible " be iMproved, required
filetype off " required
" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
"alternatively, pass a path where Vundle should install plugins
"call vundle#begin('~/some/path/here')
"let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'
"Define bundles via Github repos
"https://github.com/scrooloose/nerdtree
Bundle 'scrooloose/nerdtree'
Bundle 'majutsushi/tagbar'
Bundle 'vim-scripts/gdbmgr'
Bundle 'bling/vim-bufferline'
call vundle#end() " required
filetype plugin indent on " required

"tagbar
"F2触发，设置宽度为30 
let g:tagbar_width = 30 
nmap <F3> :TagbarToggle<CR> 
"开启自动预览(随着光标在标签上的移动，顶部会出现一个实时的预览窗口)
let g:tagbar_autopreview = 1
"关闭排序,即按标签本身在文件中的位置排序 
let g:tagbar_sort = 0

"nerdTree
nmap <F2> :NERDTreeToggle<CR>
"窗口大小
let g:NERDTreewinSize=30
"显示隐藏文件
let g:NERDTreeShowHidden=1

"set list lcs=tab:\┆\ 
