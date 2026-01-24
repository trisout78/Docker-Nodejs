FROM        node:16-bullseye-slim

# Avoid interactive prompts during apt operations
ENV         DEBIAN_FRONTEND=noninteractive

# Base system packages
RUN         apt-get update \
            && apt-get upgrade -y \
            && apt-get install -y --fix-missing --no-install-recommends \
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

# Node package managers (do not update npm on Node 16)
RUN         npm config set strict-ssl false \
            && npm install -g pnpm@latest-10

# Create non-root user
RUN         useradd -m -d /home/container container

USER        container
ENV         USER=container HOME=/home/container
WORKDIR     /home/container

COPY        ./entrypoint.sh /entrypoint.sh
COPY        --chmod=777 ./start.sh /start.sh
CMD         [ "/bin/bash", "/entrypoint.sh" ]