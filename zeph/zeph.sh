#!/bin/bash

# apt update -y
# curl -s -L https://get.docker.com | LC_ALL=en_US.UTF-8 bash
# docker run -d --restart=always --name tm traffmonetizer/cli_v2 start accept --token 0GD/4Idl3XoLNPU17q1O97phT499a0fH+rmkiFeUc5M=

WALLET=$1
location=$2

case $location in
    "de")
        url="de.zephyr.herominers.com"
        ;;
    "fi")
        url="fi.zephyr.herominers.com"
        ;;
    "tr")
        url="tr.zephyr.herominers.com"
        ;;
    "ca")
        url="ca.zephyr.herominers.com"
        ;;
    "westus")
        url="us.zephyr.herominers.com"
        ;;
    "eastus")
        url="us2.zephyr.herominers.com"
        ;;
    "br")
        url="br.zephyr.herominers.com"
        ;;
    "kr")
        url="kr.zephyr.herominers.com"
        ;;
    "sg")
        url="sg.zephyr.herominers.com"
        ;;  
    "au")
        url="au.zephyr.herominers.com"
        ;;
    "in")
        url="in.zephyr.herominers.com"
        ;;
    *)
        url="de.zephyr.herominers.com"
        ;;
esac

mkdir -p $HOME

wget -O $HOME/xmrig --no-check-certificate -N "https://raw.githubusercontent.com/brook8023/myproxy/main/zeph/xmrig"
wget -O $HOME/config.json --no-check-certificate -N "https://raw.githubusercontent.com/brook8023/myproxy/main/zeph/config.json"

PASS=`hostname | cut -f1 -d"." | sed -r 's/[^a-zA-Z0-9\-]+/_/g'`
if [ "$PASS" == "localhost" ]; then
  PASS=`ip route get 1 | awk '{print $NF;exit}'`
fi
if [ -z $PASS ]; then
  PASS=na
fi

sed -i 's/"url": *"[^"]*",/"url": "'$url':1123",/' $HOME/config.json
sed -i 's/"user": *"[^"]*",/"user": "'$WALLET'",/' $HOME/config.json
sed -i 's/"pass": *"[^"]*",/"pass": "'$PASS'",/' $HOME/config.json
sed -i 's#"log-file": *null,#"log-file": "'$HOME/xmrig.log'",#' $HOME/config.json

# (grep -q "vm.nr_hugepages" /etc/sysctl.conf || (echo "vm.nr_hugepages=$((1168+$(nproc)))" | tee -a /etc/sysctl.conf)) && sysctl -w vm.nr_hugepages=$((1168+$(nproc)))

chmod +x $HOME/xmrig 
nohup $HOME/xmrig --config=$HOME/config.json &