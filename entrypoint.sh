#!/bin/bash
cd /home/container || exit 1

# Configure colors
CYAN='\033[0;36m'
RESET_COLOR='\033[0m'

# Set environment variable that holds the Internal Docker IP
INTERNAL_IP=$(ip route get 1 | awk '{print $(NF-2);exit}')
export INTERNAL_IP

# Print Node.js Version
node -v

# Replace Startup Variables
# shellcheck disable=SC2086
echo -e "${CYAN}STARTUP /home/container: ./start.sh ${RESET_COLOR}"
# Run the Server
# shellcheck disable=SC2086

clear

sleep 1.5

echo -e "\e[92m* \e[39m[\e[94mINFO\e[39m] Server \e[4m\e[95mStats\e[39m\e[0m"

echo -e ""

sleep 1.5

echo -e "\e[92m* \e[39m[\e[92mSTATS\e[39m] RAM ->  \e[4m\e[95m"${SERVER_MEMORY}

sleep 1

echo -e "\e[92m* \e[39m[\e[92mSTATS\e[39m] LOCATION ->  \e[4m\e[95m"${P_SERVER_LOCATION}

sleep 1

echo -e "\e[92m* \e[39m[\e[92mSTATS\e[39m] SERVER ID ->  \e[4m\e[95m"${P_SERVER_UUID}

sleep 1

echo -e "\e[92m* \e[39m[\e[92mSTATS\e[39m] SERVER IP ->  \e[4m\e[95m"${SERVER_IP}

sleep 1

echo -e "\e[92m* \e[39m[\e[92mSTATS\e[39m] SERVER PORT ->  \e[4m\e[95m"${SERVER_PORT}




eval 'start.sh'