#!/bin/bash
# PlaximoOdin - Docker Entry Point

set -e

# Default values
MODEL=${MODEL:-"/models/Qwen3.5-35B-A3B-Q4_K_M.gguf"}
GPU_LAYERS=${GPU_LAYERS:-99}
CPU_MOE=${CPU_MOE:-36}
CONTEXT_SIZE=${CONTEXT_SIZE:-32768}
THREADS=${THREADS:-6}
BATCH_SIZE=${BATCH_SIZE:-8192}
PARALLEL=${PARALLEL:-2}
PORT=${PORT:-8080}

echo "=========================================="
echo "  PlaximoOdin - Llama Server Docker"
echo "=========================================="
echo "Model:       $MODEL"
echo "GPU Layers:  $GPU_LAYERS"
echo "CPU MoE:     $CPU_MOE"
echo "Context:     $CONTEXT_SIZE"
echo "Threads:     $THREADS"
echo "Batch:       $BATCH_SIZE"
echo "Parallel:    $PARALLEL"
echo "Port:        $PORT"
echo "=========================================="

# Check if model exists
if [ ! -f "$MODEL" ]; then
    echo "WARNING: Model not found at $MODEL"
    echo "Mount model with: -v /path/to/models:/models"
fi

# Start server
exec llama-server \
    -m "$MODEL" \
    -ngl "$GPU_LAYERS" \
    --n-cpu-moe "$CPU_MOE" \
    -c "$CONTEXT_SIZE" \
    -t "$THREADS" \
    -b "$BATCH_SIZE" \
    --cache-type-k q4_0 \
    --cache-type-v q4_0 \
    --parallel "$PARALLEL" \
    --flash-attn \
    --mlock \
    --jinja \
    --host 0.0.0.0 \
    --port "$PORT"
