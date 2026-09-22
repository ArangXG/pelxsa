FROM nvidia/cuda:12.8.0-runtime-ubuntu22.04

RUN apt-get update && apt-get install -y \
    libstdc++6 \
    libgomp1 \
    ca-certificates \
    libnuma1 \
    libhwloc15 \
    ocl-icd-libopencl1 \
    wget \
    && rm -rf /var/lib/apt/lists/*

# Auto-deteksi link download SRBMiner-MULTI TERBARU langsung dari GitHub
# releases resmi doktor83/SRBMiner-Multi (Linux build).
# CACHEBUST dikasih nilai unik dari workflow tiap run, biar layer ini
# selalu dicek ulang (nggak ke-cache Docker) dan bisa nangkep rilis baru.
ARG CACHEBUST=1
RUN SRB_URL=$(wget -qO- https://api.github.com/repos/doktor83/SRBMiner-Multi/releases/latest \
        | grep -oE '"browser_download_url": *"[^"]*Linux\.tar\.[gx]z"' \
        | grep -oE 'https://[^"]+' \
        | head -n1) \
    && test -n "$SRB_URL" \
    && echo ">>> URL SRBMiner-MULTI terdeteksi: $SRB_URL" \
    && wget -q "$SRB_URL" -O /tmp/srb.tar \
    && mkdir -p /tmp/srb \
    && tar -xf /tmp/srb.tar -C /tmp/srb \
    && find /tmp/srb -type f -name "SRBMiner-MULTI" -exec cp {} /usr/local/bin/SRBMiner-MULTI \; \
    && chmod +x /usr/local/bin/SRBMiner-MULTI \
    && rm -rf /tmp/srb /tmp/srb.tar

COPY entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

# ── GPU Mining · PearlHash · Pearl · NVIDIA ──────────────────
ENV PRL_POOL=
ENV PRL_WALLET=
ENV PRL_WORKER=

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
