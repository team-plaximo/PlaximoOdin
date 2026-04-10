#!/bin/bash
# Profil: CPU-only (Server ohne GPU)
# Hardware: Beliebige CPU + 32+ GB RAM

export PROFILE_NAME="cpu-only"
export GPU_MODEL="None"
export VRAM_MB=0
export RAM_GB=32

# Modell - maximal 13B für CPU-only
export MODEL_PATH="/path/to/llama-3.2-3b-q4_k_m.gguf"
export MODEL_NAME="llama-3.2-3b-q4_k_m"

# Server-Parameter - CPU optimiert
export GPU_LAYERS=0
export CPU_MOE=0
export CONTEXT_SIZE=8192
export THREADS=16
export BATCH_THREADS=16
export BATCH_SIZE=4096
export UBATCH_SIZE=512
export PARALLEL=4

# KV-Cache
export CACHE_K=q4_0
export CACHE_V=q4_0

# Features
export FLASH_ATTN=0
export MLOCK=1
export JINJA=1

echo "Profil geladen: $PROFILE_NAME (CPU-only, $RAM_GB GB RAM)"
