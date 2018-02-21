#!/bin/bash
set -x

# From https://coderwall.com/p/sdhfug/vim-swap-backup-and-undo-files
mkdir -p ~/.vim/backup ~/.vim/swp ~/.vim/undo

echo
echo

move_and_link() {
	file=$1
	
	[[ $(mv ~/$file ~/${file}.back) ]] && echo "Moved ~/$file to ~/${file}.back"
	ln -s $PWD/$file ~/$file
	echo "Linked ~/${file} to ${PWD}/${file}"
	echo
	echo

}

#move_and_link '.vim/*'
move_and_link .vimrc
move_and_link .inputrc
move_and_link .bash_profile
ln -s .vim/* ~/.vim/

echo "Complete."
