# Code Style Guide

## Allgemein
- Schreibe sauberen, lesbaren Code
- Kommentare auf Deutsch oder Englisch
- KEINE generierten Kommentare ("// This function does X")
- Keine todolen TODO-Kommentare

## Python
- Nutze Type Hints wo möglich
- PEP 8 Style Guide
- Async/Await bevorzugen wo sinnvoll
- Virtual Environments für Projekte

## JavaScript/TypeScript
- ESLint + Prettier Konfiguration beachten
- Prefer `const` über `let`, nie `var`
- Interfaces für Typdefinitionen
- Nutze Optional Chaining (`?.`) und Nullish Coalescing (`??`)

## Shell/Bash
- `set -e` für Fehlerbehandlung
- Variablen in Quotes: `"$VAR"` nicht `$VAR`
- Functions statt einzeilige Scripts

## Git
- aussagekräftige Commit Messages
- Ein Feature = ein Commit
- Branch naming: `feature/`, `fix/`, `hotfix/`

## Sicherheit
- KEINE API-Keys oder Secrets im Code
- Nutze Environment Variables
- .env files in .gitignore
