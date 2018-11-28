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
"vim中表示当前目录和当前文件名的方法
"% 当前完整的文件名
"%:h 文件名的头部，即文件目录.例如../path/test.c就会为../path
"%:t 文件名的尾部.例如../path/test.c就会为test.c
"%:r 无扩展名的文件名.例如../path/test就会成为test
"%:e 扩展名


"F7一键编译程序
"通过makefile以及make命令
"nmap <F7> :call DoOneFileMake()<CR>
"function DoOneFileMake()
"if(expand("%:p:h")!=getcwd())
"echohl WarningMsg | echo "Fail to make! This file is not in the current dir! Press redirect to the dir of this file."
"endif
"exec "w"
"call SetCompilation()
"exec "make"
"exec "copen"
"endfunction
"function SetCompilation()
"if &filetype=='c'
"set makeprg=gcc\ %\ -o\ %<
"elseif &filetype=='cpp'
"set makeprg=g++ \ %\ -o\ %< 
"endif
"endfunction

"第1行:表示映射快捷键F7,即按F4则调用这个一键编译的函数.
"第3-5行:判断这个文件是否在当前文件夹.
"第7行:相当于执行命令w
"第8行:调用函数SetCompilation(),用来设置编译器或者说设定编译命令.
"第9行:执行make命令
"第10行:打开quickfix窗口,用于显示编译产生的错误.
"第13-19行:根据不同的文件类型,来配置makeprg,也就是make命令调用的编译器或编译命令.
"第14行:判断当前的文件类型是否是C 程序.
"第15行:设定make命令所调用的编译命令.
"说明:这样来设定的好处就是编译产生的错误可以直接在\quickfix窗口中显示出来.
"第16-17行,分析同14-15行.

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
call vundle#end() " required
filetype plugin indent on " required
"+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
