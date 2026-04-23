# Windows Setup: Claude Code (Antigravity Migration)

Diese Dokumentation beschreibt, wie du deine exakt gleiche Claude Code Konfiguration von Linux auf Windows übertragen kannst.

## 1. Voraussetzungen

* **Node.js**: Installiere die aktuelle LTS Version von [nodejs.org](https://nodejs.org/).
* **Modell-Server**: Da du den Llama-Server lokal auf Windows betreibst, stelle sicher, dass er auf Port `8080` erreichbar ist (oder passe die `ANTHROPIC_BASE_URL` an).

## 2. Claude Code Installation

Öffne ein Terminal (PowerShell oder CMD) und installiere das Claude CLI global:

```powershell
npm install -g @anthropic-ai/claude-code
```

## 3. Konfigurations-Dateien übertragen

Claude Code speichert seine Einstellungen unter Windows im Verzeichnis `%USERPROFILE%\.claude`.

### Dateien zum Kopieren:
Erstelle das Verzeichnis falls es nicht existiert: `mkdir ~\.claude` (in PowerShell).

Kopiere den Inhalt der folgenden Dateien von deinem Linux-System:

#### `settings.json`
Speichere dies unter `%USERPROFILE%\.claude\settings.json`:
```json
{
  "promptSuggestionEnabled": false,
  "env": {
    "CLAUDE_CODE_ENABLE_TELEMETRY": "0",
    "CLAUDE_CODE_DISABLE_NONESSENTIAL_TRAFFIC": "1",
    "CLAUDE_CODE_ATTRIBUTION_HEADER": "0"
  },
  "attribution": {
    "commit": "",
    "pr": ""
  },
  "plansDirectory": "./plans",
  "prefersReducedMotion": true,
  "terminalProgressBarEnabled": false,
  "effortLevel": "high",
  "model": "Qwen3.6-35B-A3B-Q4_K_M.gguf"
}
```

#### `settings.local.json`
Speichere dies unter `%USERPROFILE%\.claude\settings.local.json`:
```json
{
  "permissions": {
    "allow": [
      "Bash(env)",
      "Bash(curl *)",
      "PowerShell(Get-Item *)",
      "PowerShell(Get-Content *)",
      "PowerShell(Set-Content *)",
      "PowerShell(ls *)"
    ]
  }
}
```

## 4. Umgebungsvariablen setzen

Damit Claude Code weiß, dass er nicht die Anthropic Cloud, sondern deinen lokalen Server nutzen soll, müssen diese Variablen gesetzt sein.

### Permanent in PowerShell (empfohlen):
Führe diesen Befehl einmalig in der PowerShell aus:

```powershell
[System.Environment]::SetEnvironmentVariable("ANTHROPIC_BASE_URL", "http://localhost:8080", "User")
[System.Environment]::SetEnvironmentVariable("ANTHROPIC_API_KEY", "sk-no-key-required", "User")
[System.Environment]::SetEnvironmentVariable("ANTHROPIC_MODEL", "Qwen3.6-35B-A3B-Q4_K_M.gguf", "User")
```
*Hinweis: Starte dein Terminal danach neu.*

## 5. Terminal & Shell (WICHTIG)

Claude Code ist für TTY-Umgebungen optimiert. Damit die Darstellung (Farben, Icons) identisch ist:

*   **Windows Terminal**: Nutze das moderne [Windows Terminal](https://aka.ms/terminal) (nicht die alte conhost.exe).
*   **PowerShell 7**: Es wird empfohlen, [PowerShell 7 (Core)](https://github.com/PowerShell/PowerShell) für bessere Pipes zu nutzen.
*   **Nerd Font**: Installiere eine [Nerd Font](https://www.nerdfonts.com/) (z.B. JetBrainsMono Nerd Font), um Icons anzuzeigen.

## 6. Kontext Window & Server-Parameter

Um das exakt gleiche Verhalten wie unter Linux zu erreichen, muss dein Windows Llama-Server mit folgenden Parametern gestartet werden (Beispiel für `llama.cpp` Windows Builds):

* **Context Window**: `131072` (128k)
* **Jinja Template**: Nutze die `qwen36_antigravity.jinja` für korrektes Tool-Calling.
* **Flash Attention**: Aktivieren für Performance.

### Beispiel Start-Befehl (Windows):
```powershell
.\llama-server.exe `
  -m .\models\Qwen3.6-35B-A3B-Q4_K_M.gguf `
  -c 131072 `
  --flash-attn `
  --jinja `
  --chat-template-file .\config\qwen36_antigravity.jinja `
  --host 0.0.0.0 `
  --port 8080
```

## 7. Zusammenfassung der Linux-Configs

Hier sind die Werte, die du auf Linux aktuell nutzt und auf Windows abgleichen solltest:

* **Modell**: Qwen3.6-35B-A3B-Q4_K_M.gguf
* **Context**: 131.072 (128k)
* **GPU Layers**: 24 (auf RTX 4070 Laptop)
* **K/V Cache**: q4_0 (wichtig für RAM Ersparnis bei großem Context)
