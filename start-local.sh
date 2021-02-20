#!/usr/bin/env bash

set -eu -o pipefail

die() {
    reason="$1"

    echo "$reason"
    exit 1
}

check_preconditions() {
    [[ ! -f dev/rclon.conf ]] || die 'rclone configuration is missing'
}

cleanup() {
    rm -rf dev/output
    mkdir -p dev/output
}

build_image() {
    docker image build --build-arg ARCH='amd64' --tag sync-folder-periodically:development .
}

start() {
    docker container run \
        --rm \
        -it \
        --env CRON_EXPRESSION='* * * * *' \
        --env SOURCE_PATH='gdrive:/3d-printing' \
        --mount type=bind,source="$PWD/dev/rclone.conf",target=/rclone.conf,readonly \
        --mount type=bind,source="$PWD/dev/output",target=/output \
        sync-folder-periodically:development
}

check_preconditions
cleanup
build_image
start
