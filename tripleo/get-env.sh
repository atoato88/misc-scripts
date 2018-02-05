#!/bin/bash

#set -x

function get_date() {
  date +"%Y%m%d-%H%M%S"
}

function get_filename() {
  echo ${1}|sed -e 's/sudo //g'|sed -e 's/ -.*//g'|sed -e 's/ /-/g'
}

function print_separation() {
  DESC=${1:-""}
  echo '####' $(date) '################################ ' ${DESC}
}

NOW=$(get_date)
STR_JOIN="-"
PREFIX="get-env"
WD=${WD:-"/tmp/${PREFIX}${STR_JOIN}${NOW}"}
PREFIX_UNDER="undercloud"
PREFIX_OVER="overcloud"
PREFIX_CONT="controller"
PREFIX_COMP="compute"

STR_UNDER="undercloud"
STR_OVER_CONT="overcloud-controller"
STR_OVER_CONT0="overcloud-controller-0"
STR_OVER_CONT1="overcloud-controller-1"
STR_OVER_CONT2="overcloud-controller-2"
STR_OVER_COMP="overcloud-novacompute"
STR_OVER_COMP0="overcloud-novacompute-0"


# Command to get environment info.
COM_SSH="ssh -F ${HOME}/.quickstart/ssh.config.ansible"
COM_SCP="scp -F ${HOME}/.quickstart/ssh.config.ansible"
COM_SYSTEMD_SERVICE="sudo systemctl list-unit-files --full"
COM_PS="sudo ps -ef"
COM_DOCKER_PS="sudo docker ps --all"
COM_DOCKER_IMAGE="sudo docker images"
COM_PCS_STATUS="sudo pcs status"
COM_PCS_CONFIG="sudo pcs config"
COM_PCS_CLUSTER_CIB="sudo pcs cluster cib"


# Files for environment settings.
FILE_ETC="/etc"
FILE_LOG="/var/log"
FILE_OCF="/usr/lib/ocf"
COM_TAR="sudo tar czvf"


mkdir -p ${WD}
cd ${WD}

print_separation "generate script"

cat <<EOF > "${WD}/export.sh"
#!/bin/sh

STR_JOIN="${STR_JOIN}"
PREFIX="${PREFIX}"
WD="${WD}"
PREFIX_UNDER="${PREFIX_UNDER}"
PREFIX_OVER="${PREFIX_OVER}"
PREFIX_CONT="${PREFIX_CONT}"
PREFIX_COMP="${PREFIX_COMP}"

STR_UNDER="${STR_UNDER}"
STR_OVER_CONT="${STR_OVER_CONT}"
STR_OVER_CONT0="${STR_OVER_CONT0}"
STR_OVER_CONT1="${STR_OVER_CONT1}"
STR_OVER_CONT2="${STR_OVER_CONT2}"
STR_OVER_COMP="${STR_OVER_COMP}"

COM_SYSTEMD_SERVICE="${COM_SYSTEMD_SERVICE}"
COM_PS="${COM_PS}"
COM_DOCKER_PS="${COM_DOCKER_PS}"
COM_DOCKER_IMAGE="${COM_DOCKER_IMAGE}"
COM_PCS_STATUS="${COM_PCS_STATUS}"
COM_PCS_CONFIG="${COM_PCS_CONFIG}"
COM_PCS_CLUSTER_CIB="${COM_PCS_CLUSTER_CIB}"


# Files for environment settings.
FILE_ETC="${FILE_ETC}"
#FILE_LOG="${FILE_LOG}"
COM_TAR="${COM_TAR}"

NOW="${NOW}"
EOF


cat <<EOF > "${WD}/run${STR_JOIN}${PREFIX}${STR_JOIN}${STR_UNDER}.sh"
#!/bin/sh

source /tmp/export.sh

mkdir -p ${WD}
cd ${WD}

${COM_SYSTEMD_SERVICE} > $(get_filename "${COM_SYSTEMD_SERVICE}")
${COM_PS} > $(get_filename "${COM_PS}")

${COM_TAR} etc.tar.gz ${FILE_ETC}

tar czvf /tmp/${STR_UNDER}.tar.gz .
sudo rm -rf ${WD} 
EOF


cat <<EOF > "${WD}/run${STR_JOIN}${PREFIX}${STR_JOIN}${STR_OVER_CONT}.sh"
#!/bin/sh

source /tmp/export.sh

mkdir -p ${WD}
cd ${WD}

${COM_SYSTEMD_SERVICE} > $(get_filename "${COM_SYSTEMD_SERVICE}")
${COM_PS} > $(get_filename "${COM_PS}")
${COM_DOCKER_PS} > $(get_filename "${COM_DOCKER_PS}")
${COM_DOCKER_IMAGE} > $(get_filename "${COM_DOCKER_IMAGE}")
${COM_PCS_STATUS} > $(get_filename "${COM_PCS_STATUS}")
${COM_PCS_CONFIG} > $(get_filename "${COM_PCS_CONFIG}")
${COM_PCS_CLUSTER_CIB} > $(get_filename "${COM_PCS_CLUSTER_CIB}")

${COM_TAR} etc.tar.gz ${FILE_ETC}
${COM_TAR} usr-lib-ocf.tar.gz ${FILE_OCF}

tar czvf /tmp/${STR_OVER_CONT}.tar.gz .
sudo rm -rf ${WD} 
EOF


cat <<EOF > "${WD}/run${STR_JOIN}${PREFIX}${STR_JOIN}${STR_OVER_COMP}.sh"
#!/bin/sh

source /tmp/export.sh

mkdir -p ${WD}
cd ${WD}

${COM_SYSTEMD_SERVICE} > $(get_filename "${COM_SYSTEMD_SERVICE}")
${COM_PS} > $(get_filename "${COM_PS}")
${COM_DOCKER_PS} > $(get_filename "${COM_DOCKER_PS}")
${COM_DOCKER_IMAGE} > $(get_filename "${COM_DOCKER_IMAGE}")

${COM_TAR} etc.tar.gz ${FILE_ETC}

tar czvf /tmp/${STR_OVER_COMP}.tar.gz .
sudo rm -rf ${WD} 
EOF


print_separation "get undercloud"

${COM_SCP} ${WD}/export.sh ${STR_UNDER}:/tmp/export.sh
${COM_SCP} ${WD}/run${STR_JOIN}${PREFIX}${STR_JOIN}${STR_UNDER}.sh ${STR_UNDER}:/tmp/run${STR_JOIN}${PREFIX}${STR_JOIN}${STR_UNDER}.sh
${COM_SSH} ${STR_UNDER} chmod +x /tmp/run${STR_JOIN}${PREFIX}${STR_JOIN}${STR_UNDER}.sh
${COM_SSH} ${STR_UNDER} /tmp/run${STR_JOIN}${PREFIX}${STR_JOIN}${STR_UNDER}.sh
${COM_SCP} ${STR_UNDER}:/tmp/${STR_UNDER}.tar.gz ${WD}/${STR_UNDER}.tar.gz
mkdir -p ${STR_UNDER}
tar xzvf ${STR_UNDER}.tar.gz -C ${STR_UNDER}

print_separation "get overcloud"
print_separation "get overcloud-controller0"

${COM_SCP} ${WD}/export.sh ${STR_OVER_CONT0}:/tmp/export.sh
${COM_SCP} ${WD}/run${STR_JOIN}${PREFIX}${STR_JOIN}${STR_OVER_CONT}.sh ${STR_OVER_CONT0}:/tmp/run${STR_JOIN}${PREFIX}${STR_JOIN}${STR_OVER_CONT}.sh
${COM_SSH} ${STR_OVER_CONT0} chmod +x /tmp/run${STR_JOIN}${PREFIX}${STR_JOIN}${STR_OVER_CONT}.sh
${COM_SSH} ${STR_OVER_CONT0} /tmp/run${STR_JOIN}${PREFIX}${STR_JOIN}${STR_OVER_CONT}.sh
${COM_SCP} ${STR_OVER_CONT0}:/tmp/${STR_OVER_CONT}.tar.gz ${WD}/${STR_OVER_CONT0}.tar.gz
mkdir -p ${STR_OVER_CONT0}
tar xzvf ${STR_OVER_CONT0}.tar.gz -C ${STR_OVER_CONT0}

print_separation "get overcloud-controller1"

${COM_SCP} ${WD}/export.sh ${STR_OVER_CONT1}:/tmp/export.sh
${COM_SCP} ${WD}/run${STR_JOIN}${PREFIX}${STR_JOIN}${STR_OVER_CONT}.sh ${STR_OVER_CONT1}:/tmp/run${STR_JOIN}${PREFIX}${STR_JOIN}${STR_OVER_CONT}.sh
${COM_SSH} ${STR_OVER_CONT1} chmod +x /tmp/run${STR_JOIN}${PREFIX}${STR_JOIN}${STR_OVER_CONT}.sh
${COM_SSH} ${STR_OVER_CONT1} /tmp/run${STR_JOIN}${PREFIX}${STR_JOIN}${STR_OVER_CONT}.sh
${COM_SCP} ${STR_OVER_CONT1}:/tmp/${STR_OVER_CONT}.tar.gz ${WD}/${STR_OVER_CONT1}.tar.gz
mkdir -p ${STR_OVER_CONT1}
tar xzvf ${STR_OVER_CONT1}.tar.gz -C ${STR_OVER_CONT1}

print_separation "get overcloud-controller2"

${COM_SCP} ${WD}/export.sh ${STR_OVER_CONT2}:/tmp/export.sh
${COM_SCP} ${WD}/run${STR_JOIN}${PREFIX}${STR_JOIN}${STR_OVER_CONT}.sh ${STR_OVER_CONT2}:/tmp/run${STR_JOIN}${PREFIX}${STR_JOIN}${STR_OVER_CONT}.sh
${COM_SSH} ${STR_OVER_CONT2} chmod +x /tmp/run${STR_JOIN}${PREFIX}${STR_JOIN}${STR_OVER_CONT}.sh
${COM_SSH} ${STR_OVER_CONT2} /tmp/run${STR_JOIN}${PREFIX}${STR_JOIN}${STR_OVER_CONT}.sh
${COM_SCP} ${STR_OVER_CONT2}:/tmp/${STR_OVER_CONT}.tar.gz ${WD}/${STR_OVER_CONT2}.tar.gz
mkdir -p ${STR_OVER_CONT2}
tar xzvf ${STR_OVER_CONT2}.tar.gz -C ${STR_OVER_CONT2}


print_separation "get overcloud-compure"

${COM_SCP} ${WD}/export.sh ${STR_OVER_COMP0}:/tmp/export.sh
${COM_SCP} ${WD}/run${STR_JOIN}${PREFIX}${STR_JOIN}${STR_OVER_COMP}.sh ${STR_OVER_COMP0}:/tmp/run${STR_JOIN}${PREFIX}${STR_JOIN}${STR_OVER_COMP}.sh
${COM_SSH} ${STR_OVER_COMP0} chmod +x /tmp/run${STR_JOIN}${PREFIX}${STR_JOIN}${STR_OVER_COMP}.sh
${COM_SSH} ${STR_OVER_COMP0} /tmp/run${STR_JOIN}${PREFIX}${STR_JOIN}${STR_OVER_COMP}.sh
${COM_SCP} ${STR_OVER_COMP0}:/tmp/${STR_OVER_COMP}.tar.gz ${WD}/${STR_OVER_COMP0}.tar.gz
mkdir -p ${STR_OVER_COMP0}
tar xzvf ${STR_OVER_COMP0}.tar.gz -C ${STR_OVER_COMP0}


rm -rf ${WD}/${STR_UNDER}.tar.gz
rm -rf ${WD}/${STR_OVER_CONT0}.tar.gz
rm -rf ${WD}/${STR_OVER_CONT1}.tar.gz
rm -rf ${WD}/${STR_OVER_CONT2}.tar.gz
rm -rf ${WD}/${STR_OVER_COMP0}.tar.gz

echo "Getting file is done."
echo "For check output: cd ${WD}"

exit 0

