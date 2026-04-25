@echo off
title IOPaint Launcher

cd /d "%~dp0"

set IOPAINT_DIR=%~dp0IOPaint

if exist "%IOPAINT_DIR%\venv\Scripts\activate.bat" (
    goto :START
) else (
    goto :INSTALL
)

:INSTALL
echo [1/5] Creating IOPaint folder...
if not exist "%IOPAINT_DIR%" mkdir "%IOPAINT_DIR%"
cd /d "%IOPAINT_DIR%"

echo [2/5] Creating virtual environment with Python 3.11...
py -3.11 -m venv venv
if errorlevel 1 (
    echo ERROR: Python 3.11 not found.
    echo Please install Python 3.11 from:
    echo https://www.python.org/downloads/release/python-3119/
    pause
    exit /b 1
)

echo [3/5] Upgrading pip and build tools...
venv\Scripts\python.exe -m pip install --upgrade pip setuptools wheel

echo [4/5] Installing PyTorch (CUDA 11.8)...
venv\Scripts\pip.exe install torch torchvision --index-url https://download.pytorch.org/whl/cu118
if errorlevel 1 (
    echo GPU version failed. Trying CPU version...
    venv\Scripts\pip.exe install torch torchvision
)

echo [5/5] Installing IOPaint...
venv\Scripts\pip.exe install iopaint
if errorlevel 1 (
    echo ERROR: IOPaint install failed.
    pause
    exit /b 1
)

echo Install complete!
goto :START

:START
cd /d "%IOPAINT_DIR%"
echo Starting IOPaint...
echo Open http://localhost:8080 in your browser
echo Press Ctrl+C to stop.

venv\Scripts\python.exe -c "import torch; exit(0 if torch.cuda.is_available() else 1)" 2>nul
if errorlevel 1 (
    echo Mode: CPU
    start "" http://localhost:8080
    venv\Scripts\iopaint.exe start --model=lama --device=cpu --port=8080
) else (
    echo Mode: CUDA GPU
    start "" http://localhost:8080
    venv\Scripts\iopaint.exe start --model=lama --device=cuda --port=8080
)

pause
