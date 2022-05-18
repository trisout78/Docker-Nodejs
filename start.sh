echo running start.sh
eval ${START_COMMAND1}
if [ -n "${START_COMMAND2}" ]; then
    eval ${START_COMMAND2}
fi