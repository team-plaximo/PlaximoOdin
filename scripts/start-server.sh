#!/bin/bash
# PlaximoOdin - LLM Server Starter
# Modell:   Qwen3.5-35B-A3B Q4_K_M
# Hardware: RTX 4070 Laptop (8 GB VRAM) + 30 GB RAM
# Usage: ./start-server.sh [model_path] [port]

MODEL="${1:-/home/plaximo/unsloth/Qwen3.5-35B-A3B-GGUF/Qwen3.5-35B-A3B-Q4_K_M.gguf}"
PORT="${2:-8080}"

# 2 parallele Slots x 131.072 Token = 262.144 Token total (Modell-Maximum)
CTX_SIZE=262144
PARALLEL=2

# GPU: alle Dense-Layer in VRAM, MoE-Experts in RAM
GPU_LAYERS=99
CPU_MOE=36

# CPU: Ryzen 7 7840HS (16 Threads)
THREADS=10
BATCH_THREADS=12

# Batch: gross genug fuer GPU-Offload-Trigger bei MoE
BATCH_SIZE=16384
UBATCH_SIZE=2048

# KV-Cache: q4_0 wegen hohem Context-Bedarf (2x131K = ~13 GB KV allein)
CACHE_K=q4_0
CACHE_V=q4_0

cd ~/llama.cpp/build/bin

echo "Starting PlaximoOdin LLM Server..."
echo "  Model:    $MODEL"
echo "  Port:     $PORT"
echo "  Context:  $CTX_SIZE Token ($PARALLEL Slots x 131072)"
echo "  GPU:      $GPU_LAYERS Layer | MoE CPU: $CPU_MOE Layer"
echo ""

./llama-server \
    -m "$MODEL" \
    --host 0.0.0.0 \
    --port "$PORT" \
    -c "$CTX_SIZE" \
    --parallel "$PARALLEL" \
    -ngl "$GPU_LAYERS" \
    --n-cpu-moe "$CPU_MOE" \
    -t "$THREADS" \
    --threads-batch "$BATCH_THREADS" \
    -b "$BATCH_SIZE" \
    -ub "$UBATCH_SIZE" \
    --cache-type-k "$CACHE_K" \
    --cache-type-v "$CACHE_V" \
    --flash-attn \
    --mlock \
    --jinja \
    --log-format json
