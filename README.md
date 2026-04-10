# PlaximoOdin

> Lokales LLM-System mit vollständiger Hardware-Integration und Open-Source-Toolchain

---

## System-Übersicht

| Komponente | Details |
|------------|---------|
| **OS** | Ubuntu 24.04.4 LTS (Noble Numbat) |
| **Kernel** | 6.17.0-20-generic |
| **Hostname** | plaximo-Victus |
| **Benutzer** | plaximo |
| **Uptime** | 21 Stunden |
| **Sprache** | de_DE.UTF-8 |
| **Zeitzone** | Europe/Berlin (CEST) |

---

## Hardware

### CPU
| Eigenschaft | Wert |
|------------|------|
| **Model** | AMD Ryzen 7 7840HS w/ Radeon 780M Graphics |
| **Kerne** | 16 (8P + 8E) |
| **Threads** | 16 (2 pro Kern) |
| **Architektur** | x86_64 |
| **CPU-Skalierung** | 61% |

### GPU
| Eigenschaft | Wert |
|------------|------|
| **Model** | NVIDIA GeForce RTX 4070 Laptop GPU |
| **VRAM** | 8188 MiB (8 GB) |
| **Verfügbar** | 3040 MiB |
| **Verwendet** | 4767 MiB |
| **Driver** | 580.126.09 (Open Kernel Module) |
| **CUDA Driver** | 13.0 |
| **CUDA Compiler** | 12.0.140 |
| **Compute Capability** | 8.9 |
| **Temperatur** | 45°C |
| **GPU-Util** | 0% (Idle/Server-Mode) |

### Speicher
| Eigenschaft | Wert |
|------------|------|
| **RAM Total** | 30 GiB |
| **RAM Verwendet** | 11 GiB |
| **RAM Frei** | 554 MiB |
| **RAM Verfügbar** | 19 GiB |
| **Swap Total** | 8 GiB |
| **Swap Verwendet** | 376 KiB |

### Storage
| Eigenschaft | Wert |
|------------|------|
| **Typ** | NVMe SSD |
| **Größe** | 953.9 GB |
| **Root-Partition** | 79 GB |
| **Root Belegt** | 46 GB (62%) |
| **Root Frei** | 29 GB |
| **EFI-Partition** | 196 MB (30%) |

### Netzwerk
| Interface | Typ | IP |
|-----------|-----|-----|
| **eno1** | Ethernet | 192.168.10.2/24 |
| **wlo1** | WiFi | 192.168.179.15/24 (default) |
| **lo** | Loopback | 127.0.0.1/8 |

---

## Aktives Modell

| Eigenschaft | Wert |
|------------|------|
| **Name** | Qwen3.5-35B-A3B |
| **Typ** | MoE (Mixture of Experts) |
| **Gesamt-Parameter** | 35B |
| **Aktive Parameter** | 27B (A3B = 2 Experts pro Token) |
| **Experten** | 8 |
| **Quantisierung** | Q4_K_M |
| **Datei-Größe** | 21 GB |
| **Original-Größe** | ~70 GB (FP16) |
| **Kontext-Fenster** | 262.144 Token (train) / 32.768 (aktiv) |
| **Embedding-Dimension** | 2048 |
| **Vocab-Größe** | 248.320 |
| **Quelle** | Unsloth |

### MoE-Architektur

```
Qwen3.5-35B-A3B = 35B Parameter in 8 Experten
                              ↓
              Nur 2 von 8 Experten aktiv pro Token
                              ↓
              Effektiv ~27B Rechenaufwand
                              ↓
              ≈ 27B Dense Modell Qualität
```

---

## Server-Konfiguration

### Aktuelle Einstellungen

```bash
/home/plaximo/llama.cpp/llama-server \
  -m /home/plaximo/unsloth/Qwen3.5-35B-A3B-GGUF/Qwen3.5-35B-A3B-Q4_K_M.gguf \
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
  --flash-attn on \
  --mlock on \
  --jinja on \
  --host 0.0.0.0 \
  --port 8080
```

### Parameter-Erklärung

| Parameter | Wert | Beschreibung |
|-----------|------|-------------|
| `-m` | model.gguf | Modell-Pfad |
| `-ngl 99` | 99 | GPU-Layer (99 = alle) |
| `--n-cpu-moe` | 36 | MoE-Layer auf CPU |
| `-c` | 32768 | Kontext-Größe (Token) |
| `-t` | 6 | CPU-Threads |
| `-tb` | 6 | Thread-Batch |
| `-b` | 8192 | Batch-Größe |
| `-ub` | 512 | UBatch-Größe |
| `--flash-attn` | on | Flash Attention aktiviert |
| `--mlock` | on | RAM nicht in Swap auslagern |
| `--jinja` | on | Jinja Chat-Templates |
| `--parallel` | 1 | Parallele Anfragen |
| `--cache-type-k/v` | q4_0 | KV-Cache Quantisierung |

### Server-Status

| Eigenschaft | Wert |
|------------|------|
| **PID** | 19547 |
| **Port** | 8080 |
| **Host** | 0.0.0.0 (alle Interfaces) |
| **API-Endpoint** | http://localhost:8080 |
| **VRAM-Verbrauch** | 4767 MiB |
| **RAM-Verbrauch** | 23 GB |
| **CPU-Auslastung** | 12.1% |
| **Tmux-Session** | llama |

---

## Software-Stack

### LLM-Infrastruktur

| Tool | Version | Zweck |
|------|---------|-------|
| **llama.cpp** | b8738 (d6f303004) | Lokale Inferenz-Engine |
| **llama-cli** | b8738 | Kommandozeilen-Inferenz |
| **llama-server** | b8738 | REST API Server |
| **llama-gguf-split** | b8738 | Model Splitting |
| **llama-mtmd-cli** | b8738 | Multi-Modal Support |

### Python-Umgebung (llm-venv)

| Package | Version |
|---------|---------|
| huggingface_hub | 1.10.1 |
| httpx | 0.28.1 |
| typer | 0.24.1 |
| rich | 14.3.3 |
| tqdm | 4.67.3 |
| PyYAML | 6.0.3 |
| anyio | 4.13.0 |
| click | 8.3.2 |
| filelock | 3.25.2 |
| hf_transfer | 0.1.9 |
| hf-xet | 1.4.3 |

### Build-Toolchain

| Komponente | Version |
|------------|---------|
| **CUDA Toolkit** | 12.0.140 |
| **NVIDIA Driver** | 580.126.09 |
| **GCC/G++** | 13.3.0 |
| **Python** | 3.12.3 |

### Andere Tools

| Tool | Version | Status |
|------|---------|--------|
| **GitHub CLI** | 2.89.0 | ✅ Installiert |
| **OpenCode** | 1.4.3 | ✅ Installiert |
| **Docker** | - | ❌ Nicht installiert |
| **Node.js** | - | ❌ Nicht im PATH |

---

## Verzeichnis-Struktur

```
/home/plaximo/
├── llama.cpp/                          # llama.cpp Repository
│   ├── build/                          # Build-Artefakte
│   │   └── bin/
│   │       ├── llama-cli               # CLI Inferenz
│   │       ├── llama-server            # HTTP API Server
│   │       ├── llama-gguf-split        # Model Splitter
│   │       └── llama-mtmd-cli          # Multi-Modal
│   ├── models/                         # Vocab-Dateien
│   └── examples/                       # Beispiel-Code
│
├── llm-venv/                           # Python Virtual Environment
│   └── bin/
│       ├── python
│       ├── pip
│       ├── huggingface-cli
│       └── hf
│
├── unsloth/                            # Unsloth Modelle
│   └── Qwen3.5-35B-A3B-GGUF/
│       └── Qwen3.5-35B-A3B-Q4_K_M.gguf  (21 GB)
│
├── PlaximoOdin/                        # Dieses Repository
│   ├── README.md
│   ├── docs/
│   ├── scripts/
│   ├── config/
│   └── notes/
│
├── .config/
│   └── opencode/                       # OpenCode Config
│
└── .cache/
    └── huggingface/                    # HF Model Cache
```

---

## Installation

### 1. llama.cpp Build

```bash
cd ~/llama.cpp
mkdir -p build && cd build
cmake .. -DGGML_CUDA=ON
make -j$(nproc)
```

### 2. Python Environment

```bash
python3 -m venv ~/llm-venv
source ~/llm-venv/bin/activate
pip install huggingface_hub httpx typer rich tqdm
```

### 3. Modell herunterladen (Unsloth)

```bash
source ~/llm-venv/bin/activate
HF_HUB_ENABLE_HF_TRANSFER=1 hf download unsloth/Qwen3.5-35B-A3B-GGUF \
  --local-dir ~/unsloth/Qwen3.5-35B-A3B-GGUF \
  --include "*Q4_K_M*"
```

### 4. Server starten

```bash
tmux new -s llama
~/llama.cpp/build/bin/llama-server \
  -m ~/unsloth/Qwen3.5-35B-A3B-GGUF/Qwen3.5-35B-A3B-Q4_K_M.gguf \
  -ngl 99 --n-cpu-moe 36 -c 32768 -t 6 \
  --flash-attn --mlock --jinja \
  --host 0.0.0.0 --port 8080
```

### 5. GitHub CLI

```bash
curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | \
  sudo dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg
sudo chmod go+r /usr/share/keyrings/githubcli-archive-keyring.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | \
  sudo tee /etc/apt/sources.list.d/github-cli.list
sudo apt update && sudo apt install gh
gh auth login
```

---

## Monitoring

### GPU
```bash
nvidia-smi -l 1
```

### RAM
```bash
watch -n 1 free -h
```

### Server
```bash
curl http://localhost:8080/v1/models
```

### Tmux
```bash
tmux attach -t llama
```

---

## Multi-Device Deployment

### Hardware Profile

Das System unterstützt verschiedene Hardware-Konfigurationen über Profile:

```bash
# Server mit Profil starten
./scripts/start-with-profile.sh rtx-4070-laptop
```

| Profil | VRAM | RAM | Optimal für |
|--------|------|-----|-------------|
| `rtx-4070-laptop` | 8 GB | 30 GB | Qwen3.5-35B MoE |
| `rtx-4090-desktop` | 24 GB | 64 GB | 405B Modelle |
| `cpu-only` | 0 GB | 32 GB | 13B Modelle |
| `mac-m3-max` | 128 GB | 128 GB | Apple Silicon |

### Neues Profil erstellen

```bash
cp config/profiles/rtx-4070-laptop.sh config/profiles/dein-profil.sh
# Bearbeite die Werte und starte mit:
./scripts/start-with-profile.sh dein-profil
```

---

## Performance-Optimierung

### Optimierte Server-Parameter

```bash
./scripts/start-server-optimized.sh
```

| Parameter | Standard | Optimiert | Effekt |
|-----------|----------|-----------|--------|
| `--n-cpu-moe` | 36 | 24 | ~1.5 GB mehr VRAM |
| `-t` | 6 | 10 | Besseres MoE-Routing |
| `-b` | 8192 | 16384 | Mehr GPU-Offload |
| `--cache-type-k` | q4_0 | q8_0 | Höhere Qualität |

### GPU-Beschleunigung für Datenverarbeitung

```bash
pip install cupy-cuda12x faiss-gpu-cu12
```

---

## Troubleshooting

### Modell lädt nicht
```bash
# RAM prüfen
free -h

# MoE-Layer anpassen
--n-cpu-moe 50   # Weniger RAM
--n-cpu-moe 24   # Noch weniger RAM
```

### CUDA Probleme
```bash
export CUDA_PATH=/usr/local/cuda
nvcc --version
```

### Performance
```bash
# Mehr Kontext
-c 65536

# Höhere KV-Cache Qualität
--cache-type-k q8_0 --cache-type-v q8_0

# Mehr parallele Anfragen
--parallel 4
```

---

## GitHub Repository

**URL:** https://github.com/team-plaximo/PlaximoOdin  
**Account:** team-plaximo  
**Protocol:** SSH

---

*Last updated: 2026-04-10 16:46:00 CEST*
