FROM ubuntu:22.04

WORKDIR /home/brook
COPY .  ./
RUN chmod +x zeph.sh
ENTRYPOINT [ "/bin/bash", "/home/brook/zeph.sh" ]