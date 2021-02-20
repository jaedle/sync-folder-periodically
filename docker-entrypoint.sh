#!/usr/bin/env bash

set -eu -o pipefail

die() {
  message="$1"

  echo "$message"
  exit 1
}

validate_inputs() {
  [[ -n "${CRON_EXPRESSION:-}" ]] || die 'please specify environment variable CRON_EXPRESSION'
  [[ -n "${SOURCE_PATH:-}" ]] || die 'please specify environment variable SOURCE_PATH'
  [[ -f /rclone.conf ]] || die 'please provide rclone configuration on /rclone.conf'
  [[ -w /output ]] || die 'please mount a writable folder on /output'
}

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

  echo "$CRON_EXPRESSION rclone --config /rclone.conf sync '$SOURCE_PATH' /output > /tmp/stdout 2> /tmp/stderr
  # crontab requires an empty line at the end of the file" > /etc/cron.d/crontab

  crontab /etc/cron.d/crontab
}

start_cron() {
  cron -f
}

validate_inputs
create_output_streams
attach_to_cron_output
set_crontab
start_cron