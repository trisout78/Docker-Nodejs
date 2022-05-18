echo running start.sh

# if [ -n "${START_COMMAND1}" ]; then 
#     eval "${START_COMMAND1}"
# fi
eval ${START_COMMAND1}
if [ -n "${START_COMMAND2}" ]; then
    eval ${START_COMMAND2}
fi