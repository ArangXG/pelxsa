#!/bin/bash

echo "================================================"
echo "  SRBMiner-MULTI · Pearlhash Startup Check"
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
echo "  PRL_POOL   : $PRL_POOL"
echo "  PRL_WORKER : $PRL_WORKER"
echo "================================================"
echo ""

/usr/local/bin/SRBMiner-MULTI \
    --disable-cpu \
    --algorithm pearlhash \
    --pool "$PRL_POOL" \
    --wallet "$PRL_WALLET" \
    --worker "$PRL_WORKER" 2>&1

EXIT_CODE=$?
echo ""
echo "❌ SRBMiner berhenti dengan exit code: $EXIT_CODE"
exit $EXIT_CODE
