# Tang Nano FPGA Toolchain Docker Image
FROM ubuntu:22.04

# Prevent interactive prompts during package installation
ENV DEBIAN_FRONTEND=noninteractive

# Set working directory
WORKDIR /root

# Install all pre-requisites for the toolchain (following Ubuntu 22.04 setup instructions)
RUN apt-get update && apt-get install -y \
    make build-essential libssl-dev zlib1g-dev \
    libbz2-dev libreadline-dev libsqlite3-dev wget curl llvm \
    libncursesw5-dev xz-utils tk-dev libxml2-dev libxmlsec1-dev \
    libffi-dev liblzma-dev git cmake libboost-all-dev libeigen3-dev \
    libftdi1-2 libftdi1-dev libhidapi-hidraw0 libhidapi-dev \
    libudev-dev zlib1g-dev pkg-config g++ clang bison flex \
    gawk tcl-dev graphviz xdot pkg-config zlib1g-dev \
    && rm -rf /var/lib/apt/lists/*

# Install pyenv
RUN curl https://pyenv.run | bash && \
    echo 'export PYENV_ROOT="$HOME/.pyenv"' >> ~/.bashrc && \
    echo 'export PATH="$PYENV_ROOT/bin:$PATH"' >> ~/.bashrc && \
    echo -e 'if command -v pyenv 1>/dev/null 2>&1; then\n eval "$(pyenv init -)"\nfi' >> ~/.bashrc

# Set pyenv environment variables for current session
ENV PYENV_ROOT="/root/.pyenv"
ENV PATH="$PYENV_ROOT/bin:$PATH"

# Install Python 3.9.13 using pyenv
RUN eval "$(pyenv init -)" && \
    pyenv install 3.9.13 && \
    pyenv global 3.9.13

# Install apycula
RUN eval "$(pyenv init -)" && pip install apycula

# Install yosys
RUN git clone https://github.com/YosysHQ/yosys.git && \
    cd yosys && \
    make && \
    make install

# Install nextpnr
RUN cd ~ && \
    git clone https://github.com/YosysHQ/nextpnr.git && \
    cd nextpnr && \
    cmake . -DARCH=gowin -DGOWIN_BBA_EXECUTABLE=`which gowin_bba` && \
    make && \
    make install

# Install openFPGALoader
RUN cd ~ && \
    git clone https://github.com/trabucayre/openFPGALoader.git && \
    cd openFPGALoader && \
    mkdir build && \
    cd build && \
    cmake ../ && \
    cmake --build . && \
    make install

# Set up environment variables and ensure tools are in PATH
ENV PATH="/usr/local/bin:$PYENV_ROOT/shims:$PYENV_ROOT/bin:${PATH}"

# Create a non-root user for running the tools
RUN useradd -m -s /bin/bash fpga

USER fpga
WORKDIR /home/fpga

# Set up user environment
RUN echo 'export PYENV_ROOT="$HOME/.pyenv"' >> ~/.bashrc && \
    echo 'export PATH="$PYENV_ROOT/bin:$PATH"' >> ~/.bashrc && \
    echo -e 'if command -v pyenv 1>/dev/null 2>&1; then\n eval "$(pyenv init -)"\nfi' >> ~/.bashrc && \
    echo 'alias ll="ls -la"' >> ~/.bashrc && \
    echo 'export PATH="/usr/local/bin:${PATH}"' >> ~/.bashrc

# Set the default command
CMD ["/bin/bash"]

# Labels for documentation
LABEL maintainer="Jose Mendonca <zelumendonca@gmail.com>"
LABEL description="FPGA Toolchain for Tang Nano boards with Yosys, nextpnr, and openFPGALoader"
LABEL version="1.0.5"