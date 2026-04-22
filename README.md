# PlaximoOdin 🦅

> Lokales LLM-System mit vollständiger Hardware-Integration und Open-Source-Toolchain, optimiert für agentisches Coding mit Antigravity.

## 🚀 Production Status

| Komponente | Status | Details |
|------------|--------|---------|
| **Modell** | ✅ | Qwen3.6-35B-A3B-GGUF (20GB, 65k+ context) |
| **Server** | ✅ | llama-server (Antigravity Optimized) |
| **Claude Code** | ✅ | Voll integriert (claude-local) |
| **Tool Calling** | ✅ | bash_exec, ls/du, etc. (Jinja optimized) |
| **Jinja Template**| ✅ | preserve_thinking support |
| **GPU/CUDA** | ✅ | RTX 4070 Laptop (8GB VRAM) |
| **Autostart** | ⏳ | Systemd Autostart (In Arbeit) |

## 🛠️ Quick Start (Neuinstallation)

Um das System auf einem neuen Rechner mit NVIDIA-GPU (Linux) zu installieren:

```bash
# 1. Repository klonen & Scripts initialisieren
git clone https://github.com/team-plaximo/PlaximoOdin.git
cd PlaximoOdin
chmod +x scripts/*.sh

# 2. Abhängigkeiten installieren & Build
./scripts/setup.sh

# 3. Server mit Default-Profil starten
./scripts/start-server.sh qwen36_35b_antigravity

# 4. Claude Code verbinden
export ANTHROPIC_BASE_URL="http://localhost:8080"
export ANTHROPIC_API_KEY="sk-no-key-required"
claude
```

## 📋 Verfügbare Profile

Das System unterstützt verschiedene Profile für unterschiedliche Hardware-Anforderungen:

| Profil | Modell | Optimierung | Status |
|--------|--------|-------------|--------|
| **`qwen36_35b_antigravity`** | Qwen3.6-35B | **DEFAULT** / Antigravity Thinking | ✅ Aktiv |
| `qwen35_35b_toolcall` | Qwen3.5-35B | Claude Code Optimized | ✅ Stabil |
| `qwen35_35b_safe` | Qwen3.5-35B | Konservativ (8GB VRAM) | ✅ Stabil |
| `qwen35_9b` | Qwen3.5-9B | Beste Stabilität / Performance | ✅ Aktiv |

## 🧠 Qwen3.6 Migration & Optimierung

Die Migration auf Qwen 3.6 brachte signifikante Verbesserungen für agentische Workflows:

- **Jinja Templates:** Speziell angepasstes Template in `config/qwen36_antigravity.jinja` ermöglicht natives Tool-Calling und "Preserve Thinking" (wobei der Gedankengang des Modells für Claude Code sichtbar bleibt).
- **Claude Code Integration:** Perfekt konfiguriert für das neue `claude-local` Interface. Die `settings.json` in `~/.claude/` verwendet das explizite GGUF-Modell.
- **Context Handling:** Context-Window auf 65k+ erweitert, optimiert durch KV-Cache Quantisierung (q4_0).

## ⚙️ Konfiguration

- **Profile:** `/home/plaximo/.config/plaximo-odin/profile.sh` ([Dokumentation](docs/profile-reference.md))
- **Claude Settings:** `/home/plaximo/.claude/settings.json` ([Dokumentation](docs/claude-config.md))
- **Jinja Template:** `config/qwen36_antigravity.jinja`

## 📊 System-Metriken

### Hardware
- **CPU:** AMD Ryzen 7 7840HS (16 Kerne)
- **GPU:** NVIDIA RTX 4070 Mobile (8 GB VRAM)
- **RAM:** 32 GB DDR5

### Performance
- **Prompt Processing (PP):** ~12.5 T/s (65k context)
- **Generation (TG):** ~3.2 T/s (MoE 35B)

## 🧪 Test Suite

Führe das Test-Skript aus, um die Integrität des Systems zu prüfen:

```bash
./scripts/test-suite.sh
```

---

*Letzter Stand: 2026-04-22 | Qwen3.6 Production ready ✅*

