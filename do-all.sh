#!/bin/bash

HOSTS="172.18.210.111 172.18.210.112 172.18.210.113 172.18.210.116 172.18.210.117 172.18.210.118 172.18.210.121 172.18.210.122 172.18.210.123"
VIRSH_DOMS="ubuntu-master01 ubuntu-master02 ubuntu-master03 ubuntu-etcd01 ubuntu-etcd02 ubuntu-etcd03 ubuntu-worker01 ubuntu-worker02 ubuntu-worker03"

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

ssh-key-setting-all(){
	for h in ${HOSTS}
	do
		echo ${h}
		ssh-keygen -R ${h}
    ssh-keyscan -t rsa ${h} >> ~/.ssh/known_hosts
	done
  
}

scp-command-all(){
	for h in ${HOSTS}
	do
		echo ${h}
    echo scp $@ | sed -e "s/{}/${h}/g" | xargs -I {} bash -c "{}"
	done
}

case ${1}
in
	ping )
		ping-all ;;
	shutdown )
		shutdown-all ;;
	start )
		start-all ;;
	ssh )
		ssh-command-all ${@:2} ;;
	ssh-key )
		ssh-key-setting-all ;;
	scp )
		scp-command-all ${@:2} ;;

esac

exit 0
