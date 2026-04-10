#!/bin/bash
# Profil: RTX 4070 Laptop (PlaximoOdin)
# Hardware: NVIDIA RTX 4070 Mobile 8GB + AMD Ryzen 7 7840HS + 30 GB RAM

export PROFILE_NAME="rtx-4070-laptop"
export GPU_MODEL="NVIDIA RTX 4070 Laptop GPU"
export VRAM_MB=8188
export RAM_GB=30

# Modell (Qwen3.5-35B-A3B MoE)
export MODEL_PATH="/home/plaximo/unsloth/Qwen3.5-35B-A3B-GGUF/Qwen3.5-35B-A3B-Q4_K_M.gguf"
export MODEL_NAME="Qwen3.5-35B-A3B-Q4_K_M"

# Server-Parameter
export GPU_LAYERS=99
export CPU_MOE=24
export CONTEXT_SIZE=32768
export THREADS=10
export BATCH_THREADS=12
export BATCH_SIZE=16384
export UBATCH_SIZE=2048
export PARALLEL=2

# KV-Cache
export CACHE_K=q8_0
export CACHE_V=q4_0

# Features
export FLASH_ATTN=1
export MLOCK=1
export JINJA=1

echo "Profil geladen: $PROFILE_NAME ($GPU_MODEL, $VRAM_MB MB VRAM, $RAM_GB GB RAM)"
