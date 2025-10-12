# FPGA Toolchain Docker Image
FROM ubuntu:22.04

# Prevent interactive prompts during package installation
ENV DEBIAN_FRONTEND=noninteractive

# Install dependencies for Fusesoc and Icarus Verilog
# and upgrade CMake to a version required by nextpnr
RUN apt-get update && apt-get install -y \
    wget \
    gpg \
    software-properties-common && \
    wget -O - https://apt.kitware.com/keys/kitware-archive-latest.asc | gpg --dearmor - | tee /etc/apt/trusted.gpg.d/kitware.gpg >/dev/null && \
    echo 'deb https://apt.kitware.com/ubuntu/ jammy main' | tee /etc/apt/sources.list.d/kitware.list >/dev/null && \
    apt-get update && \
    apt-get install -y \
    python3 \
    python3-pip \
    python3-dev \
    git \
    autoconf \
    gperf \
    bison \
    flex \
    build-essential \
    cmake \
    gtkwave \
    ghdl \
    verilator \
    libboost-all-dev \
    libeigen3-dev \
    qtcreator \
    qtbase5-dev \
    qt5-qmake \
    libftdi1-dev \
    libhidapi-dev \
    libudev-dev \
    zlib1g-dev \
    && rm -rf /var/lib/apt/lists/*

# Install Fusesoc system-wide
RUN pip3 install --upgrade fusesoc

# Install apycula
RUN pip3 install apycula

# Add the user's local bin directory to the PATH to make apycula's tools available
ENV PATH="/root/.local/bin:${PATH}"

# Build and install Icarus Verilog from source
RUN git clone https://github.com/steveicarus/iverilog.git && \
    cd iverilog && \
    git checkout --track -b v11-branch origin/v11-branch && \
    sh autoconf.sh && \
    ./configure && \
    make -j$(nproc) && \
    make install

# Download and install oss-cad-suite
RUN wget https://github.com/YosysHQ/oss-cad-suite-build/releases/download/2025-10-12/oss-cad-suite-linux-x64-20251012.tgz -O oss-cad-suite.tgz && \
    mkdir -p /opt/oss-cad-suite && \
    tar -xvf oss-cad-suite.tgz -C /opt/oss-cad-suite --strip-components=1 && \
    rm oss-cad-suite.tgz

# Add oss-cad-suite to the PATH
ENV PATH="/opt/oss-cad-suite/bin:${PATH}"

# Build and install nextpnr-himbaechel
RUN git clone https://github.com/YosysHQ/nextpnr.git nextpnr-himbaechel && \
    cd nextpnr-himbaechel && \
    git submodule update --init --recursive && \
    mkdir -p build && \
    cd build && \
    cmake .. -DARCH="himbaechel" -DHIMBAECHEL_UARCH="gowin" -DBUILD_GUI=ON && \
    make -j$(nproc) && \
    make install

# Build and install openFPGALoader from source
RUN git clone https://github.com/trabucayre/openFPGALoader.git && \
    cd openFPGALoader && \
    mkdir build && \
    cd build && \
    cmake .. && \
    make -j$(nproc) && \
    make install
