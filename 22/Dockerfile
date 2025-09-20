FROM        node:22-bookworm-slim

RUN         apt update \
            && apt -y install ffmpeg iproute2 git sqlite3 python3 tzdata ca-certificates cmake dnsutils build-essential make gcc g++ fonts-arkpandora libmagick++-dev libvips-dev libzxing-dev \
            && npm config set strict-ssl false \
            && npm install -g npm@latest \
            && npm install -g pnpm@latest \
            && useradd -m -d /home/container container

USER        container
ENV         USER=container HOME=/home/container
WORKDIR     /home/container

COPY        ./entrypoint.sh /entrypoint.sh
COPY        --chmod=777 ./start.sh /start.sh
CMD         [ "/bin/bash", "/entrypoint.sh" ]
