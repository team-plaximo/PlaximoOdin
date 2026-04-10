# Hardware Profile für PlaximoOdin
# Kopiere dieses Verzeichnis auf andere Geräte und passe die Werte an

## Verwendung

```bash
# Profil aktivieren
source profiles/rtx-4070-laptop.sh

# Server starten
./start-server.sh <profil>
```

## Verfügbare Profile

| Profil | VRAM | RAM | Modell-Größe | MoE-CPU |
|--------|------|-----|--------------|---------|
| `rtx-4070-laptop.sh` | 8 GB | 30 GB | 35B (Q4) | 24 |
| `rtx-3080.sh` | 10 GB | 64 GB | 70B (Q4) | 16 |
| `rtx-4090.sh` | 24 GB | 64 GB | 405B (Q4) | 0 |
| `cpu-only.sh` | 0 GB | 64 GB | 13B (Q4) | 0 |
| `mac-m3-max.sh` | 40 GB | 128 GB | 405B (Q4) | 0 |

## So erstellst du ein neues Profil

1. Kopiere ein bestehendes Profil
2. Passe die Parameter an:
   - `GPU_LAYERS`: `-ngl` Wert (99 = alle, 0 = CPU-only)
   - `CPU_MOE`: `--n-cpu-moe` Wert
   - `THREADS`: `-t` Wert (CPU-Threads)
   - `BATCH_SIZE`: `-b` Wert
   - `UBATCH_SIZE`: `-ub` Wert
3. Passe das Modell und die Quantisierung an
4. Teste mit `nvidia-smi` und `free -h`

## Faustregeln

- **VRAM zu klein?** → Mehr MoE auf CPU (`--n-cpu-moe` erhöhen)
- **RAM zu klein?** → Weniger MoE auf CPU (`--n-cpu-moe` senken) oder Modell quantisieren
- **Zu langsam?** → Mehr Threads, größerer Batch, Flash Attention aktiviert lassen
