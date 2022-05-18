echo running start.sh
eval ${start_command1}
if [ -n "${start_command2}" ]; then
    eval ${start_command2}
fi