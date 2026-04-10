#!/bin/bash
# PlaximoOdin - Server Starter mit Profil
# Usage: ./start-with-profile.sh rtx-4070-laptop

PROFILE="${1:-rtx-4070-laptop}"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROFILE_FILE="$SCRIPT_DIR/../config/profiles/${PROFILE}.sh"

if [ ! -f "$PROFILE_FILE" ]; then
    echo "Profil nicht gefunden: $PROFILE"
    echo "Verfügbare Profile:"
    ls -1 "$SCRIPT_DIR/../config/profiles/"*.sh | xargs -I {} basename {} .sh | grep -v README
    exit 1
fi

source "$PROFILE_FILE"

cd ~/llama.cpp/build/bin

echo "═══════════════════════════════════════════════════════════"
echo "  PlaximoOdin Server - Profil: $PROFILE_NAME"
echo "═══════════════════════════════════════════════════════════"
echo "Modell:    $MODEL_NAME"
echo "Context:    $CONTEXT_SIZE"
echo "GPU Layers: $GPU_LAYERS"
echo "CPU MoE:    $CPU_MOE"
echo "Threads:    $THREADS"
echo "Batch:      $BATCH_SIZE / $UBATCH_SIZE"
echo "═══════════════════════════════════════════════════════════"
echo ""

./llama-server \
    -m "$MODEL_PATH" \
    -ngl "$GPU_LAYERS" \
    --n-cpu-moe "$CPU_MOE" \
    -c "$CONTEXT_SIZE" \
    -t "$THREADS" \
    -tb "$BATCH_THREADS" \
    -b "$BATCH_SIZE" \
    -ub "$UBATCH_SIZE" \
    --cache-type-k "$CACHE_K" \
    --cache-type-v "$CACHE_V" \
    --parallel "$PARALLEL" \
    $([ "$FLASH_ATTN" = "1" ] && echo "--flash-attn") \
    $([ "$MLOCK" = "1" ] && echo "--mlock") \
    $([ "$JINJA" = "1" ] && echo "--jinja") \
    --host 0.0.0.0 \
    --port 8080
