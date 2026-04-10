# PlaximoOdin - Quick Reference

## System
- **Hostname:** plaximo-Victus
- **OS:** Ubuntu 24.04.4 LTS
- **Kernel:** 6.17.0-20-generic

## Hardware
- **CPU:** AMD Ryzen 7 7840HS (16 Kerne)
- **GPU:** NVIDIA RTX 4070 Laptop (8 GB VRAM)
- **RAM:** 30 GB
- **Storage:** 953 GB NVMe SSD

## Aktives Modell
- **Name:** Qwen3.5-35B-A3B
- **Typ:** MoE (35B → 27B aktiv)
- **Quantisierung:** Q4_K_M
- **Größe:** 21 GB
- **Kontext:** 32K Token

## Server Start
```bash
tmux new -s llama
~/llama.cpp/build/bin/llama-server \
  -m ~/unsloth/Qwen3.5-35B-A3B-GGUF/Qwen3.5-35B-A3B-Q4_K_M.gguf \
  -ngl 99 --n-cpu-moe 36 -c 32768 -t 6 \
  --flash-attn --mlock --jinja \
  --host 0.0.0.0 --port 8080
```

## Monitoring
```bash
# GPU
nvidia-smi

# RAM
free -h

# Server Status
curl http://localhost:8080/v1/models

# Tmux
tmux attach -t llama
```

## Quick Commands
```bash
# Modell-Download
source ~/llm-venv/bin/activate
hf download unsloth/Qwen3.5-35B-A3B-GGUF --include "*Q4_K_M*"

# Server Neustart
tmux kill-session -t llama
# Dann Server Start (siehe oben)

# GPU Reset
sudo nvidia-smi --gpu-reset
```

## Dateien
- `README.md` - Vollständige Dokumentation
- `docs/architecture.md` - Architektur-Details
- `config/system-info.json` - System-Snapshot
- `scripts/setup.sh` - Setup-Skript
- `scripts/start-server.sh` - Server-Starter
