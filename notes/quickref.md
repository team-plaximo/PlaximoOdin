# PlaximoOdin

## Quick Reference

### Start llama-server
```bash
cd ~/llama.cpp/build/bin
./llama-server -m /pfad/zu/model.gguf -c 4096 -ngl 99 --port 8080
```

### Model herunterladen
```bash
source ~/llm-venv/bin/activate
huggingface-cli download meta-llama/Llama-3.2-3B-Instruct-GGUF
```

### GPU Status
```bash
watch -n 1 nvidia-smi
```

### System Info
```bash
cat PlaximoOdin/config/system-info.json
```

## Files
- `docs/architecture.md` - Detaillierte Architektur
- `scripts/setup.sh` - Automatisiertes Setup
- `scripts/start-server.sh` - Server Starter
- `config/system-info.json` - System Snapshot
