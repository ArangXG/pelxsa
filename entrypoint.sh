#!/bin/bash

echo "================================================"
echo "  SRBMiner-MULTI Startup Check"
echo "================================================"

# Check NVIDIA driver version
DRIVER_VERSION=$(nvidia-smi --query-gpu=driver_version --format=csv,noheader 2>/dev/null | head -1 | cut -d'.' -f1)

if [ -z "$DRIVER_VERSION" ]; then
    echo "⚠️  WARNING: NVIDIA driver tidak terdeteksi!"
    echo "   GPU mining tidak akan berjalan."
elif [ "$DRIVER_VERSION" -lt 580 ]; then
    echo "❌ NVIDIA Driver v${DRIVER_VERSION} — TERLALU LAMA!"
    echo "   Pearlhash (Blackwell) butuh driver v580+"
    echo "   GPU mining akan gagal. Update driver di host!"
else
    echo "✅ NVIDIA Driver v${DRIVER_VERSION} — OK"
    echo "   GPU pearlhash siap jalan."
fi

# Validate required ENVs
MISSING=0
if [ -z "$SAL_WALLET" ]; then
    echo "❌ SAL_WALLET belum diisi!"
    MISSING=1
fi
if [ -z "$SAL_POOL" ]; then
    echo "❌ SAL_POOL belum diisi!"
    MISSING=1
fi
if [ -z "$PRL_WALLET" ]; then
    echo "❌ PRL_WALLET belum diisi!"
    MISSING=1
fi
if [ -z "$PRL_POOL" ]; then
    echo "❌ PRL_POOL belum diisi!"
    MISSING=1
fi

if [ "$MISSING" -eq 1 ]; then
    echo ""
    echo "Isi semua ENV yang wajib lalu restart container."
    exit 1
fi

echo ""
echo "  SAL_POOL   : $SAL_POOL"
echo "  SAL_WORKER : $SAL_WORKER"
echo "  PRL_POOL   : $PRL_POOL"
echo "  PRL_WORKER : $PRL_WORKER"
echo "  CPU_THREADS: $CPU_THREADS"
echo "================================================"
echo ""

exec /usr/local/bin/SRBMiner-MULTI \
    --algorithm-cpu randomx \
    --pool "$SAL_POOL" \
    --wallet "$SAL_WALLET" \
    --worker "$SAL_WORKER" \
    --cpu-threads "$CPU_THREADS" \
    --algorithm-gpu pearlhash \
    --pool "$PRL_POOL" \
    --wallet "$PRL_WALLET" \
    --worker "$PRL_WORKER"
