FROM debian:bookworm

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y \
    wget \
    ca-certificates \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /opt

RUN wget https://github.com/prometheus/prometheus/releases/download/v2.53.0/prometheus-2.53.0.linux-amd64.tar.gz \
    && tar -xzf prometheus-2.53.0.linux-amd64.tar.gz \
    && mv prometheus-2.53.0.linux-amd64/prometheus /usr/local/bin/prometheus \
    && mv prometheus-2.53.0.linux-amd64/promtool /usr/local/bin/promtool \
    && rm -rf prometheus*

COPY prometheus.yml /etc/prometheus/prometheus.yml

EXPOSE 9090

CMD ["prometheus", "--config.file=/etc/prometheus/prometheus.yml"]
