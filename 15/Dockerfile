FROM        node:15-bookworm-slim

# Avoid interactive prompts during apt operations
ENV         DEBIAN_FRONTEND=noninteractive

# Base system packages
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
            && apt-get clean \
            && rm -rf /var/lib/apt/lists/*

# Development libraries
RUN         apt-get update \
            && apt-get install -y --no-install-recommends \
                libmagick++-dev \
                libvips-dev \
                libzxing-dev \
            && apt-get clean \
            && rm -rf /var/lib/apt/lists/*

# Fonts without EULA requirements
RUN         apt-get update \
            && apt-get install -y --no-install-recommends \
                fonts-liberation \
                fonts-dejavu-core \
                fontconfig \
            && apt-get clean \
            && rm -rf /var/lib/apt/lists/*

# Node package managers
RUN         npm config set strict-ssl false \
            && npm install -g npm@latest \
            && npm install -g pnpm@latest-10

# Create non-root user
RUN         useradd -m -d /home/container container

USER        container
ENV         USER=container HOME=/home/container
WORKDIR     /home/container

COPY        ./entrypoint.sh /entrypoint.sh
COPY        --chmod=777 ./start.sh /start.sh
CMD         [ "/bin/bash", "/entrypoint.sh" ]