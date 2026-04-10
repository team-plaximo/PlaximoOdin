# PlaximoOdin

> Lokales LLM-System mit vollständiger Hardware-Integration und Open-Source-Toolchain

## System-Übersicht

| Komponente | Details |
|------------|---------|
| **OS** | Ubuntu 24.04.4 LTS (Noble Numbat) |
| **Kernel** | 6.17.0-20-generic (PREEMPT_DYNAMIC) |
| **Hostname** | plaximo-Victus |
| **Benutzer** | plaximo |

## Hardware

### CPU
- **Model:** AMD Ryzen 7 7840HS w/ Radeon 780M Graphics
- **Kerne:** 16 (8P + 8E)
- **Threads:** 16

### GPU
- **Model:** NVIDIA GeForce RTX 4070 Mobile (Laptop)
- **VRAM:** 8 GB
- **Driver:** 580.126.09
- **CUDA Version:** 13.0
- **Aktueller VRAM-Verbrauch:** ~4.7 GB (llama-server)

### Speicher
- **RAM:** 30 GB
- **Aktuell genutzt:** ~10 GB
- **Swap:** 8 GB

### Storage
- **System:** NVMe SSD 953.9 GB
- **Root-Partition:** 80 GB (46 GB belegt, 62%)

## Software-Stack

### LLM-Infrastruktur

| Tool | Version | Zweck |
|------|---------|-------|
| **llama.cpp** | latest (git) | Lokale Inferenz-Engine |
| **llama-cli** | b3079 | Kommandozeilen-Inferenz |
| **llama-server** | b3079 | REST API Server |
| **huggingface_hub** | 1.10.1 | Modell-Download |
| **httpx** | 0.28.1 | Async HTTP |

### Build-Toolchain

| Komponente | Version |
|------------|---------|
| **CUDA Toolkit** | 12.0 |
| **NVIDIA Driver** | 580 |
| **GCC/G++** | System |
| **CMake** | Im Build-Verzeichnis |

### Python-Umgebungen

| Environment | Location | Packages |
|-------------|----------|----------|
| **llm-venv** | `~/llm-venv/` | huggingface_hub, httpx, typer, rich, tqdm |

## Verzeichnis-Struktur

```
~/
├── llama.cpp/              # llama.cpp Repository (Source + Build)
│   ├── build/              # Kompilierte Binaries
│   │   └── bin/
│   │       ├── llama-cli           # CLI Inferenz
│   │       ├── llama-server        # HTTP Server
│   │       └── llama-gguf-split    # Model Splitting
│   ├── models/             # Vocab-Dateien
│   └── examples/           # Beispiel-Code
│
├── llm-venv/               # Python Virtual Environment
│   └── bin/
│       ├── huggingface-cli
│       └── hf
│
├── unsloth/                # Unsloth (Qwen3.5-35B-A3B)
│   └── Qwen3.5-35B-A3B-GGUF/
│
├── .config/
│   └── opencode/           # OpenCode AI Config
│
└── .cache/
    └── huggingface/        # HuggingFace Model Cache (22 MB)
```

## Installation & Setup

### llama.cpp Build

```bash
cd ~/llama.cpp
mkdir build && cd build
cmake ..
make -j$(nproc)
```

### Modelle herunterladen

```bash
# Via HuggingFace CLI
source ~/llm-venv/bin/activate
huggingface-cli download <model_id>

# Direkt mit llama-cli
./llama-cli -hf <model_id>
```

### Server starten

```bash
cd ~/llama.cpp
./build/bin/llama-server \
  -m pfad/zu/model.gguf \
  -c 4096 \
  -ngl 99 \
  --host 0.0.0.0 \
  --port 8080
```

## Konfiguration

### Environment Variables

```bash
# In ~/.bashrc
export PATH=$HOME/.opencode/bin:$PATH
```

### Aliases

```bash
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'
```

## Aktive Services

- **llama-server** - Läuft mit ~4.7 GB VRAM auf GPU 0
- **GNOME Session** - Vollständige Desktop-Umgebung

## Installation Scripts

Siehe `/scripts/` für automatisierte Setup-Skripte.

## Maintenance

### Updates

```bash
# Ubuntu
sudo apt update && sudo apt upgrade

# llama.cpp
cd ~/llama.cpp && git pull && cd build && cmake .. && make -j$(nproc)

# Python packages
source ~/llm-venv/bin/activate && pip install -U package
```

### Monitoring

```bash
# GPU Status
nvidia-smi

# Speicher
free -h

# llama-server Logs
# Via http://localhost:8080
```

## Troubleshooting

### CUDA nicht gefunden
```bash
export CUDA_PATH=/usr/local/cuda
export PATH=$CUDA_PATH/bin:$PATH
```

### Modell zu groß für VRAM
```bash
# Mit weniger GPU-Layer
./llama-server -m model.gguf -ngl 33

# Oder CPU-only
./llama-server -m model.gguf -ngl 0
```

---

*Last updated: 2026-04-10*
