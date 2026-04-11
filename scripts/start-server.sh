#!/usr/bin/env bash
set -euo pipefail

PROFILE_FILE="${PROFILE_FILE:-$HOME/.config/plaximo-odin/profile.sh}"

if [[ ! -f "$PROFILE_FILE" ]]; then
  echo "Fehler: Profil nicht gefunden: $PROFILE_FILE" >&2
  exit 1
fi

source "$PROFILE_FILE"

LLAMA_BIN="${LLAMA_BIN:-$HOME/llama.cpp/build/bin/llama-server}"

if [[ ! -x "$LLAMA_BIN" ]]; then
  echo "Fehler: llama-server nicht gefunden: $LLAMA_BIN" >&2
  exit 1
fi

if [[ ! -f "$MODEL" ]]; then
  echo "Fehler: Modell nicht gefunden: $MODEL" >&2
  exit 1
fi

ARGS=(
  -m "$MODEL" --host "$HOST" --port "$PORT"
  -c "$CONTEXT_SIZE" -ngl "$GPU_LAYERS" --n-cpu-moe "$CPU_MOE"
  -t "$THREADS" --threads-batch "$BATCH_THREADS"
  -b "$BATCH_SIZE" -ub "$UBATCH_SIZE" --parallel "$PARALLEL"
  --cache-type-k "$CACHE_K" --cache-type-v "$CACHE_V"
  --log-format json
)

[[ "${FLASH_ATTN}" == "1" ]] && ARGS+=(--flash-attn)
[[ "${MLOCK}"      == "1" ]] && ARGS+=(--mlock)
[[ "${JINJA}"      == "1" ]] && ARGS+=(--jinja)

exec "$LLAMA_BIN" "${ARGS[@]}"
