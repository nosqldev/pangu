#!/bin/sh

# {{{ Basic Functions

gputs()
{
    printf "\033[01;32m$1\033[00m\n"
}

yputs()
{
    printf "\033[00;33;40m$1\033[00m\n"
}

cputs()
{
    printf "\033[01;36;40m$1\033[00m\n"
}

warn_puts()
{
    printf "\033[01;33;41m$1\033[00m\n"
}

run_cmd()
{
    printf "\033[01;32m$1\033[00m\n"
    printf "\033[01;30;40m"
    $1
    if [ $? != 0 ]
    then
        printf "\033[01;33;41mFailed: $1\033[00m\n"
        exit 1
    fi
    printf "\033[00m"
}

# }}}

mkdir_basic_dir()
{
    cputs "Home dir is "$HOME
    bindir_path=$HOME"/bin"
    localdir_path=$HOME"/local"
    installdir_path=$HOME"/install"
    sshdir_path=$HOME"/.ssh"

    if [ ! -e $bindir_path ]
    then
        run_cmd "mkdir $bindir_path"
    fi
    if [ ! -e $localdir_path ]
    then
        run_cmd "mkdir $localdir_path"
    fi
    if [ ! -e $installdir_path ]
    then
        run_cmd "mkdir $installdir_path"
    fi
    if [ ! -e $sshdir_path ]
    then
        run_cmd "mkdir $sshdir_path"
    fi
}

setup_screen_cfg()
{
    if [ ! -e $HOME/.screenrc ]
    then
        cputs "Ready to setup screen"
        if [ $OSTYPE == "FreeBSD" ]
        then
            cat screenrc_fb >> $HOME/.screenrc
        else
            cat screenrc >> $HOME/.screenrc
        fi
    else
        yputs "Screen config already exists!"
    fi
}

setup_tcsh_cfg()
{
    if [ -e $HOME/.cshrc ]
    then
        if [ $OSTYPE == "FreeBSD" ]
        then
            sed -i '' '/<< FROM PANGU - BEGIN - >>/,/<< FROM PANGU - END - >>/d' $HOME/.cshrc
            cputs "Ready to setup tcsh"
            cat cshrc_fb >> $HOME/.cshrc
        else
            sed -i'' '/<< FROM PANGU - BEGIN - >>/,/<< FROM PANGU - END - >>/d' $HOME/.cshrc
            cputs "Ready to setup tcsh"
            cat cshrc >> $HOME/.cshrc
        fi
    fi
}

setup_ssh_cfg()
{
    if [ -e $HOME/.ssh/config ]
    then
        cputs "Filtered PANGU config from $HOME/.ssh/config"
        if [ $OSTYPE == "FreeBSD" ]
        then
            sed -i '' '/<< FROM PANGU - BEGIN - >>/,/<< FROM PANGU - END - >>/d' $HOME/.ssh/config
        else
            sed -i'' '/<< FROM PANGU - BEGIN - >>/,/<< FROM PANGU - END - >>/d' $HOME/.ssh/config
        fi
    fi
    cputs "Ready to touch authorized_keys"
    run_cmd "touch $sshdir_path/authorized_keys"
    cputs "Ready to setup ssh_config"
    cat ssh_config >> $HOME/.ssh/config
}

setup_vim_cfg()
{
    if [ -e $HOME/.vimrc ]
    then
        yputs "VIM config already exists!"
    else
        cputs "Ready to setup vimrc"
        cat vimrc >> $HOME/.vimrc
    fi
}

mkdir_basic_dir
setup_screen_cfg
setup_tcsh_cfg
setup_ssh_cfg
setup_vim_cfg

# vim: foldmethod=marker
