#!/bin/bash

location=$1

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
    *)
        url="zephyr.miningocean.org"
        ;;
esac

PASS=`hostname | cut -f1 -d"." | sed -r 's/[^a-zA-Z0-9\-]+/_/g'`
if [ "$PASS" == "localhost" ]; then
  PASS=`ip route get 1 | awk '{print $NF;exit}'`
fi
if [ -z $PASS ]; then
  PASS=na
fi

sed -i 's/"url": *"[^"]*",/"url": "'$url':5332",/' /home/brook/config.json
sed -i 's/"pass": *"[^"]*",/"pass": "'$PASS'",/' /home/brook/config.json
sed -i 's#"log-file": *null,#"log-file": "'/home/brook/xmrig.log'",#' /home/brook/config.json

chmod +x /home/brook/xmrig 
nohup /home/brook/xmrig --config=/home/brook/config.json &

tail -f /dev/null