FROM debian:trixie-slim

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \
    apt-get install -y samba smbclient && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

RUN mkdir -p /share && chmod 0777 /share

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

EXPOSE 137/udp 138/udp 139/tcp 445/tcp

ENTRYPOINT ["/entrypoint.sh"]
