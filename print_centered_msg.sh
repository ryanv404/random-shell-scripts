#!/usr/bin/env bash

trap "cleanup_screen; exit 0;" SIGINT

DELAY=3

if [[ $# -eq 0 ]]; then
  MSG="usage: $0 MESSAGE"
else
  MSG="$*"
fi

scr_init() {
  tput civis
  tput clear
  return
}

print_centered_msg() {
  local msg="$1"
  local delay="$2"
  local msglen=${#msg}
  local msgmid=$(($msglen / 2))
  local vmax=$(tput lines)
  local hmax=$(tput cols)
  local vmid=$(($vmax / 2))
  local hmid=$(($(($hmax / 2)) - $msgmid))

  scr_init

  tput cup $vmid $hmid
  echo -n "$msg"
  sleep $delay

  scr_cleanup
  return
}

scr_cleanup() {
  tput clear
  tput cnorm
  return
}

print_centered_msg "$MSG" "$DELAY"
exit 0
