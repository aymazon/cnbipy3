FROM phusion/baseimage:focal-1.0.0

CMD ["/sbin/my_init"]

SHELL ["/bin/bash", "-c"]

ENV LANG C.UTF-8

RUN set -ex; true \
    && echo '$' > /etc/container_environment/ENV_DOLLAR \
    && rm -rf /etc/service/sshd \
    && sed -i 's/http:\/\/archive\.ubuntu\.com\/ubuntu\//http:\/\/mirrors\.aliyun\.com\/ubuntu\//g' /etc/apt/sources.list \
    && sed -i 's/http:\/\/security\.ubuntu\.com\/ubuntu\//http:\/\/mirrors\.aliyun\.com\/ubuntu\//g' /etc/apt/sources.list \
    && export DEBIAN_FRONTEND=noninteractive \
    && apt-get update \
    && apt-get install -y -q --no-install-recommends \
        wget bzip2 tzdata rsync htop sysstat strace lsof net-tools gettext-base bash-completion netbase dnsutils \
        gcc python3-dev zlib1g-dev virtualenv \
    && virtualenv -p python3 --no-setuptools --system-site-packages /venv-py3 \
    && echo -e "alias activate-py3='source /venv-py3/bin/activate'\n" >> /root/.bashrc \
    && mkdir -p ~/.pip && echo -e "[global]\nindex-url = https://mirrors.aliyun.com/pypi/simple" > ~/.pip/pip.conf \
    && source /venv-py3/bin/activate \
    && pip install -U pip setuptools \
    && pip install six pyrsistent fn toolz cytoolz functoolsex pysnooper pprofile \
    && apt autoremove -y gcc python3-dev \
    && apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /root/.cache/pip/*

RUN cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
