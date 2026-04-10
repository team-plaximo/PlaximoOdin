#!/bin/bash
# Profil: RTX 4090 Desktop
# Hardware: NVIDIA RTX 4090 24GB + High-End CPU + 64 GB RAM

export PROFILE_NAME="rtx-4090-desktop"
export GPU_MODEL="NVIDIA RTX 4090"
export VRAM_MB=24576
export RAM_GB=64

# Modell (könnte 405B mit Q4_K_M sein)
export MODEL_PATH="/path/to/model.gguf"
export MODEL_NAME="llama-3.1-405b-q4_k_m"

# Server-Parameter - RTX 4090 kann fast alles auf GPU
export GPU_LAYERS=99
export CPU_MOE=0
export CONTEXT_SIZE=131072
export THREADS=16
export BATCH_THREADS=16
export BATCH_SIZE=32768
export UBATCH_SIZE=8192
export PARALLEL=4

# KV-Cache
export CACHE_K=q8_0
export CACHE_V=q8_0

# Features
export FLASH_ATTN=1
export MLOCK=1
export JINJA=1

echo "Profil geladen: $PROFILE_NAME ($GPU_MODEL, $VRAM_MB MB VRAM, $RAM_GB GB RAM)"
