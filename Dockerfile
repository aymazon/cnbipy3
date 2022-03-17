FROM phusion/baseimage:focal-1.2.0

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
        wget bzip2 tzdata rsync htop iotop iftop sysstat strace lsof net-tools gettext-base bash-completion netbase dnsutils \
    && apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /root/.cache/pip/*

RUN cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime

RUN set -ex; true \
    && export DEBIAN_FRONTEND=noninteractive \
    && apt-get update \
    && apt-get install -y -q --no-install-recommends \
        gcc python3-dev zlib1g-dev virtualenv \
    && echo -e "alias activate-py3='source /venv-py3/bin/activate'" >> /root/.bashrc \
    && virtualenv -p python3 --no-setuptools --system-site-packages /venv-py3 \
    && mkdir -p ~/.pip && echo -e "[global]\nindex-url = https://mirrors.aliyun.com/pypi/simple" > ~/.pip/pip.conf \
    && source /venv-py3/bin/activate \
    && pip install -U pip setuptools \
    && pip install six pyrsistent fn toolz cytoolz functoolsex pysnooper pprofile ipython ipdb debugpy \
    && echo -e "alias activate-pypy3='source /venv-pypy3/bin/activate'" >> /root/.bashrc \
    && wget -q https://downloads.python.org/pypy/pypy3.8-v7.3.8-linux64.tar.bz2 -O /tmp/pypy3.tar.bz2 && tar xjf /tmp/pypy3.tar.bz2 -C /opt/ \
    && cd /opt/pypy*/bin/ && virtualenv -p ./pypy3 --no-setuptools /venv-pypy3 \
    && source /venv-pypy3/bin/activate \
    && curl -sS https://bootstrap.pypa.io/get-pip.py | python3 \
    && pip install -U setuptools \
    && pip install six pyrsistent fn toolz functoolsex pysnooper pprofile ipython ipdb debugpy \
    && apt autoremove -y gcc python3-dev \
    && apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /root/.cache/pip/*
