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

# Download SRBMiner-MULTI versi spesifik (di-passing dari workflow lewat build-arg),
# bukan "latest" yang di-resolve ulang tiap build — jadi image selalu pasti
# dapat versi yang sudah dicek dan dicatat oleh workflow.
ARG SRB_VERSION
RUN test -n "$SRB_VERSION" \
    && SRB_URL=$(wget -qO- "https://api.github.com/repos/doktor83/SRBMiner-Multi/releases/tags/${SRB_VERSION}" \
        | grep -oE '"browser_download_url": *"[^"]*Linux\.tar\.[gx]z"' \
        | grep -oE 'https://[^"]+' \
        | head -n1) \
    && test -n "$SRB_URL" \
    && echo ">>> SRBMiner-MULTI v${SRB_VERSION}: $SRB_URL" \
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
