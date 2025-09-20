FROM        node:22-bookworm-slim

# Set environment variables to avoid interactive prompts
ENV         DEBIAN_FRONTEND=noninteractive

# Pre-accept Microsoft fonts EULA
RUN         echo "ttf-mscorefonts-installer msttcorefonts/accepted-mscorefonts-eula select true" | debconf-set-selections

RUN         apt-get update \
            && apt-get upgrade -y \
            && apt-get install -y --no-install-recommends \
                ffmpeg \
                iproute2 \
                git \
                sqlite3 \
                python3 \
                tzdata \
                ca-certificates \
                cmake \
                dnsutils \
                build-essential \
                make \
                gcc \
                g++ \
                ttf-mscorefonts-installer \
                libmagick++-dev \
                libvips-dev \
                libzxing-dev \
            && apt-get clean \
            && rm -rf /var/lib/apt/lists/* \
            && npm config set strict-ssl false \
            && npm install -g npm@latest \
            && npm install -g pnpm@latest-10 \
            && useradd -m -d /home/container container

USER        container
ENV         USER=container HOME=/home/container
WORKDIR     /home/container

COPY        ./entrypoint.sh /entrypoint.sh
COPY        --chmod=777 ./start.sh /start.sh
CMD         [ "/bin/bash", "/entrypoint.sh" ]
