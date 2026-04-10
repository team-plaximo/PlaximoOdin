# PlaximoOdin - LLM Stack Dokumentation

## Architektur-Übersicht

```
┌─────────────────────────────────────────────────────────────────┐
│                        HOST SYSTEM                             │
│  Ubuntu 24.04 LTS (Noble Numbat)                              │
│  Kernel 6.17.0-20-generic                                      │
└─────────────────────────────────────────────────────────────────┘
                            │
        ┌───────────────────┼───────────────────┐
        ▼                   ▼                   ▼
┌───────────────┐   ┌───────────────┐   ┌───────────────┐
│   NVIDIA GPU  │   │     CPU       │   │     RAM       │
│  RTX 4070     │   │  Ryzen 7      │   │    30 GB      │
│  8 GB VRAM    │   │  7840HS      │   │  23 GB used   │
└───────────────┘   └───────────────┘   └───────────────┘
        │                   │                   │
        └───────────────────┼───────────────────┘
                            │
                            ▼
┌─────────────────────────────────────────────────────────────────┐
│                    LLM INFERENCE LAYER                          │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│  ┌───────────────────────────────────────────────────────────┐ │
│  │                      llama.cpp                             │ │
│  │  ┌─────────────┐ ┌─────────────┐ ┌────────────────────┐   │ │
│  │  │llama-cli    │ │llama-server │ │ llama-gguf-split   │   │ │
│  │  │(Interactive)│ │ (HTTP API)  │ │  (Model Splitter)  │   │ │
│  │  └─────────────┘ └─────────────┘ └────────────────────┘   │ │
│  │                                                             │ │
│  │  Backend: CUDA (GPU Layers) + CPU (MoE Layers)            │ │
│  │  Flash Attention: Enabled                                 │ │
│  │  Memory Locking: Enabled                                  │ │
│  └───────────────────────────────────────────────────────────┘ │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
                            │
                            ▼
┌─────────────────────────────────────────────────────────────────┐
│                    MoE MODEL LAYER                              │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│  ┌───────────────────────────────────────────────────────────┐ │
│  │              Qwen3.5-35B-A3B (MoE)                        │ │
│  │                                                           │ │
│  │   Total Parameters:  35B                                  │ │
│  │   Active Parameters: 27B (A3B = 3 Bits Active)           │ │
│  │   Experts:           8                                    │ │
│  │   Expert per Token: 2                                    │ │
│  │   Quantization:     Q4_K_M                              │ │
│  │                                                           │ │
│  │   ┌─────────────────────────────────────────────────┐     │ │
│  │   │  Layer Distribution                              │     │ │
│  │   │  ┌─────────────┐  ┌─────────────────────┐     │     │ │
│  │   │  │ GPU Layers  │  │ CPU MoE Layers      │     │     │ │
│  │   │  │    99       │  │       36            │     │     │ │
│  │   │  │ (Weights)   │  │ (Expert Routing)    │     │     │ │
│  │   │  └─────────────┘  └─────────────────────┘     │     │ │
│  │   └─────────────────────────────────────────────────┘     │ │
│  └───────────────────────────────────────────────────────────┘ │
│                                                                 │
│  Speicherort: ~/unsloth/Qwen3.5-35B-A3B-GGUF/                 │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
                            │
                            ▼
┌─────────────────────────────────────────────────────────────────┐
│                    PYTHON LAYER                                 │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│  ┌───────────────────────────────────────────────────────────┐ │
│  │              llm-venv (Virtual Environment)                 │ │
│  │                                                           │ │
│  │  Core Libraries:                                          │ │
│  │  - huggingface_hub    (Model Management)                  │ │
│  │  - httpx              (Async HTTP)                        │ │
│  │  - typer              (CLI Framework)                     │ │
│  │  - rich               (Terminal UI)                      │ │
│  │  - tqdm               (Progress Bars)                     │ │
│  │                                                           │ │
│  └───────────────────────────────────────────────────────────┘ │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
                            │
                            ▼
┌─────────────────────────────────────────────────────────────────┐
│                    API LAYER                                    │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│  llama-server REST API (Port 8080)                              │
│                                                                 │
│  POST /completion     - Text-Generierung                        │
│  POST /chat           - Chat-Completion                         │
│  POST /embeddings     - Embedding-Generierung                  │
│  GET  /models        - Verfügbare Modelle                     │
│  POST /infill        - Code-Infilling                         │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

## Komponenten-Details

### 1. llama.cpp Core

**Zweck:** Effiziente lokale LLM-Inferenz ohne Python-Overhead

**Binaries:**
- `llama-cli` - Interaktive Kommandozeile
- `llama-server` - HTTP API Server
- `llama-gguf-split` - Model-Splitting Tool
- `llama-mtmd-cli` - Multi-Modal Support

**CUDA Integration:**
```bash
# Kompilierung mit CUDA Support
cmake .. -DGGML_CUDA=ON
```

### 2. MoE (Mixture of Experts) Konzept

**Was ist MoE?**
- MoE-Modelle haben mehr "Expert"-Netzwerke als aktiviert werden
- Nur 2 von 8 Experts werden pro Token verwendet (A3B = 2 Expert)
- Ermöglicht 35B Parameter mit nur 27B Rechenaufwand

**CPU-GPU Hybrid:**
```
┌────────────────────────────────────────────────────────┐
│              Qwen3.5-35B-A3B Inference                │
├────────────────────────────────────────────────────────┤
│                                                        │
│   GPU (4.7 GB VRAM)                                   │
│   ┌──────────────────────────────────────────────┐   │
│   │  99 Layers: Embedding, Attention, FFN        │   │
│   │  - Embedding Layer                           │   │
│   │  - 36 Transformer Layers                     │   │
│   │  - 63 MoE Layers (Gating Network)           │   │
│   └──────────────────────────────────────────────┘   │
│                                                        │
│   CPU RAM (23 GB)                                     │
│   ┌──────────────────────────────────────────────┐   │
│   │  MoE Expert Weights (36 Layers)              │   │
│   │  - Werden bei Bedarf geroutet                │   │
│   │  - '--n-cpu-moe 36' = 36 MoE Layers auf CPU  │   │
│   └──────────────────────────────────────────────┘   │
│                                                        │
└────────────────────────────────────────────────────────┘
```

**Parameter `--n-cpu-moe`:**
- Steuert wie viele MoE-Layer auf CPU ausgelagert werden
- Niedriger = weniger RAM, mehr VRAM
- Höher = mehr RAM, weniger VRAM-Verbrauch
- Aktuell: 36 (optimiert für 30 GB RAM + 8 GB VRAM)

### 3. Python Integration

**Virtual Environment:** `~/llm-venv/`

**Kern-Funktionalität:**
- Modell-Download via HuggingFace
- API-Client für llama-server
- Batch-Processing
- Evaluation Pipelines

### 4. Model Management

**Download Pipeline (Unsloth):**
```
Unsloth Hub → huggingface_hub → ~/unsloth/Qwen3.5-35B-A3B-GGUF/
                                           ↓
                                   Qwen3.5-35B-A3B-Q4_K_M.gguf
                                           ↓
                                   Inference Ready
```

**Modell-Download:**
```bash
source ~/llm-venv/bin/activate
HF_HUB_ENABLE_HF_TRANSFER=1 hf download unsloth/Qwen3.5-35B-A3B-GGUF \
  --local-dir ~/unsloth/Qwen3.5-35B-A3B-GGUF \
  --include "*Q4_K_M*"
```

**Unterstützte Formate:**
- GGUF (empfohlen) - direkt mit llama.cpp
- Unsloth (vor-optimiert, besser für MoE)

## Ressourcen-Auslastung

| Ressource | Verwendet | Verfügbar | Status |
|-----------|-----------|-----------|--------|
| VRAM | 4.7 GB | 8 GB | ✅ 58% |
| RAM | 23 GB | 30 GB | ⚠️ 77% |
| GPU-Util | 0% | - | Idle (Server-Mode) |

## Datenfluss

```
User Input (Prompt)
        │
        ▼
┌───────────────────┐
│ llama-server      │
│ (HTTP Request)    │
│ Port 8080         │
└───────────────────┘
        │
        ▼
┌───────────────────┐
│ llama.cpp         │
│ - Tokenization    │
│ - Jinja Parsing   │
└───────────────────┘
        │
        ▼
┌───────────────────┐
│ GPU Inference     │
│ - 99 Layers       │
│ - Flash Attention │
│ - KV Cache       │
└───────────────────┘
        │
        ▼
┌───────────────────┐
│ CPU MoE Routing   │
│ - Expert Selection│
│ - 36 MoE Layers  │
│ - 2 of 8 Experts │
└───────────────────┘
        │
        ▼
┌───────────────────┐
│ De-Tokenization   │
│ - Text Output     │
└───────────────────┘
        │
        ▼
HTTP Response (JSON)
```

## Performance-Optimierungen

### Aktuelle Server-Konfiguration

```bash
-m ~/unsloth/Qwen3.5-35B-A3B-GGUF/Qwen3.5-35B-A3B-Q4_K_M.gguf
-ngl 99                    # Alle Layer auf GPU
--n-cpu-moe 36             # MoE Layer auf CPU
-c 32768                   # 32K Kontext
-t 6                       # 6 Threads
-b 8192                    # Batch Size
--flash-attn               # Flash Attention
--mlock                    # RAM nicht auslagern
--cache-type-k q4_0        # KV-Cache K-Quantisierung
--cache-type-v q4_0        # KV-Cache V-Quantisierung
--parallel 1               # Parallele Anfragen
--jinja                    # Chat-Template Support
```

### Kontext-Größen (empfohlen)

| Kontext | RAM | Use Case |
|---------|-----|----------|
| 8192 | ~10 GB | Kurze Konversationen |
| 16384 | ~15 GB | Standard |
| 32768 | ~20 GB | Lange Kontexte |
| 65536 | ~25 GB | Dokumente |
| 131072 | ~28 GB | Sehr lange Kontexte |

### MoE-CPU-Balancing

```bash
# Weniger CPU, mehr RAM frei
--n-cpu-moe 24

# Standard (aktuell)
--n-cpu-moe 36

# Mehr CPU, weniger VRAM
--n-cpu-moe 70
--n-cpu-moe 94
```

### KV-Cache Optimierung

```bash
# Standard (Q4 - kompakt)
--cache-type-k q4_0 --cache-type-v q4_0

# Höhere Qualität (Q8)
--cache-type-k q8_0 --cache-type-v q8_0

# Keine Cache-Quantisierung
--no-kv-offload
```

## Vergleiche

### MoE vs. Dense Modelle

| Eigenschaft | Qwen3.5-35B-A3B (MoE) | 27B Dense |
|------------|------------------------|-----------|
| Parameter | 35B | 27B |
| Aktive Param. | 27B | 27B |
| RAM | ~23 GB | ~18 GB |
| Geschwindigkeit | Schneller bei gleicher Qualität | Standard |
| Qualität | >= 27B Dense | Baseline |

### Warum MoE auf lokaler Hardware?

1. **Qualität:** 27B aktive Parameter = ~27B Dense Qualität
2. **Kontext:** 32K+ Kontext möglich
3. **Effizienz:** Nur 2/8 Experts pro Token
4. **Trade-off:** Mehr RAM für mehr Qualität
