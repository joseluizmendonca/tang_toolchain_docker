#!/bin/bash

# Build script for Tang Nano FPGA Toolchain Docker image

set -e

IMAGE_NAME="tang-toolchain"
IMAGE_TAG="latest"

echo "Building Tang Nano FPGA Toolchain Docker image..."
echo "This may take a while as it needs to compile Yosys, nextpnr, and openFPGALoader..."

# Build the Docker image
docker build -t "${IMAGE_NAME}:${IMAGE_TAG}" .

echo ""
echo "Build completed successfully!"
echo ""
echo "To run the container:"
echo "  docker run -it --rm ${IMAGE_NAME}:${IMAGE_TAG}"
echo ""
echo "To run with volume mounting (recommended for projects):"
echo "  docker run -it --rm -v \$(pwd)/projects:/home/fpga/projects ${IMAGE_NAME}:${IMAGE_TAG}"
echo ""
echo "To check if tools are working:"
echo "  docker run -it --rm ${IMAGE_NAME}:${IMAGE_TAG} bash -c 'yosys -V && nextpnr-gowin --version && openFPGALoader --help | head -5'"
