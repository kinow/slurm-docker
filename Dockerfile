FROM ubuntu:latest

RUN apt-get update && apt-get install -y \
    munge \
    slurm-wlm \
 && rm -rf /var/lib/apt/lists/*

RUN addgroup -S slurm
RUN useradd -rm -d /home/slurm -s /bin/bash -g slurm -u 1000 slurm && \
	echo "slurm:slurm" | chpasswd

COPY slurm.conf /etc/sysconfig/slurm/slurm.conf

USER slurm
COPY slurm.submit /home/slurm/slurm.submit
WORKDIR /home/slurm

CMD [""]
