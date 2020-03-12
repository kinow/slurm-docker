FROM ubuntu:latest

ENV DEBIAN_FRONTEND noninteractive

# Based on:
#  - https://bitbucket.org/deardooley/agave-docker/src/master/test-containers/schedulers/slurm/Dockerfile
#  - https://ubuntuforums.org/showthread.php?t=2404746

RUN apt-get update && apt-get install -y \
    munge \
    openssh-server \
    slurm-wlm \
    supervisor \
 && rm -rf /var/lib/apt/lists/*

RUN set -x \
    && mkdir /var/spool/slurmd \
        /var/run/slurmd \
        /var/run/slurmdbd \
        /var/lib/slurmd \
        /var/log/slurm \
        /var/run/munge \
        /run/sshd \
    && touch /var/lib/slurmd/node_state \
        /var/lib/slurmd/front_end_state \
        /var/lib/slurmd/job_state \
        /var/lib/slurmd/resv_state \
        /var/lib/slurmd/trigger_state \
        /var/lib/slurmd/assoc_mgr_state \
        /var/lib/slurmd/assoc_usage \
        /var/lib/slurmd/qos_usage \
        /var/lib/slurmd/fed_mgr_state \
    && /usr/sbin/create-munge-key -f \
    && chown -R slurm:slurm /var/*/slurm* \
    && chown -R root:root /var/log/munge \
	&& chown -R root:root /var/lib/munge \
	&& chown -R root:root /var/run/munge \
	&& chown -R root:root /etc/munge

RUN sed -i s/#PermitRootLogin.*/PermitRootLogin\ yes/ /etc/ssh/sshd_config

COPY slurm.conf /etc/slurm-llnl/slurm.conf

COPY supervisord.conf /etc/supervisord.conf

# USER testuser
RUN addgroup testuser
RUN useradd -rm -d /home/testuser -s /bin/bash -g testuser -u 1000 testuser && \
	echo "testuser:testuser" | chpasswd
COPY slurm.submit /home/testuser/slurm.submit

EXPOSE 10389 22 6817 6818
CMD /usr/bin/supervisord
