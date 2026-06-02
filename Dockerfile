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
ENV SAL_WALLET=SC11ek6hd6A4HBdVYhag5c14mi9q1azaUUWPuXUKojxnCqmHHuKY2JuQU4RaxYBUdij4SmZVMfgSrj8KDbx444ND57QqstBVEu
ENV SAL_WORKER=sp49sensational-hyena
ENV CPU_THREADS=8

# ── GPU Mining · PearlHash · Pearl ───────────────────────────
ENV PRL_POOL=pearl-eu1.luckypool.io:3360
ENV PRL_WALLET=prl1pvxf2ljgw6xw32fzwjftt660m7jny6hl2lp7n5c3dq6w5a8maekpqwjpge8
ENV PRL_WORKER=sp49sensational-hyena

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
