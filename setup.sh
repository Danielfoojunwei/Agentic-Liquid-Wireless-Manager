#!/bin/bash
# Agentic Liquid Wireless Manager — Quick Setup
# Installs dependencies, loads pre-trained model, and verifies installation.

set -e

echo "=== Agentic Liquid Wireless Manager Setup ==="
echo ""

# 1. Check Python
echo "[1/4] Checking Python..."
if ! command -v python3 &>/dev/null; then
    echo "ERROR: Python 3 is required. Install from https://python.org"
    exit 1
fi
PYVER=$(python3 -c "import sys; print(f'{sys.version_info.major}.{sys.version_info.minor}')")
echo "  Python $PYVER found."

# 2. Install dependencies
echo "[2/4] Installing dependencies..."
pip3 install -q torch numpy 2>/dev/null || pip install -q torch numpy
echo "  Dependencies installed."

# 3. Load pre-trained model
echo "[3/4] Loading pre-trained model weights..."
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
mkdir -p ~/.net-intel

# Copy pre-trained weights (trained on ITU-R/3GPP physics simulation)
if [ -f "$SCRIPT_DIR/model/trained_weights.json" ]; then
    cp "$SCRIPT_DIR/model/trained_weights.json" ~/.net-intel/weights.json
    echo "  Pre-trained weights loaded to ~/.net-intel/weights.json"
elif [ -f "$SCRIPT_DIR/model/trained_model.pt" ]; then
    cp "$SCRIPT_DIR/model/trained_model.pt" ~/.net-intel/trained_model.pt
    # Also generate JSON weights for numpy fallback
    python3 "$SCRIPT_DIR/sac_ltc_agent.py" --init-weights
    echo "  PyTorch model + heuristic weights loaded."
else
    echo "  No pre-trained model found. Generating heuristic weights..."
    python3 "$SCRIPT_DIR/sac_ltc_agent.py" --init-weights
fi

# 4. Self-test
echo "[4/4] Running self-test..."
python3 "$SCRIPT_DIR/sac_ltc_agent.py" --test
echo ""
echo "=== Setup Complete ==="
echo ""
echo "Usage:"
echo "  Quick scan:    python3 $SCRIPT_DIR/sac_ltc_agent.py --explain '<network_json>'"
echo "  Decision:      python3 $SCRIPT_DIR/sac_ltc_agent.py --decide '<network_json>'"
echo "  Presence:      python3 $SCRIPT_DIR/sac_ltc_agent.py --sense '<rssi_json>'"
echo "  Train better:  python3 $SCRIPT_DIR/train_sac_ltc.py --episodes 2000"
echo ""
echo "For Claude Code: copy SKILL.md + sac_ltc_agent.py to your project."
