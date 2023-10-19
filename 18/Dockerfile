FROM        node:18-buster-slim

RUN         apt update \
            && apt -y install ffmpeg iproute2 git sqlite3 python3 tzdata ca-certificates dnsutils build-essential make gcc g++ \
            && npm -g install npm@latest \
            && npm install -g pnpm \ 
            && useradd -m -d /home/container container

USER        container
ENV         USER=container HOME=/home/container
WORKDIR     /home/container

COPY        ./entrypoint.sh /entrypoint.sh
COPY        --chmod=777 ./start.sh /start.sh
CMD         [ "/bin/bash", "/entrypoint.sh" ]