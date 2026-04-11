# Contributing Guide

## Workflow

1. **Branches erstellen**
   ```bash
   git checkout -b feature/feature-name
   git checkout -b fix/bug-description
   ```

2. **Entwickeln** - Klein halten, fokussiert bleiben

3. **Testen** - Vor dem Commit

4. **Committen**
   ```bash
   git add .
   git commit -m "feat: kurze beschreibung"
   ```

5. **Pushen & PR erstellen**

## Commit Message Format

```
<type>(<scope>): <description>

types: feat, fix, docs, style, refactor, test, chore
scope: optional, z.B. api, ui, auth
```

Beispiele:
- `feat(api): add user authentication`
- `fix(ui): resolve button alignment`
- `docs: update README`

## Review Prozess

- Max 400 Zeilen pro PR
- Keine ungetesteten Changes
- Alle Tests müssen grün sein

## Offene Fragen?

- Slack/Discord: #dev-team
- Email: dev@plaximo.local
