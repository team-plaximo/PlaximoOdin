#!/bin/bash
# PlaximoOdin - Optimierter Server Starter
# Basierend auf: https://github.com/ggml-org/llama.cpp/issues/xxxx

MODEL="${1:-/home/plaximo/unsloth/Qwen3.5-35B-A3B-GGUF/Qwen3.5-35B-A3B-Q4_K_M.gguf}"
PORT="${2:-8080}"
CTX_SIZE="${3:-32768}"
CPU_MOE="${4:-24}"  # Reduziert von 36 → mehr MoE in VRAM

THREADS=10          # Erhöht: Ryzen 7 7840HS hat 16 Threads
BATCH_THREADS=12    # Batch-Threads getrennt
BATCH_SIZE=16384    # Erhöht: besseres GPU-Offload Prompt-Processing
UBATCH_SIZE=2048    # Erhöht: größere Physical Batch

cd ~/llama.cpp/build/bin

echo "═══════════════════════════════════════════════════════════"
echo "  PlaximoOdin - Optimierter LLM Server"
echo "═══════════════════════════════════════════════════════════"
echo "Model:    $MODEL"
echo "Context:  $CTX_SIZE"
echo "CPU MoE:  $CPU_MOE (24 = mehr in VRAM)"
echo "Threads:  $THREADS"
echo "Batch:    $BATCH_SIZE / $UBATCH_SIZE"
echo "═══════════════════════════════════════════════════════════"
echo ""

./llama-server \
    -m "$MODEL" \
    -ngl 99 \
    --n-cpu-moe "$CPU_MOE" \
    -c "$CTX_SIZE" \
    -t "$THREADS" \
    -tb "$BATCH_THREADS" \
    -b "$BATCH_SIZE" \
    -ub "$UBATCH_SIZE" \
    --cache-type-k q8_0 \
    --cache-type-v q4_0 \
    --parallel 2 \
    --flash-attn \
    --mlock \
    --jinja \
    --host 0.0.0.0 \
    --port "$PORT"
