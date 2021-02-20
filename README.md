# Periodically sync folders

## Use-Case

I am using a network drive to store my 3d-print-files. Whenever I upload a file from a computer it automatically syncs (one way) to my raspberry pi I use for printing.

## Used tools

- [cron](https://en.wikipedia.org/wiki/Cron)
- [rclone](https://rclone.org/)

## Usage

This example usage would use an existing rclone-configuration and synchronize each 15 minutes from the remote `gdrive` the folder `subfolder` into the mounted folder `$PWD/output`:

```sh
docker container run \
    --restart always \
    -d \
    --env CRON_EXPRESSION='*/15 * * * *' \
    --env SOURCE_PATH='gdrive:/subfolder'
    --mount type=bind,source="$PWD/rclone.conf",target=/rclone.conf,readonly \
    --mount type=bind,source="$PWD/output",target=/output \
    jaedle/sync-folder-periodically:arm32v7-latest
```