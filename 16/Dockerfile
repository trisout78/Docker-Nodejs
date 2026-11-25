FROM        node:16-bullseye-slim

# Node.js 16 is end-of-life and blocked: start.sh prints a vulnerability warning
# and exits with code 1. No extra packages on purpose, so the build never
# depends on (possibly archived) Debian mirrors.

# Create non-root user
RUN         useradd -m -d /home/container container

USER        container
ENV         USER=container HOME=/home/container
WORKDIR     /home/container

COPY        ./entrypoint.sh /entrypoint.sh
COPY        --chmod=777 ./start.sh /start.sh
CMD         [ "/bin/bash", "/entrypoint.sh" ]
