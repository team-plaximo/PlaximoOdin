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
- **CUDA Version:** 13.0 / 12.0 Compiler

### Speicher
- **RAM:** 30 GB
- **Aktuell genutzt:** ~23 GB (72.7%) - für MoE Modell
- **Swap:** 8 GB

### Storage
- **System:** NVMe SSD 953.9 GB
- **Root-Partition:** 80 GB (46 GB belegt, 62%)

## Aktives Modell

| Eigenschaft | Wert |
|-------------|------|
| **Name** | Qwen3.5-35B-A3B |
| **Typ** | MoE (Mixture of Experts) |
| **Effektive Parameter** | 27B (A3B = 3 Bits Active) |
| **Quantisierung** | Q4_K_M |
| **Kontext-Fenster** | 32.768 Token |
| **Quelle** | Unsloth |

### MoE-Konfiguration

Das Modell nutzt **CPU für MoE-Layer** (`--n-cpu-moe 36`), um den 35B-MoE effizient auf der Hardware zu betreiben:

- **GPU Layer:** 99 (alle)
- **CPU MoE Layer:** 36
- **Threads:** 6
- **Batch Size:** 8192

## Software-Stack

### LLM-Infrastruktur

| Tool | Version | Zweck |
|------|---------|-------|
| **llama.cpp** | latest (git) | Lokale Inferenz-Engine |
| **llama-cli** | b3079 | Kommandozeilen-Inferenz |
| **llama-server** | b3079 | REST API Server |
| **huggingface_hub** | latest | Modell-Download |
| **httpx** | latest | Async HTTP |

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
├── unsloth/                # Unsloth Modelle
│   └── Qwen3.5-35B-A3B-GGUF/
│       └── Qwen3.5-35B-A3B-Q4_K_M.gguf
│
├── .config/
│   └── opencode/           # OpenCode AI Config
│
└── .cache/
    └── huggingface/        # HuggingFace Model Cache
```

## Server-Konfiguration

### Aktuelle Konfiguration

```bash
~/llama.cpp/llama-server \
  -m ~/unsloth/Qwen3.5-35B-A3B-GGUF/Qwen3.5-35B-A3B-Q4_K_M.gguf \
  -ngl 99 \
  --n-cpu-moe 36 \
  -c 32768 \
  -t 6 \
  -tb 6 \
  -b 8192 \
  -ub 512 \
  --cache-type-k q4_0 \
  --cache-type-v q4_0 \
  --parallel 1 \
  --flash-attn \
  --mlock \
  --jinja \
  --host 0.0.0.0 \
  --port 8080
```

### Parameter-Erklärung

| Parameter | Wert | Beschreibung |
|-----------|------|-------------|
| `-m` | model.gguf | Pfad zum Modell |
| `-ngl 99` | 99 | GPU Layer (99 = alle) |
| `--n-cpu-moe` | 36 | MoE-Layer auf CPU |
| `-c` | 32768 | Kontext-Größe |
| `-t` | 6 | CPU-Threads |
| `-b` | 8192 | Batch-Größe |
| `--flash-attn` | on | Flash Attention |
| `--mlock` | on | RAM nicht auslagern |
| `--cache-type-k/v` | q4_0 | KV-Cache Quantisierung |

## Installation & Setup

### llama.cpp Build

```bash
cd ~/llama.cpp
mkdir build && cd build
cmake .. -DGGML_CUDA=ON
make -j$(nproc)
```

### Modell herunterladen (Unsloth)

```bash
source ~/llm-venv/bin/activate
HF_HUB_ENABLE_HF_TRANSFER=1 hf download unsloth/Qwen3.5-35B-A3B-GGUF \
  --local-dir ~/unsloth/Qwen3.5-35B-A3B-GGUF \
  --include "*Q4_K_M*"
```

### Server starten

```bash
tmux new -s llama
~/llama.cpp/llama-server \
  -m ~/unsloth/Qwen3.5-35B-A3B-GGUF/Qwen3.5-35B-A3B-Q4_K_M.gguf \
  -ngl 99 --n-cpu-moe 36 -c 32768 -t 6 \
  --flash-attn --mlock --jinja \
  --host 0.0.0.0 --port 8080
```

## Aktive Services

| Service | VRAM | RAM | Status |
|---------|------|-----|--------|
| llama-server | 4.7 GB | 23 GB | ✅ Aktiv (PID 19547) |
| Xorg | 4 MB | - | ✅ Aktiv |

## Maintenance

### Updates

```bash
# Ubuntu
sudo apt update && sudo apt upgrade

# llama.cpp
cd ~/llama.cpp && git pull && cd build && cmake .. && make -j$(nproc)
```

### Monitoring

```bash
# GPU Status
nvidia-smi -l 1

# Speicher
watch -n 1 free -h

# Prozesse
ps aux | grep llama
```

## Troubleshooting

### Modell lädt nicht
- Prüfe ob genug RAM verfügbar (`free -h`)
- MoE-Layer anpassen: `--n-cpu-moe 50` oder `--n-cpu-moe 70`

### CUDA nicht gefunden
```bash
export CUDA_PATH=/usr/local/cuda
export PATH=$CUDA_PATH/bin:$PATH
```

### Performance optimieren
```bash
# Mehr CPU für MoE
--n-cpu-moe 70

# Größerer Kontext
-c 65536

# Mehr KV-Cache
--cache-type-k q8_0 --cache-type-v q8_0
```

---

*Last updated: 2026-04-10*
