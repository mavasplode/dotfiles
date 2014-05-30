#!/bin/bash
############################
# makesymlinks.sh
# This script creates symlinks from the home directory to any desired dotfiles in ~/dotfiles
# http://blog.smalleycreative.com/tutorials/using-git-and-github-to-manage-your-dotfiles/
# http://www.kfirlavi.com/blog/2012/11/14/defensive-bash-programming/
############################

usage() {
    cat <<- EOF
	usage: $0 [-cih]

	This program creates symlinks in the user's home directory to the
	bundled config files.

	OPTIONS:
	   -c    copy - copy files instead of making symlinks
	   -i    interactive - prompt before making each symlink
	   -h    help - print this message
	EOF
} 

main() {
    # Parse args
    interactive=false
    copy=false
    while getopts "chi" opt; do
        case $opt in
            c)
                copy=true
                ;;
            i)
                interactive=true
                ;;
            h)
                usage
                exit 0
                ;;
            *)
                usage
                exit 0
                ;;
        esac
    done

    # dotfiles directory
    dir=~/dotfiles
    # old dotfiles backup directory
    olddir=~/.dotfiles_old
    # list of files/folders to symlink in homedir
    files="elisp emacs gitconfig profile tmux.conf vimrc zephyros.js"
    
    # create dotfiles_old in homedir
    echo -n "Creating $olddir for backup of any existing dotfiles in ~ ..."
    mkdir -p $olddir
    echo "done"
    
    # change to the dotfiles directory
    echo -n "Changing to the $dir directory ..."
    cd $dir
    echo "done"
    
    # move any existing dotfiles in homedir to dotfiles_old directory,
    # then create symlinks from the homedir to any files in the
    # ~/dotfiles directory specified in $files
    echo "Moving any existing dotfiles from ~ to $olddir"
    for file in $files; do
        # if run with -i parameter, prompt user before creating each symlink
        if [ $interactive ]
        then
            read -p "Create symlink to $file in home directory? " -n 1 -r
            echo
            if [[ $REPLY =~ ^[Yy]$ ]]
            then
                mv ~/.$file $olddir/
                echo "Creating symlink to $file in home directory."
                if [ $copy ]
                then
                    cp $dir/$file ~/.$file
                else
                    ln -s $dir/$file ~/.$file
                fi
            fi
        # otherwise just go ahead and create them
        else
            mv ~/.$file $olddir/
            echo "Creating symlink to $file in home directory."
            if [ $copy ]
            then
                cp $dir/$file ~/.$file
            else
                ln -s $dir/$file ~/.$file
            fi
        fi
    done
}

main