#!/bin/bash
# Profil: Apple Mac M3 Max
# Hardware: Apple Silicon M3 Max mit Unified Memory

export PROFILE_NAME="mac-m3-max"
export GPU_MODEL="Apple M3 Max GPU"
export VRAM_MB=0  # Unified Memory
export RAM_GB=128

# Modell - kann 405B mit Metal-Backend
export MODEL_PATH="/path/to/model.gguf"
export MODEL_NAME="llama-3.1-405b-q4_k_m"

# Server-Parameter - Metal optimiert
export GPU_LAYERS=99
export CPU_MOE=0
export CONTEXT_SIZE=131072
export THREADS=12
export BATCH_THREADS=12
export BATCH_SIZE=32768
export UBATCH_SIZE=4096
export PARALLEL=4

# KV-Cache
export CACHE_K=q8_0
export CACHE_V=q8_0

# Features (Metal-spezifisch)
export FLASH_ATTN=1
export MLOCK=0
export JINJA=1

# Metal Backend
export LLAMA_METAL=1

echo "Profil geladen: $PROFILE_NAME (Mac M3 Max, $RAM_GB GB Unified Memory)"
