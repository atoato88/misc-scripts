#!/bin/bash

set -eu

if [[ "${DEBUG-undef}" != "undef" ]]
then
	set -x
fi

## Setup tmux env
setup-tmux() {
	mkdir -p ~/.tmux/plugins
	git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
	cp -a ./config/.tmux.conf ~/
	~/.tmux/plugins/tpm/bin/install_plugins
}

## Delete tmux env
delete-tmux() {
	rm -rf ~/.tmux/plugins
}

## Setup vim env
setup-vim() {
	sudo apt install -y vim-gnome-py2
	sudo update-alternatives --set vim /usr/bin/vim.gnome-py2
	curl https://raw.githubusercontent.com/Shougo/neobundle.vim/master/bin/install.sh > /tmp/install.sh
	. /tmp/install.sh && rm /tmp/install.sh
	cp -a ./config/.vimrc ~/
	vim +NeoBundleInstall +qall
}

## Delete vim env
delete-vim() {
	rm -rf ~/.vim/bundle
}

## Setup bashrc env
setup-bashrc() {
	cat ./config/.bashrc-append >> ~/.bashrc
}

## Delete bashrc env
delete-bashrc() {
  cat ./config/.bashrc-append | awk '{gsub("\\\\n", "\\\\\\\\n"); print $0}' |
  while read li
  do
    if [[ -n "${li}" ]]
    then
      sed -i "/${li}/d" ~/.bashrc
    fi
  done
}

SELECT=${1:-all}
DEL_TARGET=${2:-all}

case ${SELECT}
in
	tmux )
		setup-tmux;;
	vim )
		setup-vim;;
	bashrc )
		setup-bashrc;;
	all )
		echo setup all env;;
	delete )
		case ${DEL_TARGET}
		in
			tmux )
				delete-tmux;;
			vim )
				delete-vim;;
			bashrc )
				delete-bashrc;;
			all )
				echo delete all env;;
		esac
esac

exit 0

