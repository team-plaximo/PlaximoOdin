# Claude Code Configuration: `settings.json`

Diese Datei konfiguriert das `claude` (Claude Code) Interface für die Zusammenarbeit mit dem lokalen `llama-server`.

**Pfad:** `~/.claude/settings.json`

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

## Highlights

- **`model`**: Explizit auf `Qwen3.6-35B-A3B-Q4_K_M.gguf` gesetzt, um sicherzustellen, dass die Tool-Signaturen korrekt gegen die lokale API geprüft werden.
- **`effortLevel`**: Auf `high` gestellt, um dem Modell mehr Kapazität für komplexe Denkprozesse (via Antigravity Thinking) zu geben.
- **Telemetrie**: Deaktiviert für maximalen Datenschutz.
- **Environment**: Nutzt `ANTHROPIC_BASE_URL` (in `profile.sh` gesetzt), um Anfragen an den lokalen Server umzuleiten.
