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

### Server stoppen
```bash
./scripts/stop-server.sh
```

### Prozess-Status prüfen
```bash
# Über Port 8080
lsof -i :8080

# Über Prozessname
ps aux | grep llama-server

# Über PID-File
cat ~/.config/plaximo-odin/server.pid
```

## Files
- `docs/architecture.md` - Detaillierte Architektur
- `scripts/setup.sh` - Automatisiertes Setup
- `scripts/start-server.sh` - Server Starter
- `scripts/stop-server.sh` - Server Stopper
- `config/system-info.json` - System Snapshot
