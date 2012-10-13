" << FROM PANGU - BEGIN - >>
set nocompatible		" This must be first, because it changes other options as a side effect.
set backspace=indent,eol,start	" allow backspacing over everything in insert mode
map Q gq			" Don't use Ex mode, use Q for formatting
if &t_Co > 2 || has("gui_running")
  syntax on
  set hlsearch
endif
if has("autocmd")
  filetype plugin indent on
  augroup vimrcEx
  au!
  autocmd FileType text setlocal textwidth=78
  autocmd BufReadPost *
    \ if line("'\"") > 0 && line("'\"") <= line("$") |
    \   exe "normal g`\"" |
    \ endif
  augroup END
else
  set autoindent		" always set autoindenting on
endif " has("autocmd")
au BufRead,BufNewFile *.txt setlocal ft=txt
hi StatusLine    ctermfg=Magenta ctermbg=Yellow
hi StatusLineNC term=reverse ctermfg=Gray ctermbg=Black
hi TabLine ctermfg=Blue ctermbg=Gray
hi TabLineSel ctermfg=Black ctermbg=DarkCyan
hi TabLineFill ctermfg=Gray ctermbg=Black
hi LineNr ctermfg=darkgray
set <F1>=[11;*~
set <F2>=[12;*~
set <F3>=[13;*~
set <F4>=[14;*~
set <S-Tab>=[Z
"set encoding=utf-8
"set termencoding=utf-8
set fileencoding=utf-8
set fileencodings=utf-8,latin1,utf-16le,prc
set history=50		" keep 50 lines of command line history
set ruler           " show the cursor position all the time
set showcmd         " display incomplete commands
set incsearch		" do incremental searching
set nobackup
set autoread
set ff=unix
set ffs=unix
set nowb
set nowrap
set fileformat=unix
set tabstop=4
set shiftwidth=4
set softtabstop=4
set expandtab
set cinoptions=:0,g0
set autowrite
set splitbelow
set hidden
set vb t_vb=
set background=dark
set wildmode=list:longest
set laststatus=2
set statusline=[%l,%L]\ %P\ %<%f\ %h%m%r%=%(c=%c%V%)
set smartindent
if has("autocmd")
    autocmd FileType c call CDetected()
    autocmd FileType perl call PerlDetected()
    autocmd FileType cpp call CppDetected()
    autocmd FileType php call PhpDetected()
    autocmd FileType ruby call RubyDetected()
endif
"+----------------------------------------------------------+
"|                General Settings                          |
"|                    -END-                                 |
"+----------------------------------------------------------+
"===============================================================================
"+----------------------------------------------------------+
"|                Key Mappings                              |
"+----------------------------------------------------------+
map ,q :q<CR>
nnoremap <Tab> gt
nnoremap <S-Tab> :tab split<CR>
nnoremap <Space> gT
nnoremap <silent> <Left> :bp<CR>
nnoremap <silent> <Right> :bn<CR>
nnoremap <C-Up> :cp<CR>
nnoremap <C-Down> :cn<CR>
nnoremap <C-J> <C-W>j
nnoremap <C-K> <C-W>k
nnoremap <C-H> <C-W>h
nnoremap <C-L> <C-W>l
nnoremap <F3> [I
nnoremap <silent> <F5> :colorscheme murphy<CR>
nnoremap <silent> <F4> :bd<CR>
nnoremap <silent> <F6> :call ToggleSketch()<CR>
nnoremap <silent> <F7> :WMToggle<CR>
nnoremap <silent> <F8> :Tlist<CR>
nnoremap t :tags<CR>
nnoremap T :tag<CR>
nnoremap <C-N> :tab new 
map ,ba <C-W>_zz<C-W><Bar>zz
map ,bb :e #<CR>
map ,bm <C-W>=
map ,bt <C-W>}
map ,bn :ptn<CR>
map ,bp :ptp<CR>
map ,bc :pc<CR>
map ,< <C-W>20<
map ,> <C-W>20>
nnoremap x "_x
nnoremap dw "_dw
nnoremap <UP> 5<C-W>+
nnoremap <DOWN> 5<C-W>-
"+----------------------------------------------------------+
"|                Key Mappings                              |
"|                   -END-                                  |
"+----------------------------------------------------------+
"===============================================================================

"+----------------------------------------------------------+
"|                My Own Functions                          |
"+----------------------------------------------------------+
function CDetected()
    map ,g :call <SID>CompileCForDebug()<CR>
    map ,d :call <SID>DebugCFile()<CR>
    map ,e :call <SID>RunCFile()<CR>
    setlocal textwidth=80
    set tags+=~/.vim/sys_basic_tags
    set tags+=~/local/include/tags
endfunction

function RubyDetected()
    set tabstop=2
    set shiftwidth=2
    set softtabstop=2
    hi rubyFunction term=bold ctermfg=Red ctermbg=Gray
    hi rubyComment  term=bold ctermfg=darkgray
endfunction

function PerlDetected()
    map ,e :call <SID>RunPerlFile()<CR>
    map ,d :call <SID>DebugPerlFile()<CR>
    setlocal cpt=.,w,b,u,t
    hi perlComment  term=bold ctermfg=DarkCyan
    hi perlIdentifier  term=bold ctermfg=lightcyan
    hi perlFunction term=bold ctermfg=Red
    hi perlConditional term=bold ctermfg=Green
    hi perlRepeat term=bold ctermfg=Green
    hi! link perlFunctionName perlFunction
    hi perlVarPlain term=bold ctermfg=Blue
    hi perlVarPlain2 term=bold ctermfg=Cyan
    hi perlString term=bold ctermfg=White
    hi perlSpecial term=bold ctermfg=lightmagenta
endfunction

function CppDetected()
    map ,e :call <SID>RunCppFile()<CR>
    map ,g :call <SID>CompileCppFile()<CR>
    map ,d :call <SID>DebugCppFile()<CR>
    setlocal textwidth=80
    set tags+=~/.vim/sys_basic_tags
endfunction

function PhpDetected()
    map ,e :call <SID>RunPhpFile()<CR>
    setlocal textwidth=80
endfunction

function s:CompileCFile()
    if (stridx(bufname("%"), ".c")==-1)
        echo "Not a c file"
        return
    endif
    :update
    let fileNameExt=bufname("%")
    let fileName=substitute(fileNameExt, "\\(\\w\\+\\)\\.\\+.\\+", "\\1", "")
    let cmd="gcc -Wall -o ./debug/".fileName.".exe ".fileNameExt
    if isdirectory('debug')
        let ret=system(cmd)
    else
        let ret=system("mkdir debug")
        let ret=system(cmd)
    endif
    echo cmd."\n".ret
    " echo fileNameExt."\n".fileName."\n".cmd."\n".re 
endfunction

function s:CompileCForDebug()
    if (stridx(bufname("%"), ".c")==-1)
        echo "Not a c file"
        return
    endif
    :update
    let fileNameExt=bufname("%")
    let fileName=substitute(fileNameExt, "\\(\\w\\+\\)\\.\\+.\\+", "\\1", "")
    let cmd="gcc -Wall -Wextra -g -o ./debug/".fileName.".exe ".fileNameExt
    if isdirectory('debug')
        let ret=system(cmd)
    else
        let ret=system("mkdir debug")
        let ret=system(cmd)
    endif
    echo cmd."\n".ret
endfunction

function s:RunCFile()
    let FileName=bufname("%")
    let FileName=substitute(FileName, "\\(\\w\\+\\)\\.\\+.\\+", "\\1", "")
    if isdirectory('debug')
        let path=getcwd()
        let cmd=path."/debug/".FileName.".exe"
        if filereadable(cmd)
            exe "!".cmd
        else
            echo "No such file to execute."
        endif
    else
        echo "No such directory to enter."
    endif
endfunction

function s:DebugCFile()
    let FileName=bufname("%")
    let FileName=substitute(FileName, "\\(\\w\\+\\)\\.\\+.\\+", "\\1", "")
    if isdirectory('debug')
        let path=getcwd()
        let cmd=path."/debug/".FileName.".exe"
        if filereadable(cmd)
            exe "!gdb ".cmd
        else
            echo "No such file to debug."
        endif
    else
        echo "No such directory to enter."
    endif
endfunction

function s:RunPerlFile()
    :update
    let FileName=bufname("%")
    exe "! ".FileName
endfunction

function s:DebugPerlFile()
    :update
    let FileName=bufname("%")
    exe "!perl -d ".FileName
endfunction

function s:CompileCppFile()
    if (stridx(bufname("%"), ".cpp")==-1)
        echo "Not a cpp file"
        return
    endif
    :update
    let fileNameExt=bufname("%")
    let fileName=substitute(fileNameExt, "\\(\\w\\+\\)\\.\\+.\\+", "\\1", "")
    let cmd="g++ -Wall -Wextra -g -o ./debug/".fileName.".exe ".fileNameExt
    if isdirectory('debug')
        let ret=system(cmd)
    else
        let ret=system("mkdir debug")
        let ret=system(cmd)
    endif
    echo cmd."\n".ret
endfunction

function s:RunCppFile()
    let FileName=bufname("%")
    let FileName=substitute(FileName, "\\(\\w\\+\\)\\.\\+.\\+", "\\1", "")
    if isdirectory('debug')
        let path=getcwd()
        let cmd=path."/debug/".FileName.".exe"
        if filereadable(cmd)
            exe "!".cmd
        else
            echo "No such file to execute."
        endif
    else
        echo "No such directory to enter."
    endif
endfunction

function s:DebugCppFile()
    let FileName=bufname("%")
    let FileName=substitute(FileName, "\\(\\w\\+\\)\\.\\+.\\+", "\\1", "")
    if isdirectory('debug')
        let path=getcwd()
        let cmd=path."/debug/".FileName.".exe"
        if filereadable(cmd)
            exe "!gdb ".cmd
        else
            echo "No such file to debug."
        endif
    else
        echo "No such directory to enter."
    endif
endfunction

function s:RunPhpFile()
    let FileName=bufname("%")
    let cmd="php -e ".FileName." | more"
    exe "!".cmd
endfunction
"+----------------------------------------------------------+
"|                My Own Functions                          |
"|                     -END-                                |
"+----------------------------------------------------------+
" << FROM PANGU - END - >>
