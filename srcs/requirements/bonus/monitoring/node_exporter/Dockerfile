FROM debian:bookworm

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y \
    wget \
    ca-certificates \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /opt

RUN wget https://github.com/prometheus/node_exporter/releases/download/v1.8.1/node_exporter-1.8.1.linux-amd64.tar.gz \
    && tar -xzf node_exporter-1.8.1.linux-amd64.tar.gz \
    && mv node_exporter-1.8.1.linux-amd64/node_exporter /usr/local/bin/node_exporter \
    && rm -rf node_exporter*

EXPOSE 9100

CMD ["node_exporter"]
