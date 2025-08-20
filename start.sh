#!/usr/bin/env bash

# Banner ASCII TRISOUT
cat <<'BANNER'
 _____     _                 _   
|_   _| __(_)___  ___  _   _| |_ 
  | || '__| / __|/ _ \| | | | __|
  | || |  | \__ \ (_) | |_| | |_ 
  |_||_|  |_|___/\___/ \__,_|\__|
                                 
BANNER

if [ -n "${START_COMMAND1}" ]; then 
    eval "${START_COMMAND1}"
fi
if [ -n "${START_COMMAND2}" ]; then
    eval "${START_COMMAND2}"
fi