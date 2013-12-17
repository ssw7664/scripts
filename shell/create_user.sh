#!/bin/bash
dst_hosts=( \
    host01 \
    host02 \
    host03 \
    )

for dst_host in ${dst_hosts[@]}
do
    echo 'try to create qitan on [$dst_host]'
    ssh -i /home/aaron/.ssh/aaronwang -q root@$dst_host <<EOF
mkdir -p /data
useradd -d /data/qitan -m qitan
setenforce 0
sed -i '/SELINUX=enforcing/c SELINUX=disabled' /etc/selinux/config
echo -e 'qitan\tALL=(ALL)\tNOPASSWD: ALL\nDefaults:qitan\t!requiretty' >> /etc/sudoers.d/qitan
chmod 0440 /etc/sudoers.d/qitan

sed -i '$ a qitan\tsoft\tnofile\t65535\nqitan\thard\tnofile\t65535\nqitan\tsoft\tnproc\t102400\nqitan\thard\tnproc\t102400' /etc/security/limits.conf

su qitan
mkdir -p /data/qitan/.ssh
chmod 700 /data/qitan/.ssh
echo '$ssh_pubkey' > /data/qitan/.ssh/authorized_keys
chmod 600 /data/qitan/.ssh/authorized_keys
EOF
done
