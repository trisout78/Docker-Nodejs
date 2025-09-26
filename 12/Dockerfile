FROM        node:12-buster-slim

# Avoid interactive prompts during apt operations
ENV         DEBIAN_FRONTEND=noninteractive

# Configure archived Debian buster repositories (EOL)
RUN         echo 'Acquire::Check-Valid-Until "false";' > /etc/apt/apt.conf.d/99no-check-valid \
            && sed -i 's|deb.debian.org/debian|archive.debian.org/debian|g; s|security.debian.org|archive.debian.org|g' /etc/apt/sources.list \
            && sed -i '/buster-updates/d' /etc/apt/sources.list

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

# Create non-root user
RUN         useradd -m -d /home/container container

USER        container
ENV         USER=container HOME=/home/container
WORKDIR     /home/container

COPY        ./entrypoint.sh /entrypoint.sh
COPY        --chmod=777 ./start.sh /start.sh
CMD         [ "/bin/bash", "/entrypoint.sh" ]