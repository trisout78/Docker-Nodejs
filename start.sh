#!/usr/bin/env bash

# Banner ASCII TRISOUT
cat <<'BANNER'
 _____     _                 _   
|_   _| __(_)___  ___  _   _| |_ 
  | || '__| / __|/ _ \| | | | __|
  | || |  | \__ \ (_) | |_| | |_ 
  |_||_|  |_|___/\___/ \__,_|\__|
                                 
BANNER

###############################################################################
# System usage (CPU & Memory)
###############################################################################

print_system_box() {
  local cpu_model="" cpu_usage_pct="" mem_total_kb="" mem_avail_kb="" mem_used_kb="" mem_used_pct="" mem_total_gib="" mem_used_gib=""

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

  # Prepare pretty box
  local line_cpu_model="CPU Model : ${cpu_model}"
  local line_cpu_usage="CPU Usage : ${cpu_usage_pct}"
  local line_mem="Memory    : ${mem_used_gib}G / ${mem_total_gib}G (${mem_used_pct})"

  # Determine width (cap at 76)
  local width max=0
  for l in "$line_cpu_model" "$line_cpu_usage" "$line_mem"; do
    [ ${#l} -gt $max ] && max=${#l}
  done
  [ $max -gt 76 ] && max=76
  width=$((max + 2))

  local border=$(printf '%*s' "$width" '' | tr ' ' '#')
  echo "$border"
  printf '# %-'$((width - 3))'s#\n' "$line_cpu_model"
  printf '# %-'$((width - 3))'s#\n' "$line_cpu_usage"
  printf '# %-'$((width - 3))'s#\n' "$line_mem"
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