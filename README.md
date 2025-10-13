# Tang Nano FPGA Docker Environment

## Purpose

This repository provides a containerized development environment for FPGA development targeting Tang Nano boards. It includes a set of open-source tools pre-installed in a Docker image to avoid complex local setup.

## Included Tools

The Docker image contains the following tools:

*   **Synthesis & Place-and-Route:**
    *   **Yosys**: Verilog RTL synthesis.
    *   **nextpnr-himbaechel**: Place-and-route tool for Gowin FPGAs.
*   **Simulation & Verification:**
    *   **Icarus Verilog**: Verilog simulation and synthesis.
    *   **Verilator**: Verilog/SystemVerilog simulator.
    *   **GHDL**: VHDL simulator.
*   **Programming & Debugging:**
    *   **OpenFPGALoader**: Utility for programming FPGAs.
*   **Toolchain Management:**
    *   **oss-cad-suite**: Open-source CAD suite for FPGA development.
    *   **Fusesoc**: Package manager and build system for HDL projects.
*   **Waveform Viewing:**
    *   **GTKWave**: Waveform viewer.
*   **Gowin-specific Tools:**
    *   **Apycula**: Tools for Gowin FPGAs.

## Getting Started

This project uses Docker Compose to manage the build and run process.

### Prerequisites

*   [Docker](https://docs.docker.com/get-docker/)
*   [Docker Compose](https://docs.docker.com/compose/install/)

### Build the Docker Image

Run the build script:

```bash
./build.sh
```

This executes the `Dockerfile` and creates the `tang-toolchain:latest` image.

### Run the Development Environment

Start the container using Docker Compose:

```bash
docker compose -f docker-compose.yml up
```

### Access the Container

Get an interactive shell inside the running container:

```bash
docker exec -it fpga-toolchain bash
```

You will be logged in as the `fpga` user with all tools available in your `PATH`.

### Example Project

This repository includes an example project from [sifferman/tangnano_example](https://github.com/sifferman/tangnano_example) in the `src/` directory.

The `docker-compose.yml` mounts the local `src/` directory to `/home/fpga/src` inside the container. Changes made locally are reflected in the container.

Your work in the `src` and `projects` directories will be preserved locally.
