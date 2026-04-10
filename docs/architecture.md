# PlaximoOdin - LLM Stack Dokumentation

## Architektur-Übersicht

```
┌─────────────────────────────────────────────────────────────┐
│                        HOST SYSTEM                         │
│  Ubuntu 24.04 LTS (Noble Numbat)                           │
│  Kernel 6.17.0-20-generic                                  │
└─────────────────────────────────────────────────────────────┘
                            │
        ┌───────────────────┼───────────────────┐
        ▼                   ▼                   ▼
┌───────────────┐   ┌───────────────┐   ┌───────────────┐
│   NVIDIA GPU  │   │     CPU       │   │     RAM       │
│  RTX 4070     │   │  Ryzen 7      │   │    30 GB      │
│  8 GB VRAM    │   │  7840HS      │   │               │
└───────────────┘   └───────────────┘   └───────────────┘
        │                   │                   │
        └───────────────────┼───────────────────┘
                            │
                            ▼
┌─────────────────────────────────────────────────────────────┐
│                    LLM INFERENCE LAYER                      │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  ┌─────────────────────────────────────────────────────┐   │
│  │                    llama.cpp                        │   │
│  │  ┌─────────────┐ ┌─────────────┐ ┌──────────────┐ │   │
│  │  │llama-cli    │ │llama-server │ │llama-gguf-   │ │   │
│  │  │(Interactive)│ │(HTTP API)   │ │split         │ │   │
│  │  └─────────────┘ └─────────────┘ └──────────────┘ │   │
│  │                                                     │   │
│  │  Backend: CUDA + Vulkan (falls verfügbar)          │   │
│  │  Quantisierung: Q4_K_M, Q5_K_M, Q8_0              │   │
│  └─────────────────────────────────────────────────────┘   │
│                                                             │
└─────────────────────────────────────────────────────────────┘
                            │
                            ▼
┌─────────────────────────────────────────────────────────────┐
│                    MODEL LAYER                              │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  ┌─────────────┐   ┌─────────────┐   ┌─────────────┐      │
│  │ Vocab Files │   │ GGUF Models │   │ Unsloth     │      │
│  │ (Tokenizers)│   │ (Quantized) │   │ Models      │      │
│  └─────────────┘   └─────────────┘   └─────────────┘      │
│                                                             │
│  Speicherorte:                                              │
│  - ~/llama.cpp/models/                                     │
│  - ~/.cache/huggingface/hub/                               │
│  - ~/unsloth/                                              │
│                                                             │
└─────────────────────────────────────────────────────────────┘
                            │
                            ▼
┌─────────────────────────────────────────────────────────────┐
│                    PYTHON LAYER                             │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  ┌─────────────────────────────────────────────────────┐   │
│  │              llm-venv (Virtual Environment)         │   │
│  │                                                     │   │
│  │  Core Libraries:                                    │   │
│  │  - huggingface_hub    (Model Management)           │   │
│  │  - httpx              (Async HTTP)                 │   │
│  │  - typer              (CLI Framework)              │   │
│  │  - rich               (Terminal UI)                │   │
│  │  - tqdm               (Progress Bars)              │   │
│  │                                                     │   │
│  └─────────────────────────────────────────────────────┘   │
│                                                             │
└─────────────────────────────────────────────────────────────┘
                            │
                            ▼
┌─────────────────────────────────────────────────────────────┐
│                    API LAYER                                │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  llama-server REST API (Port 8080)                          │
│                                                             │
│  POST /completion     - Text-Generierung                    │
│  POST /chat           - Chat-Completion                     │
│  POST /embeddings     - Embedding-Generierung              │
│  GET  /models         - Verfügbare Modelle                 │
│  POST /infill         - Code-Infilling                     │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

## Komponenten-Details

### 1. llama.cpp Core

**Zweck:** Effiziente lokale LLM-Inferenz ohne Python-Overhead

**Binaries:**
- `llama-cli` - Interaktive Kommandozeile
- `llama-server` - HTTP API Server
- `llama-gguf-split` - Model-Splitting Tool

**CUDA Integration:**
```bash
# Kompilierung mit CUDA Support
cmake .. -DGGML_CUDA=ON
```

### 2. Python Integration

**Virtual Environment:** `~/llm-venv/`

**Kern-Funktionalität:**
- Modell-Download via HuggingFace
- API-Client für llama-server
- Batch-Processing
- Evaluation Pipelines

### 3. Model Management

**Download Pipeline:**
```
HuggingFace Hub → huggingface_hub → ~/.cache/huggingface/
                                      ↓
                              llama.cpp/models/
                                      ↓
                              Inference Ready
```

**Unterstützte Formate:**
- GGUF (empfohlen)
- GGML (legacy)
- HF Safetensors (Konvertierung erforderlich)

## GPU-Auslastung

| Prozess | VRAM | Beschreibung |
|---------|------|--------------|
| Xorg | 4 MB | Display Server |
| llama-server | ~4.7 GB | Aktiver LLM-Server |

**Maximale Modelle:**
- 8 GB VRAM ≈ 13B Parameter (Q4)
- 8 GB VRAM ≈ 7B Parameter (Q8)

## Datenfluss

```
User Input
    │
    ▼
┌──────────────────┐
│ llama-server     │
│ (HTTP Request)   │
└──────────────────┘
    │
    ▼
┌──────────────────┐
│ llama.cpp        │
│ (Tokenization)   │
└──────────────────┘
    │
    ▼
┌──────────────────┐
│ CUDA Inference   │
│ (GPU Layers)     │
└──────────────────┘
    │
    ▼
┌──────────────────┐
│ De-Tokenization  │
│ (Text Output)    │
└──────────────────┘
    │
    ▼
HTTP Response
```

## Performance-Optimierungen

### KV-Cache
```bash
--ctx-size 4096    # Kontext-Fenster
--cache-type-q q8_0 # KV-Cache Quantisierung
```

### Batch-Verarbeitung
```bash
--batch-size 2048  # Prompt Batch-Größe
--threads 16       # CPU-Threads
```

### GPU-Offloading
```bash
-ngl 99            # Alle Layer auf GPU
-ngl 33            # Teilweise Offloading
-ngl 0             # CPU-only
```
