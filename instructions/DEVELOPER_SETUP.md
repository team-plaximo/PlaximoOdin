# OpenCode Setup für Entwickler

## Server-Connection

Der LLM-Server läuft auf: `http://192.168.10.2:8080`

Beide Entwickler können diese Adresse nutzen.

## Installation

1. OpenCode installieren:
   ```bash
   curl -fsSL https://opencode.ai/install | bash
   ```

2. Config kopieren:
   ```bash
   cp PlaximoOdin/config/opencode-developer.json ~/.config/opencode/opencode.json
   ```

3. Project-Config (optional):
   ```bash
   cp PlaximoOdin/config/opencode-developer.json /dein/projekt/opencode.json
   ```

## Nutzung

```bash
cd /dein/projekt
opencode
```

## Troubleshooting

**Connection Error:**
- Prüfe ob llama-server läuft: `curl http://192.168.10.2:8080/health`
- Prüfe Netzwerk-Verbindung

**Langsam:**
- Normal für lokale Modelle
- Parallel-Sessions erhöhen in Config wenn nötig
