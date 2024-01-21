# add gost 
wget --no-check-certificate -N "https://github.com/ginuerzh/gost/releases/download/v2.11.2/gost-linux-amd64-2.11.2.gz"
gzip -d gost-linux-amd64-2.11.2.gz
chmod +x gost-linux-amd64-2.11.2
nohup ./gost-linux-amd64-2.11.2 -L=socks5://brook:brook@:8023 &

