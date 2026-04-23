# Claude Code Windows Migration Script
# Dieses Skript setzt die Umgebungsvariablen und erstellt die Config-Files

$ClaudeDir = Join-Path $env:USERPROFILE ".claude"
if (!(Test-Path $ClaudeDir)) {
    New-Item -ItemType Directory -Path $ClaudeDir | Out-Null
    Write-Host "Verzeichnis $ClaudeDir erstellt." -ForegroundColor Cyan
}

# 1. Environment Variables setzen
Write-Host "Setze Umgebungsvariablen für Victus LLM Server (192.168.10.2)..." -ForegroundColor Yellow
[System.Environment]::SetEnvironmentVariable("ANTHROPIC_BASE_URL", "http://192.168.10.2:8080", "User")
[System.Environment]::SetEnvironmentVariable("ANTHROPIC_API_KEY", "sk-no-key-required", "User")
[System.Environment]::SetEnvironmentVariable("ANTHROPIC_MODEL", "Qwen3.6-35B-A3B-Q4_K_M.gguf", "User")
$env:ANTHROPIC_BASE_URL = "http://192.168.10.2:8080"
$env:ANTHROPIC_API_KEY = "sk-no-key-required"
$env:ANTHROPIC_MODEL = "Qwen3.6-35B-A3B-Q4_K_M.gguf"

# 2. settings.json erstellen
$settings = @{
    promptSuggestionEnabled = $false
    env = @{
        CLAUDE_CODE_ENABLE_TELEMETRY = "0"
        CLAUDE_CODE_DISABLE_NONESSENTIAL_TRAFFIC = "1"
        CLAUDE_CODE_ATTRIBUTION_HEADER = "0"
        ANTHROPIC_BASE_URL = "http://192.168.10.2:8080"
        ANTHROPIC_API_KEY = "sk-no-key-required"
    }
    attribution = @{
        commit = ""
        pr = ""
    }
    plansDirectory = "./plans"
    prefersReducedMotion = $true
    terminalProgressBarEnabled = $false
    effortLevel = "high"
    model = "Qwen3.6-35B-A3B-Q4_K_M.gguf"
}
$settings | ConvertTo-Json -Depth 10 | Out-File (Join-Path $ClaudeDir "settings.json") -Encoding utf8

# 3. settings.local.json erstellen
$localSettings = @{
    permissions = @{
        allow = @(
            "Bash(env)",
            "Bash(curl *)",
            "PowerShell(Get-Item *)",
            "PowerShell(Get-Content *)",
            "PowerShell(Set-Content *)",
            "PowerShell(ls *)"
        )
    }
}
$localSettings | ConvertTo-Json -Depth 10 | Out-File (Join-Path $ClaudeDir "settings.local.json") -Encoding utf8

Write-Host "`nSetup abgeschlossen!" -ForegroundColor Green
Write-Host "Bitte installiere Claude Code mit: npm install -g @anthropic-ai/claude-code" -ForegroundColor White
Write-Host "Starte dein Terminal neu, damit die Variablen aktiv werden." -ForegroundColor Yellow
