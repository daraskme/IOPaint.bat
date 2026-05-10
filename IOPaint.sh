#!/bin/bash
# IOPaint Launcher for macOS

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
IOPAINT_DIR="$SCRIPT_DIR/IOPaint"

if [ -f "$IOPAINT_DIR/venv/bin/activate" ]; then
    goto_start=true
else
    goto_start=false
fi

if [ "$goto_start" = false ]; then
    echo "[1/5] Creating IOPaint folder..."
    mkdir -p "$IOPAINT_DIR"
    cd "$IOPAINT_DIR"

    echo "[2/5] Creating virtual environment with Python 3.11..."
    PYTHON=""
    for cmd in python3.11 python3 python; do
        if command -v "$cmd" &>/dev/null && "$cmd" --version 2>&1 | grep -q "3\.11"; then
            PYTHON="$cmd"
            break
        fi
    done

    if [ -z "$PYTHON" ]; then
        echo "ERROR: Python 3.11 not found."
        echo "Please install Python 3.11 from:"
        echo "https://www.python.org/downloads/release/python-3119/"
        read -p "Press Enter to exit..."
        exit 1
    fi

    "$PYTHON" -m venv venv
    if [ $? -ne 0 ]; then
        echo "ERROR: Failed to create virtual environment."
        read -p "Press Enter to exit..."
        exit 1
    fi

    echo "[3/5] Upgrading pip and build tools..."
    venv/bin/python -m pip install --upgrade pip setuptools wheel

    echo "[4/5] Installing PyTorch..."
    # macOS uses MPS (Apple Silicon) or CPU — no CUDA
    venv/bin/pip install torch torchvision
    if [ $? -ne 0 ]; then
        echo "ERROR: PyTorch install failed."
        read -p "Press Enter to exit..."
        exit 1
    fi

    echo "[5/5] Installing IOPaint..."
    venv/bin/pip install iopaint
    if [ $? -ne 0 ]; then
        echo "ERROR: IOPaint install failed."
        read -p "Press Enter to exit..."
        exit 1
    fi

    echo "Install complete!"
fi

cd "$IOPAINT_DIR"
echo "Starting IOPaint..."
echo "Open http://localhost:8080 in your browser"
echo "Press Ctrl+C to stop."

# Detect device: MPS (Apple Silicon) > CPU
venv/bin/python -c "import torch; exit(0 if torch.backends.mps.is_available() else 1)" 2>/dev/null
if [ $? -eq 0 ]; then
    echo "Mode: MPS (Apple Silicon GPU)"
    open "http://localhost:8080" 2>/dev/null &
    venv/bin/iopaint start --model=lama --device=mps --port=8080
else
    echo "Mode: CPU"
    open "http://localhost:8080" 2>/dev/null &
    venv/bin/iopaint start --model=lama --device=cpu --port=8080
fi
