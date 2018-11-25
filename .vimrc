set number	"显示行号
set tabstop=4	"设置tab制表符为四个空格
set shiftwidth=4	"设置缩进的空格数为4
set autoindent	"自动将当前行的缩进拷贝到新行，若在新行没有输入，那么这个缩进将自动删除
set cindent		"使用c/c++语言的自动缩进方式

"括号的有关操作以及其实现原理
"括号匹配 使用inoremap命令实现括号匹配
"inoremap命令用于映射按键,i代表是在插入模式(insert)下有效,nore表示不递归no recursion,例如inoremap Y y和inoremap y Y不会出现无线循环,map映射
inoremap ( ()<LEFT>
inoremap [ []<LEFT>
inoremap { {<CR>}<ESC>kA<CR>
inoremap " ""<LEFT>
"当在insert模式下按下{键时，替换成{<CR>}<ESC>kA<CR>，即{，回车，}，退出insert模式，k向上移动光标，A跳转到行末进入insert模式，回车
 
"以上四个操作原理：将左括号的键映射为一个新的操作，在输入左括号时，让vim立即输入右括号，同时将光标左移一格到括号中间
"如果在自动补全后，又输入了一次右括号，我们需要的是忽略这个多余的右括号，将光标移动到右括号后面即可
"输入一个字符时，如果下一个字符也是括号，则删除它，避免出现重复字符
"代码如下
function! RemoveNextDoubleChar(char)
	let l:line = getline(".")
	let l:next_char = l:line[col(".")] " 取得当前光标后一个字符
	if a:char == l:next_char
		execute "normal! l"
	else
		execute "normal! i" . a:char . ""
	end
endfunction
"使用上面定义的函数
inoremap ) <ESC>:call RemoveNextDoubleChar(')')<CR>a
inoremap ] <ESC>:call RemoveNextDoubleChar(']')<CR>a
inoremap } <ESC>:call RemoveNextDoubleChar('}')<CR>a

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
map <F5> :call CompileRunGcc()<CR>
func! CompileRunGcc()
	exec "w"
	if &filetype == 'c'
		exec "!g++ % -o %<"
		exec "!time ./%<"
	elseif &filetype == 'cpp'
		exec "!g++ % -o %<"
		exec "!time ./%<"
	elseif &filetype == 'java'
		exec "!javac %"
		exec "!time java %<"
	elseif &filetype == 'sh'
		:!time bash %
	elseif &filetype == 'python'
		exec "!time python2.7 %"
    elseif &filetype == 'html'
        exec "!firefox % &"
    elseif &filetype == 'go'
        exec "!go build %<"
        exec "!time go run %"
    elseif &filetype == 'mkd'
        exec "!~/.vim/markdown.pl % > %.html &"
        exec "!firefox %.html &"
	endif
endfunc


"+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
"vundle下载方法     git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
"vundle插件相关配置
set nocompatible " be iMproved, required
filetype off " required
" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
" alternatively, pass a path where Vundle should install plugins
"call vundle#begin('~/some/path/here')
" let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'
" The following are examples of different formats supported.
" Keep Plugin commands between vundle#begin/end.
" plugin on GitHub repo
""Plugin 'tpope/vim-fugitive'
" plugin from http://vim-scripts.org/vim/scripts.html
" Plugin 'L9'
" Git plugin not hosted on GitHub
""Plugin 'git://git.wincent.com/command-t.git'
" git repos on your local machine (i.e. when working on your own plugin)
""Plugin 'file:///home/gmarik/path/to/plugin'
" The sparkup vim script is in a subdirectory of this repo called vim.
" Pass the path to set the runtimepath properly.
""Plugin 'rstacruz/sparkup', {'rtp': 'vim/'}
" Install L9 and avoid a Naming conflict if you've already installed a
" different version somewhere else.
" Plugin 'ascenator/L9', {'name': 'newL9'}
" All of your Plugins must be added before the following line
call vundle#end() " required
filetype plugin indent on " required
" To ignore plugin indent changes, instead use:
"filetype plugin on
"
" Brief help
" :PluginList - lists configured plugins
" :PluginInstall - installs plugins; append `!` to update or just :PluginUpdate
" :PluginSearch foo - searches for foo; append `!` to refresh local cache
" :PluginClean - confirms removal of unused plugins; append `!` to auto-approve removal
"
" see :h vundle for more details or wiki for FAQ
" Put your non-Plugin stuff after this line
"+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

