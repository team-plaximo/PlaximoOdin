#!/bin/bash
# PlaximoOdin - Stop LLM Server
# Robustly identifies and terminates the llama-server process.

PORT=8080
PID_FILE="$HOME/.config/plaximo-odin/server.pid"

echo "[PlaximoOdin] Suche nach laufendem llama-server..."

# 1. Check PID file
if [ -f "$PID_FILE" ]; then
    PID=$(cat "$PID_FILE")
    if ps -p "$PID" > /dev/null 2>&1; then
        echo "Gefunden (PID $PID aus PID-File). Beende Prozess..."
        kill "$PID"
        sleep 1
        if ps -p "$PID" > /dev/null 2>&1; then
            echo "Prozess reagiert nicht, erzwinge Abbruch (kill -9)..."
            kill -9 "$PID"
        fi
        rm -f "$PID_FILE"
        echo "Server erfolgreich gestoppt."
        exit 0
    else
        echo "Veraltetes PID-File gefunden. Bereinige..."
        rm -f "$PID_FILE"
    fi
fi

# 2. Check by Port (lsof)
PID=$(lsof -t -i :$PORT 2>/dev/null)
if [ -n "$PID" ]; then
    echo "Gefunden (PID $PID auf Port $PORT). Beende Prozess..."
    # If multiple PIDs are found, kill all
    for p in $PID; do
        kill "$p"
        sleep 1
        if ps -p "$p" > /dev/null 2>&1; then
            kill -9 "$p"
        fi
    done
    echo "Server auf Port $PORT gestoppt."
    exit 0
fi

# 3. Check by Name (pgrep)
PID=$(pgrep llama-server)
if [ -n "$PID" ]; then
    echo "Gefunden (PID(s) $PID via Name). Beende..."
    kill $PID
    echo "Server gestoppt."
    exit 0
fi

echo "Kein laufender llama-server gefunden."
exit 0
