# PlaximoOdin - Access Points

> Von anderen Geräten im Netzwerk auf PlaximoOdin zugreifen

---

## Server Status

| Eigenschaft | Wert |
|------------|------|
| **Host** | plaximo-Victus |
| **Lokale IP (Ethernet)** | `192.168.10.2` |
| **Lokale IP (WiFi)** | `192.168.179.15` |
| **Port** | 8080 |
| **Protokoll** | HTTP REST |
| **Modell** | Qwen3.5-35B-A3B |

---

## Endpoints

### Basis-URL
```
http://192.168.10.2:8080
```

### Verfügbare Endpoints

| Methode | Endpoint | Beschreibung |
|---------|----------|--------------|
| GET | `/v1/models` | Verfügbare Modelle |
| POST | `/v1/completions` | Text-Generierung |
| POST | `/v1/chat/completions` | Chat-Completion |
| POST | `/v1/embeddings` | Embeddings erstellen |
| POST | `/infill` | Code-Infilling |
| GET | `/health` | Server-Status |

---

## Schnell-Zugriff

### Chat (cURL)
```bash
curl -X POST http://192.168.10.2:8080/v1/chat/completions \
  -H "Content-Type: application/json" \
  -d '{
    "messages": [{"role": "user", "content": "Hallo!"}],
    "max_tokens": 500
  }'
```

### Completion
```bash
curl -X POST http://192.168.10.2:8080/v1/completions \
  -H "Content-Type: application/json" \
  -d '{
    "prompt": "Erkläre Quantenphysik in 3 Sätzen:",
    "max_tokens": 200
  }'
```

### Embeddings
```bash
curl -X POST http://192.168.10.2:8080/v1/embeddings \
  -H "Content-Type: application/json" \
  -d '{"input": "Hallo Welt"}'
```

### Server-Status
```bash
curl http://192.168.10.2:8080/health
```

---

## Client-Konfigurationen

Siehe `/clients/` für fertige Client-Skripte:

- `openai-python.py` - Python Client mit OpenAI-kompatibler API
- `opencode-config.json` - OpenCode Konfiguration für Remote-LLM
- `chat-cli.py` - Einfache CLI Chat-Anwendung

---

## Externe Endpoints (Cloud)

| Service | Endpoint |备注 |
|---------|----------|-----|
| OpenAI API | `https://api.openai.com/v1` | API-Key benötigt |
| Anthropic | `https://api.anthropic.com/v1` | API-Key benötigt |
| Groq | `https://api.groq.com/openai/v1` | Kostenlos mit API-Key |

---

## Firewall/Port

Der Server lauscht auf `0.0.0.0:8080` - erreichbar im lokalen Netzwerk.

Falls Verbindungsprobleme:
```bash
# Auf dem Server prüfen:
sudo ufw allow 8080/tcp
```
