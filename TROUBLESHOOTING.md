# Troubleshooting Docker Authorization Issues

## Problem
When trying to pull Docker images from this repository, you may encounter:
```
Error response from daemon: Head "https://ghcr.io/v2/trisout78/nodejs_23/manifests/latest": unauthorized
```

## Root Cause
This error occurs because GitHub Container Registry packages are private by default, requiring authentication to pull.

## Solutions

### Option 1: Make Packages Public (Recommended)
Repository maintainers should make packages public to allow unrestricted access:

1. Visit [GitHub Packages](https://github.com/users/trisout78/packages)
2. Select each nodejs package
3. Go to Package settings → Change visibility → Public

### Option 2: Authenticate Docker with GitHub
If packages remain private, users need to authenticate:

```bash
# Login to GitHub Container Registry
echo $GITHUB_TOKEN | docker login ghcr.io -u USERNAME --password-stdin

# Then pull the image
docker pull ghcr.io/trisout78/nodejs_23:latest
```

### Option 3: Use Docker Hub Alternative
Consider publishing public images to Docker Hub for easier access:

```bash
docker pull trisout78/nodejs:23
```

## Verification
After making packages public, test without authentication:

```bash
# This should work without docker login
docker pull ghcr.io/trisout78/nodejs_23:latest
```

## GitHub Actions Improvements
The workflow has been updated to:
- Use `GITHUB_TOKEN` instead of custom secrets
- Include proper permissions for package publishing
- Use latest action versions
- Support multi-architecture builds (amd64, arm64)

## For Repository Maintainers
Run the included helper script:
```bash
./setup-public-packages.sh
```

This provides step-by-step instructions for making packages public.