#!/bin/bash

HOSTS="192.168.210.111 192.168.210.112 192.168.210.113 192.168.210.114 192.168.210.116 192.168.210.117 192.168.210.118 192.168.210.121 192.168.210.122 192.168.210.123 192.168.210.124"
VIRSH_DOMS="ubuntu-master01 ubuntu-master02 ubuntu-master03 ubuntu-master04 ubuntu-etcd01 ubuntu-etcd02 ubuntu-etcd03 ubuntu-worker01 ubuntu-worker02 ubuntu-worker03 ubuntu-worker04"

RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m'

ping-all(){
	for h in ${HOSTS}
	do
		echo ${h}
		ping -c 1 -W 2 ${h}
		if [[ $? == 0 ]]
		then
			printf "${GREEN}OK!: ${h}${NC}\n"
			#HOSTS=$(echo ${HOSTS} | sed -e "s/${h}//g")
		else
			printf "${RED}NG!: ${h}${NC}\n"
		fi
	done
}

shutdown-all(){
	for h in ${VIRSH_DOMS}
	do
		echo ${h}
		sudo virsh shutdown ${h}
	done
}

start-all(){
	for h in ${VIRSH_DOMS}
	do
		echo ${h}
		sudo virsh start ${h}
	done
}

ssh-command-all(){
	for h in ${HOSTS}
	do
		echo ${h}
		ssh -l ubuntu ${h} $@
	done
}

case ${1}
in
	ping )
		ping-all;;
	shutdown )
		shutdown-all;;
	start )
		start-all;;
	ssh )
		ssh-command-all ${@:2} ;;

esac

exit 0
