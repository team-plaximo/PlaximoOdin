#!/bin/bash
# PlaximoOdin - LLM Server Starter
# Usage: ./start-server.sh [model_path] [port] [context_size] [cpu_moe]

MODEL="${1:-/home/plaximo/unsloth/Qwen3.5-35B-A3B-GGUF/Qwen3.5-35B-A3B-Q4_K_M.gguf}"
PORT="${2:-8080}"
CTX_SIZE="${3:-32768}"
CPU_MOE="${4:-36}"

THREADS=6

cd ~/llama.cpp/build/bin

echo "Starting llama-server..."
echo "Model: $MODEL"
echo "Context: $CTX_SIZE"
echo "CPU MoE Layers: $CPU_MOE"
echo ""

./llama-server \
    -m "$MODEL" \
    -ngl 99 \
    --n-cpu-moe "$CPU_MOE" \
    -c "$CTX_SIZE" \
    -t "$THREADS" \
    -tb "$THREADS" \
    -b 8192 \
    -ub 512 \
    --cache-type-k q4_0 \
    --cache-type-v q4_0 \
    --parallel 1 \
    --flash-attn \
    --mlock \
    --jinja \
    --host 0.0.0.0 \
    --port "$PORT"
