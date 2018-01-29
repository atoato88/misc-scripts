#!/bin/bash

# see http://superuser.openstack.org/articles/new-tripleo-quick-start-cheatsheet/

set -x

cd ${HOME}
rm -rf ~/.quickstart

export VIRTHOST=127.0.0.2
sudo yum groupinstall "Virtualization Host" -y
sudo yum install git lvm2 lvm2-devel -y
ssh root@$VIRTHOST uname -a

# 03 - Clone repos and install deps.
bash quickstart.sh --install-deps
sudo setenforce 0

# 04 - Configure the TripleO deployment with Docker and HA.
export CONFIG=~/deploy-config.yaml
cat > $CONFIG << EOF
control_memory: 6144
compute_memory: 6144

undercloud_memory: 8192

undercloud_vcpu: 4

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

# 05 - Deploy TripleO.
export VIRTHOST=127.0.0.2
bash ./quickstart.sh \
      --clean          \
      --release master \
      --teardown all   \
      --tags all       \
      -e @$CONFIG      \
      $VIRTHOST


