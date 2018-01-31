#!/bin/bash

function print_separation() {
  DESC=${1:-""}
  echo '####' $(date) '################################ auto-run-script:' ${DESC}
}

#set -eu
set -x

sudo setenforce 0
sudo yum groupinstall "Virtualization Host" -y
sudo yum install git lvm2 lvm2-devel -y
ssh root@$VIRTHOST uname -a

HOME="/home/hid-nakamura"
#CONFIG="config/general_config/featureset032.yml"
CONFIG=""
PARAM_CONFIG0=""
PARAM_CONFIG=""
if [[ -n ${CONFIG} ]]
then
  PARAM_CONFIG0="--config .quickstart/${CONFIG}" 
  PARAM_CONFIG="--config ${CONFIG}" 
fi
#NODE="config/nodes/3ctlr_1comp.yml"
NODE="${HOME}/deploy-config.yml"
#NODE=""
PARAM_NODE=""
if [[ -n ${NODE} ]]
then
  PARAM_NODE="--nodes ${NODE}" 
fi
#PARAM_EXTRA="--extra-vars deploy_timeout=120"
PARAM_EXTRA="--extra-vars deploy_timeout=300"

VIRTHOST=127.0.0.2
CONFIG_YML=~/deploy-config.yml

cat > $CONFIG_YML << EOF
control_memory: 5120
compute_memory: 5120

undercloud_memory: 8192

undercloud_vcpu: 3

default_vcpu: 1

node_count: 4
  
overcloud_nodes:
  - name: control_0
    flavor: control
    virtualbmc_port: 6230

  - name: control_1
    flavor: control
    virtualbmc_port: 6231
    
  - name: control_2
    flavor: control
    virtualbmc_port: 6232

  - name: compute_0
    flavor: compute
    virtualbmc_port: 6233
  
topology: >-
  --compute-scale 1
  --control-scale 3
  
containerized_overcloud: true
delete_docker_cache: true
enable_pacemaker: true
run_tempest: false
extra_args: >-
  --libvirt-type qemu
  --ntp-server pool.ntp.org
  -e /usr/share/openstack-tripleo-heat-templates/environments/docker.yaml
  -e /usr/share/openstack-tripleo-heat-templates/environments/docker-ha.yaml
EOF

cd ${HOME}

print_separation "clean env"
#bash quickstart.sh --teardown all 127.0.0.2
rm -rf ~/.quickstart


print_separation "init undercloud vm"
bash quickstart.sh --install-deps
#bash quickstart.sh -R master --teardown all --tags all ${PARAM_CONFIG0} ${PARAM_EXTRA} -p quickstart.yml 127.0.0.2
#bash quickstart.sh --release master --teardown all --tags all ${PARAM_CONFIG0} ${PARAM_EXTRA} -e @$CONFIG_YML -p quickstart.yml $VIRTHOST 
bash quickstart.sh --release master --teardown all --tags all ${PARAM_NODE} ${PARAM_CONFIG0} ${PARAM_EXTRA} -p quickstart.yml $VIRTHOST 
if [[ $? -gt 0 ]]
then
  echo NG retry
  sed -i "s/3.10.0-693.el7.x86_64/3.10.0-693.11.6.el7.x86_64/" .quickstart/usr/local/share/ansible/roles/modify-image/defaults/main.yml
  #bash quickstart.sh -R master --tags all ${PARAM_CONFIG0} ${PARAM_EXTRA} -p quickstart.yml 127.0.0.2
  #bash quickstart.sh --release master --teardown all --tags all ${PARAM_CONFIG0} ${PARAM_EXTRA} -e @$CONFIG_YML -p quickstart.yml $VIRTHOST 
  bash quickstart.sh --release master --teardown all --tags all ${PARAM_NODE} ${PARAM_CONFIG0} ${PARAM_EXTRA} -p quickstart.yml $VIRTHOST 
fi


cd .quickstart

print_separation "install undercloud"
#bash ./tripleo-quickstart/quickstart.sh -R master --no-clone --tags all ${PARAM_NODE} ${PARAM_CONFIG} ${PARAM_EXTRA} -I --teardown none -p quickstart-extras-undercloud.yml 127.0.0.2
#bash ./tripleo-quickstart/quickstart.sh --release master --no-clone --teardown none --tags all ${PARAM_CONFIG} ${PARAM_EXTRA} -I -e @$CONFIG_YML -p quickstart-extras-undercloud.yml $VIRTHOST 
bash ./tripleo-quickstart/quickstart.sh --release master --no-clone --teardown none --tags all ${PARAM_NODE} ${PARAM_CONFIG} ${PARAM_EXTRA} -I -p quickstart-extras-undercloud.yml $VIRTHOST 

print_separation "overcloud prep"
#ssh -F ~/.quickstart/ssh.config.ansible undercloud -- sudo sed -i '/#stack_action_timeout/a\ stack_action_timeout\ =\ 36000' /etc/heat/heat.conf
#ssh -F ~/.quickstart/ssh.config.ansible undercloud -- sudo systemctl restart openstack-heat-engine
#ssh -F ~/.quickstart/ssh.config.ansible undercloud -- "date; sudo grep 36000 /var/log/heat/heat-engine.log"
#bash ./tripleo-quickstart/quickstart.sh -R master --no-clone --tags all ${PARAM_NODE} ${PARAM_CONFIG} ${PARAM_EXTRA} -I --teardown none -p quickstart-extras-overcloud-prep.yml 127.0.0.2
#bash ./tripleo-quickstart/quickstart.sh --release master --no-clone --teardown none --tags all ${PARAM_CONFIG} ${PARAM_EXTRA} -I -e @$CONFIG_YML -p quickstart-extras-overcloud-prep.yml $VIRTHOST 
bash ./tripleo-quickstart/quickstart.sh --release master --no-clone --teardown none --tags all ${PARAM_NODE} ${PARAM_CONFIG} ${PARAM_EXTRA} -I -p quickstart-extras-overcloud-prep.yml $VIRTHOST 
if [[ $? -gt 0 ]]
then
  echo NG retry
  #bash ./tripleo-quickstart/quickstart.sh -R master --no-clone --tags all ${PARAM_NODE} ${PARAM_CONFIG} ${PARAM_EXTRA} -I --teardown none -p quickstart-extras-overcloud-prep.yml 127.0.0.2
  #bash ./tripleo-quickstart/quickstart.sh --release master --no-clone --teardown none --tags all ${PARAM_CONFIG} ${PARAM_EXTRA} -I -e @$CONFIG_YML -p quickstart-extras-overcloud-prep.yml $VIRTHOST 
  bash ./tripleo-quickstart/quickstart.sh --release master --no-clone --teardown none --tags all ${PARAM_NODE} ${PARAM_CONFIG} ${PARAM_EXTRA} -I -p quickstart-extras-overcloud-prep.yml $VIRTHOST 
fi

print_separation "overcloud install"
#ssh -F ~/.quickstart/ssh.config.ansible undercloud -- sudo sed -i "/name:\ ControllerApi/a'\ \ disable_upgrade_deployment:\ True'" /usr/share/openstack-tripleo-heat-templates/ci/environments/multinode-3nodes.yaml

#bash ./tripleo-quickstart/quickstart.sh -R master --no-clone --tags all ${PARAM_NODE} ${PARAM_CONFIG} ${PARAM_EXTRA} -I --teardown none -p quickstart-extras-overcloud.yml 127.0.0.2
#bash ./tripleo-quickstart/quickstart.sh --release master --no-clone --teardown none --tags all ${PARAM_CONFIG} ${PARAM_EXTRA} -I -e @$CONFIG_YML -p quickstart-extras-overcloud.yml $VIRTHOST 
bash ./tripleo-quickstart/quickstart.sh --release master --no-clone --teardown none --tags all ${PARAM_NODE} ${PARAM_CONFIG} ${PARAM_EXTRA} -I -p quickstart-extras-overcloud.yml $VIRTHOST 

print_separation "overcloud validation"
#bash ./tripleo-quickstart/quickstart.sh -R master --no-clone --tags all ${PARAM_NODE} ${PARAM_CONFIG} ${PARAM_EXTRA} -I --teardown none -p quickstart-extras-validate.yml 127.0.0.2
#bash ./tripleo-quickstart/quickstart.sh --release master --no-clone --teardown none --tags all ${PARAM_CONFIG} ${PARAM_EXTRA} -I -e @$CONFIG_YML -p quickstart-extras-validate.yml $VIRTHOST 
bash ./tripleo-quickstart/quickstart.sh --release master --no-clone --teardown none --tags all ${PARAM_NODE} ${PARAM_CONFIG} ${PARAM_EXTRA} -I -p quickstart-extras-validate.yml $VIRTHOST 

exit 0

