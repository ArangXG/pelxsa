FROM nvidia/cuda:12.4.1-runtime-ubuntu22.04

RUN apt-get update && apt-get install -y \
    libstdc++6 \
    libgomp1 \
    ca-certificates \
    libnuma1 \
    libhwloc15 \
    ocl-icd-libopencl1 \
    && rm -rf /var/lib/apt/lists/*

COPY SRBMiner-MULTI /usr/local/bin/SRBMiner-MULTI
RUN chmod +x /usr/local/bin/SRBMiner-MULTI

# ── CPU Mining · RandomX · Salvium ──────────────────────────
ENV SAL_POOL=de.salvium.herominers.com:1230
ENV SAL_WALLET=SC11ek
ENV SAL_WORKER=SALWORKER
ENV CPU_THREADS=4

# ── GPU Mining · PearlHash · Pearl ───────────────────────────
ENV PRL_POOL=pearl-eu1.luckypool.io:3360
ENV PRL_WALLET=prl1pvxf
ENV PRL_WORKER=PRLWORKER

CMD /usr/local/bin/SRBMiner-MULTI \
    --algorithm-cpu randomx \
    --pool $SAL_POOL \
    --wallet $SAL_WALLET \
    --worker $SAL_WORKER \
    --cpu-threads $CPU_THREADS \
    --algorithm-gpu pearlhash \
    --pool $PRL_POOL \
    --wallet $PRL_WALLET \
    --worker $PRL_WORKER
