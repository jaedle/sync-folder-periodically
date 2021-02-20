#!/usr/bin/env bash

set -eu -o pipefail

create_output_streams() {
  mkfifo /tmp/stdout /tmp/stderr
  chmod 0666 /tmp/stdout /tmp/stderr
}

attach_to_cron_output() {
  tail -f /tmp/stdout &
  tail -f /tmp/stderr >&2 &
}

set_crontab() {
  rm -rf /etc/cron.d/
  mkdir /etc/cron.d/

  echo "* * * * * echo 'ran' > /tmp/stdout 2> /tmp/stderr
  # crontab requires an empty line at the end of the file" > /etc/cron.d/crontab

  crontab /etc/cron.d/crontab
}

start_cron() {
  cron -f
}

create_output_streams
attach_to_cron_output
set_crontab
start_cron