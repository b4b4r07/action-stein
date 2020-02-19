FROM golang:1.13.7-stretch

ENV STEIN_VERSION=v0.3.1

RUN apt-get update && apt-get install -y --no-install-recommends \
        ca-certificates \
        jq \
        vim \
    && rm -rf /var/lib/apt/lists/*

# Install b4b4r07/stein
RUN mkdir -p /tmp/stein \
    && cd /tmp/stein \
    && wget https://github.com/b4b4r07/stein/releases/download/${STEIN_VERSION}/stein_linux_x86_64.tar.gz \
    && tar zxvf stein_linux_x86_64.tar.gz \
    && mv stein /usr/local/bin/stein \
    && cd / \
    && rm -rf /tmp/stein

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
