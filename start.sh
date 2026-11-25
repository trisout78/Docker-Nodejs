#!/usr/bin/env bash

###############################################################################
# Minimum Node.js version: refuse to start on end-of-life / vulnerable releases
###############################################################################

MIN_NODE_MAJOR=22

check_node_version() {
  local node_ver node_major
  node_ver=$(node -v 2>/dev/null) || return 0
  node_major=${node_ver#v}
  node_major=${node_major%%.*}
  [[ "$node_major" =~ ^[0-9]+$ ]] || return 0
  [ "$node_major" -ge "$MIN_NODE_MAJOR" ] && return 0

  printf '\033[1;31m'
  cat <<'ART'
 __        ___    ____  _   _ ___ _   _  ____
 \ \      / / \  |  _ \| \ | |_ _| \ | |/ ___|
  \ \ /\ / / _ \ | |_) |  \| || ||  \| | |  _
   \ V  V / ___ \|  _ <| |\  || || |\  | |_| |
    \_/\_/_/   \_\_| \_\_| \_|___|_| \_|\____|

ART
  cat <<EOF
################################################################################
#
#   /!\  VERSION VULNÉRABLE - DÉMARRAGE BLOQUÉ  /!\\
#
#   Node.js ${node_ver} n'est plus maintenu et ne reçoit plus de correctifs
#   de sécurité. Le serveur ne démarrera pas avec cette version.
#
#   >>> Merci de passer à Node.js ${MIN_NODE_MAJOR} minimum. <<<
#
#   ------------------------------------------------------------------------
#
#   /!\  VULNERABLE VERSION - STARTUP BLOCKED  /!\\
#
#   Node.js ${node_ver} is end-of-life and no longer receives security fixes.
#   The server will not start with this version.
#
#   >>> Please upgrade to Node.js ${MIN_NODE_MAJOR} or newer. <<<
#
################################################################################
EOF
  printf '\033[0m\n'
  exit 1
}

check_node_version

# Banner ASCII TRISOUT
cat <<'BANNER'
 _   _           _          _ ____  
| \ | | ___   __| | ___    | / ___| 
|  \| |/ _ \ / _` |/ _ \_  | \___ \ 
| |\  | (_) | (_| |  __/ |_| |___) |
|_| \_|\___/ \__,_|\___|\___/|____/ 
                                                                 
BANNER

###############################################################################
# System usage (CPU & Memory)
###############################################################################

print_system_box() {
  local cpu_model="" cpu_usage_pct="" mem_total_kb="" mem_avail_kb="" mem_used_kb="" mem_used_pct="" mem_total_gib="" mem_used_gib=""
  local node_ver="N/A" npm_ver="N/A"

  # CPU model (Linux)
  if [ -r /proc/cpuinfo ]; then
    cpu_model=$(grep -m1 'model name' /proc/cpuinfo 2>/dev/null | cut -d: -f2- | sed 's/^ *//')
  fi
  [ -z "$cpu_model" ] && cpu_model="Unknown CPU"

  # CPU usage (Linux) computed from /proc/stat delta
  if [ -r /proc/stat ]; then
    read -r _ u1 n1 s1 i1 w1 q1 sq1 st1 _ _ < /proc/stat
    sleep 0.3
    read -r _ u2 n2 s2 i2 w2 q2 sq2 st2 _ _ < /proc/stat
    total1=$((u1+n1+s1+i1+w1+q1+sq1+st1))
    total2=$((u2+n2+s2+i2+w2+q2+sq2+st2))
    diff_total=$((total2-total1))
    diff_idle=$(((i2+w2)-(i1+w1)))
    if [ "$diff_total" -gt 0 ]; then
      cpu_usage_pct=$(( (1000 * (diff_total - diff_idle) / diff_total + 5) / 10 ))
    fi
  fi
  [ -z "$cpu_usage_pct" ] && cpu_usage_pct="N/A" || cpu_usage_pct="${cpu_usage_pct}%"

  # Memory usage (Linux)
  if [ -r /proc/meminfo ]; then
    mem_total_kb=$(awk '/MemTotal:/ {print $2}' /proc/meminfo)
    mem_avail_kb=$(awk '/MemAvailable:/ {print $2}' /proc/meminfo)
    if [ -n "$mem_total_kb" ] && [ -n "$mem_avail_kb" ]; then
      mem_used_kb=$((mem_total_kb - mem_avail_kb))
      mem_used_pct=$(( (1000 * mem_used_kb / mem_total_kb + 5) / 10 ))
      mem_total_gib=$(awk -v kb="$mem_total_kb" 'BEGIN {printf "%.1f", kb/1024/1024}')
      mem_used_gib=$(awk -v kb="$mem_used_kb" 'BEGIN {printf "%.1f", kb/1024/1024}')
    fi
  fi

  [ -z "$mem_total_gib" ] && mem_total_gib="?" && mem_used_gib="?" && mem_used_pct="?"
  [ -n "$mem_used_pct" ] && mem_used_pct="${mem_used_pct}%"

  # Node & npm versions
  if command -v node >/dev/null 2>&1; then
    node_ver=$(node -v 2>/dev/null || echo N/A)
  fi
  if command -v npm >/dev/null 2>&1; then
    npm_ver=$(npm -v 2>/dev/null || echo N/A)
  fi

  # Prepare pretty box
  local line_cpu_model="CPU Model : ${cpu_model}"
  local line_node="Node.js   : ${node_ver}"
  local line_npm="npm       : ${npm_ver}"

  # Determine width (cap at 76) based only on content (no left '# ' prefix now)
  local width max=0
  for l in "$line_cpu_model" "$line_cpu_usage" "$line_mem" "$line_node" "$line_npm"; do
    [ ${#l} -gt $max ] && max=${#l}
  done
  [ $max -gt 76 ] && max=76
  width=$max

  local border=$(printf '%*s' "$width" '' | tr ' ' '#')
  echo "$border"
  printf '%-'$width's\n' "$line_cpu_model"
  printf '%-'$width's\n' "$line_node"
  printf '%-'$width's\n' "$line_npm"
  echo "$border"
  echo
}

print_system_box

if [ -n "${START_COMMAND1}" ]; then 
    eval "${START_COMMAND1}"
fi
if [ -n "${START_COMMAND2}" ]; then
    eval "${START_COMMAND2}"
fi