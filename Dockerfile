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

COPY SRBMiner-MULTI /usr/local/bin/SRBMiner-MULTI
COPY entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/SRBMiner-MULTI /usr/local/bin/entrypoint.sh

# ── CPU Mining · RandomX · Salvium ──────────────────────────
ENV SAL_POOL=
ENV SAL_WALLET=
ENV SAL_WORKER=worker

# ── GPU Mining · PearlHash · Pearl ───────────────────────────
ENV PRL_POOL=
ENV PRL_WALLET=
ENV PRL_WORKER=worker

ENV CPU_THREADS=4

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
