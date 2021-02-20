FROM debian:stable-slim

ARG ARCH="arm-v7"

RUN apt-get update && \
    apt-get install --yes \
        curl \
        cron \
        jq \
    && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /tmp

RUN DOWNLOAD_URL="$(curl -fsSL https://api.github.com/repos/rclone/rclone/releases/latest \
    | jq -r '.assets[] | select(.name | contains("'"$ARCH"'") and contains(".deb")) | .browser_download_url')" && \
    curl -fsSL -o rclone.deb "$DOWNLOAD_URL" && \
    dpkg -i rclone.deb && \
    rm rclone.deb

WORKDIR /app
COPY docker-entrypoint.sh ./
ENTRYPOINT [ "/app/docker-entrypoint.sh" ]