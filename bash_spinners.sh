#!/usr/bin/bash

trap "scr_cleanup 12 $MSG; exit 0;" SIGINT

FMT_GRN=$'\033[1;32m'
FMT_CLR=$'\033[0;0m'

DELAY=0.1
SLIDER_LEN=5
PADDING_CHAR='.'
SLIDER_CHARS=("/" "\\")
SPINNER_CHARS=("/" "-" "\\" "|")
MSG='Loading...'

scr_init() {
  tput civis
  return
}

scr_cleanup() {
  local len=$1
  local msglen=${#2}
  local spaces=$(repeat_char " " $(($len + $msglen + 12)))

  printf "\r%s\r" "$spaces"
  tput cnorm
  return
}

repeat_char() {
  local char="$1"
  local end="$2"

  for (( i = 0; i < $end; i++ )) { echo -n "$char"; }
  return
}

run_slider() {
  local len="$1"
  local delay="$2"
  local padchar="$3"
  local msg="$4"
  shift 4
  local slider_chars=("$@")

  local frame=0
  local tot_frames=$(($len * 2))
  local chars_idx=0
  local chars_listlen="${#slider_chars[@]}"
  local slider_char="${slider_chars[$chars_idx]}"

  scr_init

  for (( i = 0; $i < 60; i++ )); do
    frame=$(($i % $tot_frames))

    if [[ ($frame -eq 0) && ($i -ne 0) ]]; then
      (( chars_idx++ ))
      chars_idx=$(($chars_idx % $chars_listlen))
      slider_char="${slider_chars[$chars_idx]}"
    elif [[ $frame -eq $len ]]; then
      (( chars_idx++ ))
      chars_idx=$(($chars_idx % $chars_listlen))
      slider_char="${slider_chars[$chars_idx]}"
    fi

    if [[ $frame -lt $len ]]; then
      lhs=$(repeat_char "$padchar" $frame)
      rhs=$(repeat_char "$padchar" $(($len - $frame)))
    else
      lhs=$(repeat_char "$padchar" $(($tot_frames - $frame)))
      rhs=$(repeat_char "$padchar" $(($frame - $len)))
    fi

    printf "[%s${FMT_GRN}%s${FMT_CLR}%s] %s\r" "$lhs" "$slider_char" "$rhs" "$msg"
    sleep $delay
  done

  scr_cleanup "$len" "$msg"
  return
}

run_spinner() {
  local delay="$1"
  local msg="$2"
  shift 2
  local spinner_chars=("$@")
  local tot_frames="${#spinner_chars[@]}"
  local frame_idx=0

  scr_init

  for (( i = 0; $i < 60; i++ )); do
    frame_idx=$(($i % $tot_frames))
    printf "[${FMT_GRN}%s${FMT_CLR}] %s\r" "${spinner_chars[$frame_idx]}" "$msg"
    sleep $delay
  done

  scr_cleanup 3 "$msg"
  return
}

run_spinner "$DELAY" "$MSG" "${SPINNER_CHARS[@]}"
run_slider "$SLIDER_LEN" "$DELAY" "$PADDING_CHAR" "$MSG" "${SLIDER_CHARS[@]}"
exit 0
