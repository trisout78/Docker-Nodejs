# Docker-Nodejs

Pre-built Node.js Docker images with common development tools and utilities.

## Available Images

The following Node.js versions are available:

- `ghcr.io/trisout78/nodejs_20:latest` - Node.js v20 (LTS)
- `ghcr.io/trisout78/nodejs_21:latest` - Node.js v21
- `ghcr.io/trisout78/nodejs_22:latest` - Node.js v22 (LTS)
- `ghcr.io/trisout78/nodejs_23:latest` - Node.js v23 (Current)
- `ghcr.io/trisout78/nodejs_24:latest` - Node.js v24 (Current)

## Features

Each image includes:

- Node.js (version-specific)
- npm (latest version)
- Common development tools: `git`, `python3`, `build-essential`, `make`, `gcc`, `g++`
- System utilities: `ffmpeg`, `iproute2`, `sqlite3`, `tzdata`, `ca-certificates`, `dnsutils`
- Dedicated `container` user for security
- Custom entrypoint scripts for flexible startup commands

## Usage

### Basic Usage

```bash
docker run -it ghcr.io/trisout78/nodejs_24:latest
```

### With Custom Start Commands

```bash
docker run -e START_COMMAND1="npm install" -e START_COMMAND2="npm start" ghcr.io/trisout78/nodejs_24:latest
```

### Volume Mounting

```bash
docker run -v $(pwd):/home/container/app -w /home/container/app ghcr.io/trisout78/nodejs_24:latest
```

## Making Packages Public

If you encounter "unauthorized" errors when pulling images, the packages need to be made public:

1. Go to [GitHub Packages](https://github.com/users/trisout78/packages)
2. Select the nodejs package you want to make public
3. Go to "Package settings"
4. Scroll down to "Danger Zone"
5. Click "Change visibility" and select "Public"

## Building Locally

To build the images locally:

```bash
# Build Node.js 24 image
docker build -t nodejs_24 -f 24/Dockerfile .

# Build all versions
for version in 20 21 22 23 24; do
  docker build -t nodejs_$version -f $version/Dockerfile .
done
```

## Environment Variables

- `START_COMMAND1`: First command to execute on startup
- `START_COMMAND2`: Second command to execute on startup
- `USER`: Set to `container`
- `HOME`: Set to `/home/container`
- `INTERNAL_IP`: Automatically set to container's internal IP

## Security

- Images run as non-root user `container`
- Working directory is `/home/container`
- No sensitive data included in images
