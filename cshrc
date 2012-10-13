# << FROM PANGU - BEGIN - >>
alias grep	grep --color -n
alias egrep	egrep --color -n
alias df	df -h
alias dud	du -sh
alias ls	ls -h --color
alias l		ls -l
alias la	ls -A
alias j		jobs -l
alias c		cd -
alias cp	cp -ip
alias mv	mv -i
alias rm	rm -iv
alias g		egrep -i
alias ll	ls -laF
alias astyle  astyle -s --indent-switches --indent-preprocessor --brackets=break --pad=oper --convert-tabs
alias exctags ctags --fields=+lS --c-kinds=+px --C++-kinds=+px --languages=C,C++,Ruby,Perl
set autolist
set nobeep
umask 22

set path = (/sbin /bin /usr/sbin /usr/bin /usr/local/sbin /usr/local/bin $HOME/bin)

setenv	EDITOR	vim
setenv	PAGER	less
setenv	BLOCKSIZE	K
setenv  LANG en_US.utf8
setenv  TERM xterm

if ($?prompt) then
    # An interactive shell -- set some stuff up
    #set prompt = "`/bin/hostname -s`# "
    set promptchars = '$#'
    set prompt = '%{\033[5;30;45m%}%n@%{\033[0m%}%{\033[5;30;45m%}laptop%{\033[0m%}%{\033[0m%}%{\033[1;33;40m%}%~%{\033[0m%}%#'
	set filec
	set history = 10240
	set savehist = 10240
	set mail = (/var/mail/$USER)
	if ( $?tcsh ) then
		bindkey "^W" backward-delete-word
		bindkey "^N" history-search-backward
		bindkey "^P" history-search-forward
	endif
endif

# << FROM PANGU - END - >>
