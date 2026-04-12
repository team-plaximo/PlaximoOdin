#!/bin/bash
# PlaximoOdin - LLM Server Starter
# Modell:   Qwen3.5-35B-A3B Q4_K_M
# Hardware: RTX 4070 Laptop (8 GB VRAM) + 30 GB RAM
# Usage: ./start-server.sh [model_path] [port]

MODEL="${1:-/home/plaximo/unsloth/Qwen3.5-35B-A3B-GGUF/Qwen3.5-35B-A3B-Q4_K_M.gguf}"
PORT="${2:-8080}"

echo "Starting PlaximoOdin LLM Server..."
echo "  Model: $MODEL"
echo "  Port:  $PORT"
echo ""

~/llama.cpp/build/bin/llama-server \
    -m "$MODEL" \
    -ngl 99 \
    --n-cpu-moe 36 \
    -c 262144 \
    -t 12 \
    --cache-type-k q8_0 \
    --cache-type-v q4_0 \
    -b 8192 \
    -ub 1024 \
    --parallel 2 \
    --cache-reuse 256 \
    --flash-attn on \
    --jinja \
    --host 0.0.0.0 \
    --port "$PORT"
