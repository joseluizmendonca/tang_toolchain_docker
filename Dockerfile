# Tang Nano FPGA Toolchain Docker Image
FROM ubuntu:22.04

# Prevent interactive prompts during package installation
ENV DEBIAN_FRONTEND=noninteractive

# Set working directory
WORKDIR /workspace

# Update package lists and install all required dependencies
RUN apt-get update && apt-get install -y \
    make \
    build-essential \
    libssl-dev \
    zlib1g-dev \
    libbz2-dev \
    libreadline-dev \
    libsqlite3-dev \
    wget \
    curl \
    llvm \
    libncursesw5-dev \
    xz-utils \
    tk-dev \
    libxml2-dev \
    libxmlsec1-dev \
    libffi-dev \
    liblzma-dev \
    git \
    cmake \
    libboost-all-dev \
    libeigen3-dev \
    libftdi1-2 \
    libftdi1-dev \
    libhidapi-hidraw0 \
    libhidapi-dev \
    libudev-dev \
    pkg-config \
    g++ \
    clang \
    bison \
    flex \
    gawk \
    tcl-dev \
    graphviz \
    xdot \
    python3 \
    python3-pip \
    python3-dev \
    && rm -rf /var/lib/apt/lists/*

# Install Python 3.9 (Ubuntu 22.04 comes with Python 3.10, but we'll use pip for apycula)
# Since we're in Docker, we'll use the system Python and just install apycula
RUN pip3 install apycula

# Copy the entire project (including submodules) into the container
COPY . /workspace/

# Build Yosys
WORKDIR /workspace/yosys
RUN make -j$(nproc) && make install

# Build nextpnr
WORKDIR /workspace/nextpnr
RUN cmake . -DARCH=gowin -DGOWIN_BBA_EXECUTABLE=$(which gowin_bba) && \
    make -j$(nproc) && \
    make install

# Build openFPGALoader
WORKDIR /workspace/openFPGALoader
RUN mkdir -p build && \
    cd build && \
    cmake ../ && \
    cmake --build . -j$(nproc) && \
    make install

# Set up environment variables
ENV PATH="/usr/local/bin:${PATH}"

# Create a non-root user for running the tools
RUN useradd -m -s /bin/bash fpga && \
    chown -R fpga:fpga /workspace

USER fpga
WORKDIR /home/fpga

# Add helpful aliases and environment setup
RUN echo 'alias ll="ls -la"' >> ~/.bashrc && \
    echo 'export PATH="/usr/local/bin:${PATH}"' >> ~/.bashrc

# Set the default command
CMD ["/bin/bash"]

# Labels for documentation
LABEL maintainer="Jose Mendonca <zelumendonca@gmail.com>"
LABEL description="FPGA Toolchain for Tang Nano boards with Yosys, nextpnr, and openFPGALoader"
LABEL version="1.0"