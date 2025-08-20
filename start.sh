#!/usr/bin/env bash

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
  local cpu_model="" docker_cores="?" docker_mem_used_gib="?" docker_mem_total_gib="?" docker_mem_used_pct="?"
  local node_ver="N/A" npm_ver="N/A"

  # Docker VM info (Linux, using docker info)
  if command -v docker >/dev/null 2>&1; then
    # Get number of CPUs allocated to Docker
    docker_cores=$(docker info --format '{{.NCPU}}' 2>/dev/null)
    [ -z "$docker_cores" ] && docker_cores="?"

    # Get Docker VM memory (total and used)
    docker_mem_total_gib=$(docker info --format '{{.MemTotal}}' 2>/dev/null)
    # MemTotal is in bytes, convert to GiB
    if [ -n "$docker_mem_total_gib" ]; then
      docker_mem_total_gib=$(awk -v b="$docker_mem_total_gib" 'BEGIN {printf "%.1f", b/1024/1024/1024}')
    else
      docker_mem_total_gib="?"
    fi

    # Get used memory for all running containers (sum)
    docker_mem_used_bytes=$(docker stats --no-stream --format '{{.MemUsage}}' 2>/dev/null | awk -F'/' '{gsub(/[^0-9.]/, "", $1); sum+=$1} END {print sum}')
    if [ -n "$docker_mem_used_bytes" ]; then
      docker_mem_used_gib=$(awk -v b="$docker_mem_used_bytes" 'BEGIN {printf "%.1f", b/1024/1024}')
    else
      docker_mem_used_gib="?"
    fi

    if [ -n "$docker_mem_total_gib" ] && [ -n "$docker_mem_used_gib" ] && [ "$docker_mem_total_gib" != "?" ] && [ "$docker_mem_used_gib" != "?" ]; then
      docker_mem_used_pct=$(awk -v u="$docker_mem_used_gib" -v t="$docker_mem_total_gib" 'BEGIN {if (t>0) printf "%d", (1000*u/t+5)/10; else print "?"}')
    else
      docker_mem_used_pct="?"
    fi
  fi
  [ -n "$docker_mem_used_pct" ] && docker_mem_used_pct="${docker_mem_used_pct}%"

  # Node & npm versions
  if command -v node >/dev/null 2>&1; then
    node_ver=$(node -v 2>/dev/null || echo N/A)
  fi
  if command -v npm >/dev/null 2>&1; then
    npm_ver=$(npm -v 2>/dev/null || echo N/A)
  fi

  # Prepare pretty box
  local line_cpu_model="CPU Model : ${cpu_model}"
  local line_docker_cores="Docker VM Cores : ${docker_cores}"
  local line_docker_mem="Docker VM Memory : ${docker_mem_used_gib}G / ${docker_mem_total_gib}G (${docker_mem_used_pct})"
  local line_node="Node.js   : ${node_ver}"
  local line_npm="npm       : ${npm_ver}"

  # Determine width (cap at 76) based only on content
  local width max=0
  for l in "$line_cpu_model" "$line_docker_cores" "$line_docker_mem" "$line_node" "$line_npm"; do
    [ ${#l} -gt $max ] && max=${#l}
  done
  [ $max -gt 76 ] && max=76
  width=$max

  local border=$(printf '%*s' "$width" '' | tr ' ' '#')
  echo "$border"
  printf '%-'$width's\n' "$line_cpu_model"
  printf '%-'$width's\n' "$line_docker_cores"
  printf '%-'$width's\n' "$line_docker_mem"
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