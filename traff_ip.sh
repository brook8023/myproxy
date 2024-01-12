#add docker
apt update -y
curl -s -L https://get.docker.com | LC_ALL=en_US.UTF-8 bash

for i in $(seq 1 $1)
do
    iface=$(expr 3 + $i)
    subnum=$(expr 32 + $i)

    docker network create my_network_$i --driver bridge --subnet 192.168.$subnum.0/24
    iptables -t nat -I POSTROUTING -s 192.168.$subnum.0/24 -j SNAT --to-source 10.1.0.$iface
    docker run -d --network my_network_$i --name tm_$i traffmonetizer/cli_v2 start accept --token $2
done
