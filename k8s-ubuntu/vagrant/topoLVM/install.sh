#!/bin/bash

# install TopoLVM ★2020/8/12時点でバージョンは0.5.3が最新

echo "TopoLVM install"
pvcreate /dev/sdb
vgcreate datagroup /dev/sdb

mkdir -p /root/lvmd
cd /root/lvmd
wget https://github.com/topolvm/topolvm/releases/download/v0.5.3/lvmd-0.5.3.tar.gz
tar zxvf lvmd-0.5.3.tar.gz
mkdir /opt/sbin
chown root:root lvmd
mv lvmd /opt/sbin/lvmd

git clone --single-branch --branch v0.5.3 https://github.com/topolvm/topolvm.git
sed -i -e 's/^\(\s*volume-group: \).*$/\1datagroup/g' ./topolvm/deploy/lvmd-config/lvmd.yaml
mkdir /etc/topolvm
cp -p ./topolvm/deploy/lvmd-config/lvmd.yaml /etc/topolvm/lvmd.yaml
cp -p ./topolvm/deploy/systemd/lvmd.service /etc/systemd/system/lvmd.service
systemctl enable --now lvmd

echo "TopoLVM installed"