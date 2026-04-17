#!/bin/bash
# PlaximoOdin - LLM Server Starter
# Hardware: RTX 4070 Laptop (8 GB VRAM) + 30 GB RAM + AMD Ryzen 7 7840HS

source ~/.config/plaximo-odin/profile.sh 2>/dev/null || true

PROFILE="${1:-qwen35_35b_safe}"

case "$PROFILE" in
  qwen35_35b_safe)
    echo "Starting llama-server with Qwen3.5-35B-A3B (STABLE PROFILE)..."
    ~/llama.cpp/build/bin/llama-server \
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
      --port 8080
    ;;

  qwen35_35b_original)
    echo "Starting llama-server with Qwen3.5-35B-A3B (ORIGINAL - kann OOM verursachen)..."
    ~/llama.cpp/build/bin/llama-server \
      -m /home/plaximo/unsloth/Qwen3.5-35B-A3B-GGUF/Qwen3.5-35B-A3B-Q4_K_M.gguf \
      -ngl 99 \
      --n-cpu-moe 36 \
      -c 262144 \
      -t 12 \
      --parallel 2 \
      --flash-attn on \
      --jinja \
      --host 0.0.0.0 \
      --port 8080
    ;;

  qwen35_9b)
    echo "Starting llama-server with Qwen3.5-9B (EMPFOHLEN für Stabilität)..."
    # Modell muss separat heruntergeladen werden
    ~/llama.cpp/build/bin/llama-server \
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
      --port 8080
    ;;

  qwen25_7b)
    echo "Starting llama-server with Qwen2.5-7B (HIGHLY STABLE)..."
    # Modell muss separat heruntergeladen werden
    ~/llama.cpp/build/bin/llama-server \
      -m /home/plaximo/unsloth/Qwen2.5-7B-Instruct-Q4_K_M.gguf \
      -c 16384 \
      -ngl 99 \
      -t 10 \
      --parallel 2 \
      --flash-attn 1 \
      --jinja \
      --host 0.0.0.0 \
      --port 8080
    ;;

  *)
    echo "Ungültiges Profil. Verfügbare Profile:"
    echo "  qwen35_35b_safe     - 35B mit konservative Parametern (8GB VRAM, stabil)"
    echo "  qwen35_35b_original - 35B mit original Parametern (kann OOM verursachen)"
    echo "  qwen35_9b           - 9B Modell (empfohlen für beste Stabilität)"
    echo "  qwen25_7b          - 7B Modell (höchste Stabilität)"
    exit 1
    ;;
esac