#!/bin/bash
# PlaximoOdin - LLM Server Starter
# Hardware: RTX 4070 Laptop (8 GB VRAM) + 30 GB RAM + AMD Ryzen 7 7840HS

source ~/.config/plaximo-odin/profile.sh 2>/dev/null || true

PID_FILE="$HOME/.config/plaximo-odin/server.pid"
mkdir -p "$(dirname "$PID_FILE")"

# Load global profile if exists
if [ -f "$HOME/.config/plaximo-odin/profile.sh" ]; then
    source "$HOME/.config/plaximo-odin/profile.sh"
fi

# Check if server is already running
if [ -f "$PID_FILE" ]; then
    OLD_PID=$(cat "$PID_FILE")
    if ps -p "$OLD_PID" > /dev/null; then
        echo "Llama-server (PID $OLD_PID) läuft bereits. Bitte erst stoppen."
        exit 1
    else
        rm -f "$PID_FILE"
    fi
fi

PROFILE="${1:-qwen36_35b_antigravity}"

case "$PROFILE" in
  qwen36_35b_antigravity)
    echo "Starting llama-server with Qwen3.6-35B (ANTIGRAVITY OPTIMIZED)..."
    ~/llama.cpp/llama-server \
      -m "$MODEL" \
      -c "$CONTEXT_SIZE" \
      -ngl "$GPU_LAYERS" \
      --n-cpu-moe "$CPU_MOE" \
      -t "$THREADS" \
      --threads-batch "$BATCH_THREADS" \
      -b "$BATCH_SIZE" \
      -ub "$UBATCH_SIZE" \
      --parallel "$PARALLEL" \
      --cache-type-k "$CACHE_K" \
      --cache-type-v "$CACHE_V" \
      --flash-attn on \
      --jinja \
      --chat-template-file "$CHAT_TEMPLATE_FILE" \
      --chat-template-kwargs "{\"preserve_thinking\": $PRESERVE_THINKING}" \
      --host "$HOST" \
      --port "$PORT" &
    PID=$!
    echo $PID > "$PID_FILE"
    echo "Server gestartet mit PID $PID"
    wait $PID
    rm -f "$PID_FILE"
    ;;

  qwen35_35b_safe)
    echo "Starting llama-server with Qwen3.5-35B-A3B (STABLE PROFILE)..."
    ~/llama.cpp/llama-server \
      -m /home/plaximo/unsloth/Qwen3.5-35B-A3B-GGUF/Qwen3.5-35B-A3B-Q4_K_M.gguf \
      -c 4096 \
      -ngl 8 \
      --n-cpu-moe 36 \
      -t 10 \
      --parallel 1 \
      --flash-attn 1 \
      -ctk q4_1 \
      -ctv q4_1 \
      --jinja \
      --host 0.0.0.0 \
      --port 8080 &
    PID=$!
    echo $PID > "$PID_FILE"
    wait $PID
    rm -f "$PID_FILE"
    ;;

  qwen35_35b_toolcall)
    echo "Starting llama-server with Qwen3.5-35B-A3B (CLAUDE CODE OPTIMIZED)..."
    ~/llama.cpp/llama-server \
      -m /home/plaximo/unsloth/Qwen3.5-35B-A3B-GGUF/Qwen3.5-35B-A3B-Q4_K_M.gguf \
      -c 65536 \
      -ngl 24 \
      --n-cpu-moe 36 \
      -t 10 \
      --threads-batch 12 \
      -b 16384 \
      -ub 2048 \
      --parallel 1 \
      --cache-type-k q4_0 \
      --cache-type-v q4_0 \
      --flash-attn on \
      --jinja \
      --chat-template-file /home/plaximo/PlaximoOdin/config/qwen35_fixed.jinja \
      --chat-template-kwargs "{\"enable_thinking\": false}" \
      --host 0.0.0.0 \
      --port 8080 &
    PID=$!
    echo $PID > "$PID_FILE"
    wait $PID
    rm -f "$PID_FILE"
    ;;

  qwen35_35b_original)
    echo "Starting llama-server with Qwen3.5-35B-A3B (ORIGINAL)..."
    ~/llama.cpp/llama-server \
      -m /home/plaximo/unsloth/Qwen3.5-35B-A3B-GGUF/Qwen3.5-35B-A3B-Q4_K_M.gguf \
      -ngl 99 \
      --n-cpu-moe 36 \
      -c 262144 \
      -t 12 \
      --parallel 2 \
      --flash-attn on \
      --jinja \
      --host 0.0.0.0 \
      --port 8080 &
    PID=$!
    echo $PID > "$PID_FILE"
    wait $PID
    rm -f "$PID_FILE"
    ;;

  qwen35_9b)
    echo "Starting llama-server with Qwen3.5-9B..."
    ~/llama.cpp/llama-server \
      -m /home/plaximo/unsloth/Qwen3.5-9B-Instruct-Q4_K_M.gguf \
      -c 16384 \
      -ngl 99 \
      -t 10 \
      --parallel 2 \
      --flash-attn 1 \
      -ctk q4_1 \
      -ctv q4_1 \
      --jinja \
      --host 0.0.0.0 \
      --port 8080 &
    PID=$!
    echo $PID > "$PID_FILE"
    wait $PID
    rm -f "$PID_FILE"
    ;;

  qwen25_7b)
    echo "Starting llama-server with Qwen2.5-7B..."
    ~/llama.cpp/llama-server \
      -m /home/plaximo/unsloth/Qwen2.5-7B-Instruct-Q4_K_M.gguf \
      -c 16384 \
      -ngl 99 \
      -t 10 \
      --parallel 2 \
      --flash-attn 1 \
      --jinja \
      --host 0.0.0.0 \
      --port 8080 &
    PID=$!
    echo $PID > "$PID_FILE"
    wait $PID
    rm -f "$PID_FILE"
    ;;

  *)
    echo "Ungültiges Profil. Verfügbare Profile:"
    echo "  qwen36_35b_antigravity (Default)"
    echo "  qwen35_35b_safe"
    echo "  qwen35_35b_toolcall"
    echo "  qwen35_35b_original"
    echo "  qwen35_9b"
    echo "  qwen25_7b"
    exit 1
    ;;
esac