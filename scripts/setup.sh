#!/bin/bash
# PlaximoOdin - Setup Script
# Automatisiert die Einrichtung des LLM-Stacks

set -e

echo "═══════════════════════════════════════════════════════════"
echo "         PlaximoOdin LLM Stack Setup"
echo "═══════════════════════════════════════════════════════════"
echo ""

# Farben
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Check ob Script als Root läuft
if [ "$EUID" -eq 0 ]; then
    echo -e "${RED}FEHLER: Script nicht als Root ausführen!${NC}"
    exit 1
fi

# System-Check
echo "📋 System-Check..."
echo "─────────────────────"
echo "Hostname: $(hostname)"
echo "Kernel: $(uname -r)"
echo "CPU: $(nproc) Kerne"
echo ""

# Check NVIDIA
if command -v nvidia-smi &> /dev/null; then
    echo -e "${GREEN}✓ NVIDIA GPU erkannt${NC}"
    nvidia-smi --query-gpu=name,memory.total --format=csv,noheader
else
    echo -e "${YELLOW}⚠ Keine NVIDIA GPU erkannt${NC}"
fi
echo ""

# 1. Ubuntu Updates
echo "📦 Update System..."
sudo apt update -qq
echo -e "${GREEN}✓ System aktualisiert${NC}"
echo ""

# 2. Basis-Tools
echo "🔧 Installiere Basis-Tools..."
sudo apt install -y build-essential cmake git curl wget
echo -e "${GREEN}✓ Basis-Tools installiert${NC}"
echo ""

# 3. CUDA Toolkit (falls nicht vorhanden)
if ! command -v nvcc &> /dev/null; then
    echo "📦 Installiere CUDA Toolkit..."
    # Hier nur den Hinweis ausgeben, da CUDA schon installiert ist
    echo -e "${YELLOW}⚠ CUDA Toolkit bereits installiert${NC}"
else
    echo -e "${GREEN}✓ CUDA Toolkit: $(nvcc --version | grep "release" | awk '{print $5}')${NC}"
fi
echo ""

# 4. Python Virtual Environment
echo "🐍 Setup Python Virtual Environment..."
if [ ! -d "$HOME/llm-venv" ]; then
    python3 -m venv $HOME/llm-venv
    echo -e "${GREEN}✓ Virtual Environment erstellt${NC}"
else
    echo -e "${YELLOW}⚠ Virtual Environment existiert bereits${NC}"
fi
echo ""

# 5. Python Packages
echo "📚 Installiere Python Packages..."
source $HOME/llm-venv/bin/activate
pip install --upgrade pip
pip install huggingface_hub httpx typer rich tqdm
echo -e "${GREEN}✓ Python Packages installiert${NC}"
deactivate
echo ""

# 6. llama.cpp
echo "🔨 Setup llama.cpp..."
if [ ! -d "$HOME/llama.cpp" ]; then
    echo "Clone llama.cpp Repository..."
    git clone https://github.com/ggml-org/llama.cpp.git $HOME/llama.cpp
fi

cd $HOME/llama.cpp
mkdir -p build && cd build
  cmake .. -DGGML_CUDA=ON
make -j$(nproc)
echo -e "${GREEN}✓ llama.cpp kompiliert${NC}"
cd ~
echo ""

# 7. GitHub CLI
echo "🐙 Installiere GitHub CLI..."
if ! command -v gh &> /dev/null; then
    curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg
    sudo chmod go+r /usr/share/keyrings/githubcli-archive-keyring.gpg
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null
    sudo apt update -qq
    sudo apt install -y gh
    echo -e "${GREEN}✓ GitHub CLI installiert${NC}"
else
    echo -e "${YELLOW}⚠ GitHub CLI bereits installiert${NC}"
fi
echo ""

echo "═══════════════════════════════════════════════════════════"
echo -e "${GREEN}         Setup abgeschlossen!${NC}"
echo "═══════════════════════════════════════════════════════════"
echo ""
echo "Nächste Schritte:"
echo "─────────────────"
echo "1. GitHub Auth: gh auth login"
echo "2. Modell herunterladen:"
echo "   source ~/llm-venv/bin/activate"
echo "   huggingface-cli download <model>"
echo ""
echo "3. Server starten:"
echo "   cd ~/llama.cpp/build/bin"
echo "   ./llama-server -m <model.gguf> -c 4096 -ngl 99"
echo ""
