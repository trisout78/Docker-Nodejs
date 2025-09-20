FROM        node:22-bookworm-slim

# Set environment variables to avoid interactive prompts
ENV         DEBIAN_FRONTEND=noninteractive

# Install basic packages first
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

# Install development libraries separately
RUN         apt-get update \
            && apt-get install -y --no-install-recommends \
                libmagick++-dev \
                libvips-dev \
                libzxing-dev \
            && apt-get clean \
            && rm -rf /var/lib/apt/lists/*

# Install alternative fonts that don't require EULA acceptance
RUN         apt-get update \
            && apt-get install -y --no-install-recommends \
                fonts-liberation \
                fonts-dejavu-core \
                fontconfig \
            && apt-get clean \
            && rm -rf /var/lib/apt/lists/*

# Configure npm and install global packages
RUN         npm config set strict-ssl false \
            && npm install -g npm@latest \
            && npm install -g pnpm@latest-10

# Create container user
RUN         useradd -m -d /home/container container

USER        container
ENV         USER=container HOME=/home/container
WORKDIR     /home/container

COPY        ./entrypoint.sh /entrypoint.sh
COPY        --chmod=777 ./start.sh /start.sh
CMD         [ "/bin/bash", "/entrypoint.sh" ]
