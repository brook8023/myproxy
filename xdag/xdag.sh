#!/bin/bash

WALLET=$1

wget -O $HOME/xdag --no-check-certificate -N "https://raw.githubusercontent.com/brook8023/myproxy/main/xdag/xdag"
wget -O $HOME/xdagconfig.json --no-check-certificate -N "https://raw.githubusercontent.com/brook8023/myproxy/main/xdag/xdagconfig.json"
wget -O $HOME/xmrig-4-xdag --no-check-certificate -N "https://raw.githubusercontent.com/brook8023/myproxy/main/xdag/xmrig-4-xdag"
wget -O $HOME/config.json --no-check-certificate -N "https://raw.githubusercontent.com/brook8023/myproxy/main/xdag/config.json"

PASS=`hostname | cut -f1 -d"." | sed -r 's/[^a-zA-Z0-9\-]+/_/g'`
if [ "$PASS" == "localhost" ]; then
  PASS=`ip route get 1 | awk '{print $NF;exit}'`
fi
if [ -z $PASS ]; then
  PASS=na
fi

sed -i 's/"user": *"[^"]*",/"user": "'$WALLET'",/' $HOME/config.json
sed -i 's/"pass": *"[^"]*",/"pass": "'$PASS'",/' $HOME/config.json
sed -i 's#"log-file": *null,#"log-file": "'$HOME/xmrig.log'",#' $HOME/config.json

(grep -q "vm.nr_hugepages" /etc/sysctl.conf || (echo "vm.nr_hugepages=$((1168+$(nproc)))" | tee -a /etc/sysctl.conf)) && sysctl -w vm.nr_hugepages=$((1168+$(nproc)))

chmod +x $HOME/xdag
nohup $HOME/xdag -c $HOME/xdagconfig.json &
chmod +x $HOME/xmrig-4-xdag
nohup $HOME/xmrig-4-xdag --config=$HOME/config.json &