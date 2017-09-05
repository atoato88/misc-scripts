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

	cat << EOF > ~/.tmux.conf
# List of plugins
set -g @plugin 'tmux-plugins/tpm'
set -g @plugin 'tmux-plugins/tmux-sensible'

# Other examples:
# set -g @plugin 'github_username/plugin_name'
# set -g @plugin 'git@github.com/user/plugin'
# set -g @plugin 'git@bitbucket.com/user/plugin'
set -g @plugin 'tmux-plugins/tmux-logging'

# Initialize TMUX plugin manager (keep this line at the very bottom of tmux.conf)
run '~/.tmux/plugins/tpm/tpm'
EOF

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

