# PlaximoOdin - Development Environment
# Für Entwicklung mit VSCode Remote Container

FROM ubuntu:24.04

ENV DEBIAN_FRONTEND=noninteractive

# System
RUN apt-get update && apt-get install -y \
    git \
    build-essential \
    cmake \
    curl \
    wget \
    htop \
    tmux \
    vim \
    python3 \
    python3-pip \
    python3-venv \
    && rm -rf /var/lib/apt/lists/*

# CUDA
ENV CUDA_HOME=/usr/local/cuda
ENV PATH=$CUDA_HOME/bin:$PATH
ENV LD_LIBRARY_PATH=$CUDA_HOME/lib64:$LD_LIBRARY_PATH

# Python Development
WORKDIR /workspace
COPY requirements-dev.txt /workspace/
RUN pip install -r requirements-dev.txt

# llama.cpp (vorinstalliert, aber nicht gebaut)
RUN git clone --depth 1 https://github.com/ggerganov/llama.cpp.git /opt/llama.cpp

# OpenCode
RUN curl -fsSL https://opencode.ai/install | bash

# SSH für Remote Development
RUN apt-get update && apt-get install -y openssh-server
RUN mkdir /var/run/sshd
RUN echo 'PermitRootLogin no' >> /etc/ssh/sshd_config
RUN echo 'PasswordAuthentication no' >> /etc/ssh/sshd_config

EXPOSE 22 8080

CMD ["/bin/bash"]
