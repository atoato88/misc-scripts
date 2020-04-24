#!/bin/bash

# $ ls -la
# total 24
# drwxrwxr-x  2 akihito akihito 4096 10月 18 22:36 .
# drwxr-xr-x 68 akihito akihito 4096 10月 18 22:45 ..
# -rwxrwxr-x  1 akihito akihito  195  9月  3 08:25 curl-k8s-token.sh
# -rwxrwxr-x  1 akihito akihito   91  9月  2 16:42 get-token.sh
# -rwxr--r--  1 akihito akihito   66  6月  2 08:59 mount-odroid.sh
# -rwxr--r--  1 akihito akihito   51  6月  2 08:59 unmount-odroid.sh

bash -c 'readarray files < <(ls -1 | sed -e "s/curl/CURL/g"); for file in ${files[@]}; do echo -n $(md5sum $file) $file; echo; done'
# md5sum: CURL-k8s-token.sh: No such file or directory
# CURL-k8s-token.sh
# 5f2ebd3f50fa4276c55869733f71ecb0 get-token.sh get-token.sh
# 85457a7ce1e2d29b780ab54ca652b68b mount-odroid.sh mount-odroid.sh
# 3855cf897977130cf851bf7cd9091d51 unmount-odroid.sh unmount-odroid.sh

bash -c 'readarray files < <(ls -1 | sed -e "s/curl/CURL/g"); for file in ${files[@]}; do echo -n $(md5sum $file) $file| cut -d " " -f 1,3|awk "{print \$2 \" \" \$1 }"; done'
# bash-oneliner.sh 23d5c0a48bf854f5d31129c4a9e2aaea
# cth.sh 07ba5ba5f7258d3707c33217fb5f5f46
# dummy_server2.sh d4634e90a586145f1544f6b81b8d4fc7
# dummy_server.sh 28b243b58d7d8cd990d52190aedc0cf2
# exec_step_by_step.sh a95bd613eafa52757149158515eb78e3
# get_current_dir.sh f5b3e0f796277936653c41c1b33448b5
# get_kernel_bit.sh 77642a14fe9c22bf0be580414e7b5412
# get_options1.sh 7a8b551a4e15fd516755c831a51c8867
# get_options2.sh 98f13214fb8fe9d08d46f4617e1ae4fc
# get_scsi_info.sh e4d6c51488fa41fd28b21d80180c13d0
# ping_with_time.sh 8a3ca32d1acea73fbfb1d344135aa975
# run-test-prometheus-target.sh 46a46d45cd198fdc1a6259b22a5450ba

bash -c 'readarray files < <(find . -type f); for file in ${files[@]}; do echo -n $(md5sum $file) $file| cut -d " " -f 1,3|awk "{print \$1 \" \" \$2 }"; done'

bash -c 'readarray files < <(ls -1tr | tail -n10 | xargs -I {} find {} -name "url.txt"); for i in `seq 0 869` ; do echo ${files[i]} | sed -e "s/ /\ /g" | xargs -I {} md5sum {}; done'
