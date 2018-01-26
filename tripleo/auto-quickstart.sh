#!/bin/bash

function print_separation() {
  DESC=${1:-""}
  echo '#################################### auto-run-script:' ${DESC}
}

#set -eu
set -x

HOME="/home/hid-nakamura"
CONFIG="config/general_config/featureset032.yml"
NODE="config/nodes/3ctlr_1comp.yml"

print_separation "clean env"
cd ${HOME}
bash quickstart.sh --teardown all 127.0.0.2
rm -rf ~/.quickstart


print_separation "init undercloud vm"
bash quickstart.sh --install-deps
bash quickstart.sh -R master --tags all -c .quickstart/${CONFIG} -p quickstart.yml 127.0.0.2
if [[ $? -gt 0 ]]
then
  echo NG retry
  sed -i "s/3.10.0-693.el7.x86_64/3.10.0-693.11.6.el7.x86_64/" .quickstart/usr/local/share/ansible/roles/modify-image/defaults/main.yml
  bash quickstart.sh -R master --tags all -c .quickstart/${CONFIG} -p quickstart.yml 127.0.0.2
fi


cd .quickstart
print_separation "install undercloud"
bash ./tripleo-quickstart/quickstart.sh -R master --no-clone --tags all --nodes ${NODE} -c ${CONFIG} -I --teardown none -p quickstart-extras-undercloud.yml 127.0.0.2

print_separation "overcloud prep"
ssh -F ~/.quickstart/ssh.config.ansible undercloud -- sudo sed -i '/#stack_action_timeout/a\ stack_action_timeout\ =\ 36000' /etc/heat/heat.conf
ssh -F ~/.quickstart/ssh.config.ansible undercloud -- sudo systemctl restart openstack-heat-engine
ssh -F ~/.quickstart/ssh.config.ansible undercloud -- "date; sudo grep 36000 /var/log/heat/heat-engine.log"

bash ./tripleo-quickstart/quickstart.sh -R master --no-clone --tags all --nodes ${NODE} -c ${CONFIG} -I --teardown none -p quickstart-extras-overcloud-prep.yml 127.0.0.2
if [[ $? -gt 0 ]]
then
  echo NG retry
  bash ./tripleo-quickstart/quickstart.sh -R master --no-clone --tags all --nodes ${NODE} -c ${CONFIG} -I --teardown none -p quickstart-extras-overcloud-prep.yml 127.0.0.2
fi

print_separation "overcloud install"
ssh -F ~/.quickstart/ssh.config.ansible undercloud -- sudo sed -i "/name:\ ControllerApi/a'\ \ disable_upgrade_deployment:\ True'" /usr/share/openstack-tripleo-heat-templates/ci/environments/multinode-3nodes.yaml

bash ./tripleo-quickstart/quickstart.sh -R master --no-clone --tags all --nodes ${NODE} -c ${CONFIG} -I --teardown none -p quickstart-extras-overcloud.yml 127.0.0.2

print_separation "overcloud validation"
bash ./tripleo-quickstart/quickstart.sh -R master --no-clone --tags all --nodes ${NODE} -c ${CONFIG} -I --teardown none -p quickstart-extras-validate.yml 127.0.0.2

exit 0

