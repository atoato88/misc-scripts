#!/bin/bash

set -eu

if [[ "${DEBUG-undef}" != "undef" ]]
then
	set -x
fi

## Create tmux env
setup-tmux() {
	mkdir -p ~/.tmux/plugins
	git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
	cp -a ./conf/.tmux.conf ~/
	~/.tmux/plugins/tpm/bin/install_plugins
}

## Delete tmux env
delete-tmux() {
	rm -rf ~/.tmux/plugins
}


SELECT=${1:-all}
DEL_TARGET=${2:-all}

case ${SELECT}
in
	tmux )
		setup-tmux;;
	all )
		echo setup all env;;
	delete )
		case ${DEL_TARGET}
		in
			tmux )
				delete-tmux;;
			all )
				echo delete all env;;
		esac
esac

exit 0

