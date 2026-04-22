#!/usr/bin/env bash
# PlaximoOdin - Validation Test Suite
# Validiert die Qwen 3.6 Production-Umgebung

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${YELLOW}=== PlaximoOdin Test Suite ===${NC}"

# 1. NVIDIA Validation
echo -n "Checking NVIDIA GPU... "
if nvidia-smi > /dev/null 2>&1; then
    echo -e "${GREEN}PASS${NC}"
else
    echo -e "${RED}FAIL (NVIDIA Driver/Hardware not found)${NC}"
fi

# 2. Llama-Server Reachability
echo -n "Checking llama-server (/v1/models)... "
RESPONSE=$(curl -s -o /dev/null -w "%{http_code}" localhost:8080/v1/models)
if [ "$RESPONSE" == "200" ]; then
    echo -e "${GREEN}PASS${NC}"
else
    echo -e "${RED}FAIL (HTTP $RESPONSE)${NC}"
fi

# 3. Model Verification
echo -n "Verifying loaded model... "
MODEL_NAME=$(curl -s localhost:8080/v1/models | grep -oP '"id":\s*"\K[^"]+')
if [[ "$MODEL_NAME" == *"Qwen3.6"* ]] || [[ "$MODEL_NAME" == *"Qwen3.5"* ]]; then
    echo -e "${GREEN}PASS ($MODEL_NAME)${NC}"
else
    echo -e "${RED}FAIL (Unexpected model: $MODEL_NAME)${NC}"
fi

# 4. Tool Call Simulation (Mock)
echo -n "Testing Tool Call capability... "
# Wir senden eine Test-Anfrage mit Tool-Definition
TOOL_TEST=$(curl -s -X POST http://localhost:8080/v1/chat/completions \
  -H "Content-Type: application/json" \
  -d '{
    "messages": [{"role": "user", "content": "What is the current directory?"}],
    "tools": [{
      "type": "function",
      "function": {
        "name": "bash_exec",
        "parameters": {"type": "object", "properties": {"command": {"type": "string"}}}
      }
    }]
  }')

if echo "$TOOL_TEST" | grep -q "tool_call"; then
    echo -e "${GREEN}PASS${NC}"
else
    echo -e "${YELLOW}WARNING (No tool_call in response - might be expected depending on prompt)${NC}"
fi

# 5. Systemd Service (Optional)
echo -n "Checking Systemd service status... "
if systemctl is-active --quiet plaximo-odin > /dev/null 2>&1; then
    echo -e "${GREEN}ACTIVE${NC}"
else
    echo -e "${YELLOW}NOT CONFIGURED (Optional)${NC}"
fi

echo -e "${YELLOW}=== End of Tests ===${NC}"
