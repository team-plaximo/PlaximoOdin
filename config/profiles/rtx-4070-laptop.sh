#!/usr/bin/env bash
# Hardware: HP Omen Victus – RTX 4070 Laptop (8 GB VRAM), 30 GB RAM
# Modell:   Qwen3.5-35B-A3B Q4_K_M (21 GB)
# Strategie: Dense-Layer auf GPU (ngl=99), MoE-Experts auf CPU (n-cpu-moe=36)
# Kontext:  2 parallele Slots x 131.072 Token = 262.144 Token total

export MODEL="${MODEL:-/home/plaximo/unsloth/Qwen3.5-35B-A3B-GGUF/Qwen3.5-35B-A3B-Q4_K_M.gguf}"
export HOST="${HOST:-0.0.0.0}"
export PORT="${PORT:-8080}"
export CONTEXT_SIZE="${CONTEXT_SIZE:-262144}"
export GPU_LAYERS="${GPU_LAYERS:-99}"
export CPU_MOE="${CPU_MOE:-36}"
export THREADS="${THREADS:-10}"
export BATCH_THREADS="${BATCH_THREADS:-12}"
export BATCH_SIZE="${BATCH_SIZE:-16384}"
export UBATCH_SIZE="${UBATCH_SIZE:-2048}"
export PARALLEL="${PARALLEL:-2}"
export CACHE_K="${CACHE_K:-q4_0}"
export CACHE_V="${CACHE_V:-q4_0}"
export FLASH_ATTN="${FLASH_ATTN:-1}"
export MLOCK="${MLOCK:-1}"
export JINJA="${JINJA:-1}"
