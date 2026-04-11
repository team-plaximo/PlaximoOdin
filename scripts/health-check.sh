#!/bin/bash
# PlaximoOdin - Health Check Script
# Usage: ./health-check.sh

set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

SERVER_URL="${SERVER_URL:-http://localhost:8080}"
MODEL_NAME="${MODEL_NAME:-Qwen3.5-35B-A3B}"

echo "=========================================="
echo "  PlaximoOdin Health Check"
echo "=========================================="
echo ""

# Check 1: Server Response
echo -n "Server Response... "
if curl -s -f "$SERVER_URL/health" > /dev/null 2>&1; then
    echo -e "${GREEN}OK${NC}"
else
    echo -e "${RED}FAILED${NC}"
    echo -e "${RED}Server not responding at $SERVER_URL${NC}"
    exit 1
fi

# Check 2: GPU Status
echo -n "GPU Status... "
if command -v nvidia-smi &> /dev/null; then
    GPU_USED=$(nvidia-smi --query-gpu=memory.used --format=csv,noheader | head -1)
    GPU_TOTAL=$(nvidia-smi --query-gpu=memory.total --format=csv,noheader | head -1)
    GPU_TEMP=$(nvidia-smi --query-gpu=temperature.gpu --format=csv,noheader | head -1)
    GPU_UTIL=$(nvidia-smi --query-gpu=utilization.gpu --format=csv,noheader | head -1)
    echo -e "${GREEN}OK${NC}"
    echo "  VRAM: $GPU_USED / $GPU_TOTAL MiB"
    echo "  Temp: ${GPU_TEMP}°C"
    echo "  Util: ${GPU_UTIL}%"
else
    echo -e "${YELLOW}SKIPPED${NC} (nvidia-smi not found)"
fi

# Check 3: RAM Status
echo -n "RAM Status... "
RAM_TOTAL=$(free -h | awk '/^Speicher:/ {print $2}')
RAM_USED=$(free -h | awk '/^Speicher:/ {print $3}')
RAM_AVAIL=$(free -h | awk '/^Speicher:/ {print $7}')
echo -e "${GREEN}OK${NC}"
echo "  Used: $RAM_USED / $RAM_TOTAL"
echo "  Available: $RAM_AVAIL"

# Check 4: Swap Status
echo -n "Swap Status... "
SWAP_USED=$(free -h | awk '/^Auslagerung:/ {print $3}')
if [ "$SWAP_USED" = "0B" ] || [ "$SWAP_USED" = "0" ]; then
    echo -e "${GREEN}OK${NC} (No swap used)"
else
    echo -e "${YELLOW}WARNING${NC} (Using swap: $SWAP_USED)"
fi

# Check 5: Model Info
echo -n "Model Info... "
if curl -s "$SERVER_URL/v1/models" | python3 -c "
import sys, json
d = json.load(sys.stdin)
if 'data' in d and len(d['data']) > 0:
    m = d['data'][0]
    print('Loaded:', m.get('id', 'unknown'))
    sys.exit(0)
sys.exit(1)
" 2>/dev/null; then
    echo -e "${GREEN}OK${NC}"
else
    echo -e "${YELLOW}WARNING${NC} (Could not get model info)"
fi

# Check 6: Process Status
echo -n "Llama Server Process... "
if pgrep -f "llama-server" > /dev/null; then
    PID=$(pgrep -f "llama-server" | head -1)
    UPTIME=$(ps -o etime= -p "$PID" 2>/dev/null || echo "unknown")
    echo -e "${GREEN}OK${NC} (PID: $PID, Uptime: $UPTIME)"
else
    echo -e "${RED}FAILED${NC} (No process found)"
fi

# Check 7: Disk Space
echo -n "Disk Space... "
ROOT_FREE=$(df -h / | awk 'NR==2 {print $4}')
if [ "$(df / | awk 'NR==2 {print $5}' | sed 's/%//')" -gt 90 ]; then
    echo -e "${RED}WARNING${NC} (Root low: $ROOT_FREE free)"
else
    echo -e "${GREEN}OK${NC} (Root: $ROOT_FREE free)"
fi

echo ""
echo "=========================================="
echo "  Health Check Complete"
echo "=========================================="
