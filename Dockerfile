FROM debian:stable-slim

RUN apt-get update && \
    apt-get install --yes \
        curl \
        cron \
        jq \
        unzip \
    && \
    rm -rf /var/lib/apt/lists/*

RUN curl -fsSL https://rclone.org/install.sh | bash

WORKDIR /app
COPY docker-entrypoint.sh ./
ENTRYPOINT [ "/app/docker-entrypoint.sh" ]