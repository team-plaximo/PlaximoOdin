# Profile Reference: `profile.sh`

Diese Datei enthält die globalen Umgebungsvariablen für das PlaximoOdin System. Sie wird verwendet, um den `llama-server` mit optimalen Parametern für die RTX 4070 Laptop-GPU zu konfigurieren.

**Pfad:** `~/.config/plaximo-odin/profile.sh`

```bash
#!/usr/bin/env bash
# PlaximoOdin - Global Environment Profile
# Target: Qwen 3.6-35B-A3B (Antigravity Optimized)

export MODEL="${MODEL:-/home/plaximo/unsloth/Qwen3.6-35B-A3B-GGUF/Qwen3.6-35B-A3B-Q4_K_M.gguf}"
export HOST="${HOST:-0.0.0.0}"
export PORT="${PORT:-8080}"
export CONTEXT_SIZE="${CONTEXT_SIZE:-131072}"
export GPU_LAYERS="${GPU_LAYERS:-24}"
export CPU_MOE="${CPU_MOE:-36}"
export THREADS="${THREADS:-10}"
export BATCH_THREADS="${BATCH_THREADS:-12}"
export BATCH_SIZE="${BATCH_SIZE:-16384}"
export UBATCH_SIZE="${UBATCH_SIZE:-2048}"
export PARALLEL="${PARALLEL:-1}"
export CACHE_K="${CACHE_K:-q4_0}"
export CACHE_V="${CACHE_V:-q4_0}"
export FLASH_ATTN="${FLASH_ATTN:-1}"
export MLOCK="${MLOCK:-1}"
export JINJA="${JINJA:-1}"
export TOOL_PARSER=""
export CHAT_TEMPLATE_FILE="/home/plaximo/PlaximoOdin/config/qwen36_antigravity.jinja"
export DISABLE_THINKING="${DISABLE_THINKING:-0}"
export PRESERVE_THINKING="${PRESERVE_THINKING:-true}"


# Claude Code & OpenAI API Compatibility
export ANTHROPIC_BASE_URL="http://localhost:8080"
export ANTHROPIC_API_KEY="sk-no-key-required"
export ANTHROPIC_MODEL="Qwen3.6-35B-A3B-Q4_K_M.gguf"
export OPENAI_API_KEY="sk-no-key-required"
```

## Parameter Details

- **GPU_LAYERS (24):** Optimiert für 8GB VRAM. Lädt den Großteil der Schichten auf die GPU.
- **CONTEXT_SIZE (131072):** Max context window. Effektiv nutzbar bis ~64k mit Q4_0 Cache.
- **CPU_MOE (36):** Threads für die MoE-Berechnung auf der CPU.
- **JINJA (1):** Aktiviert die native Jinja-Unterstützung im llama-server.
- **PRESERVE_THINKING:** Stellt sicher, dass das Modell seine Gedankengänge (`<thought>`) für den Agenten beibehält.
