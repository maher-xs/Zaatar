#!/usr/bin/env bash
# Build Zaatar image with podman. Use if 'just' is not installed.
# Requires: podman (brew install podman)
set -e

IMAGE_NAME="${IMAGE_NAME:-zaatar}"
TAG="${TAG:-latest}"

echo "Building $IMAGE_NAME:$TAG..."
podman build --pull=newer --tag "${IMAGE_NAME}:${TAG}" .

echo "Done. Run: podman run -it ${IMAGE_NAME}:${TAG} bash"
