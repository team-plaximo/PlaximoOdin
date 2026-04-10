#!/bin/bash
# PlaximoOdin - LLM Server Starter

MODEL="${1:-models/default.gguf}"
PORT="${2:-8080}"
CTX_SIZE="${3:-4096}"
GPU_LAYERS="${4:-99}"

cd ~/llama.cpp/build/bin

./llama-server \
    -m "$MODEL" \
    -c "$CTX_SIZE" \
    -ngl "$GPU_LAYERS" \
    --host 0.0.0.0 \
    --port "$PORT" \
    --log-format json
