# PlaximoOdin - Dockerfile für llama-server

FROM nvidia/cuda:12.4.0-devel-ubuntu22.04

ENV DEBIAN_FRONTEND=noninteractive
ENV CUDA_HOME=/usr/local/cuda

# System dependencies
RUN apt-get update && apt-get install -y \
    git \
    build-essential \
    cmake \
    python3 \
    python3-pip \
    python3-venv \
    curl \
    && rm -rf /var/lib/apt/lists/*

# Build llama.cpp
WORKDIR /build
RUN git clone https://github.com/ggerganov/llama.cpp.git . && \
    mkdir build && cd build && \
    cmake .. -DGGML_CUDA=ON -DCMAKE_BUILD_TYPE=Release && \
    make -j$(nproc) llama-server && \
    cp llama-server /usr/local/bin/ && \
    cd / && rm -rf /build

# Create app directory
WORKDIR /app

# Copy entrypoint script
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# Expose port
EXPOSE 8080

# Health check
HEALTHCHECK --interval=30s --timeout=10s --start-period=60s --retries=3 \
    CMD curl -f http://localhost:8080/health || exit 1

ENTRYPOINT ["/entrypoint.sh"]
