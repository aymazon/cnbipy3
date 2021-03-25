FROM phusion/baseimage:18.04-1.0.0

CMD ["/sbin/my_init"]

SHELL ["/bin/bash", "-c"]

ENV LANG C.UTF-8

RUN set -ex; \
    true \
    && sed -i 's/http:\/\/archive\.ubuntu\.com\/ubuntu\//http:\/\/mirrors\.aliyun\.com\/ubuntu\//g' /etc/apt/sources.list \
    && sed -i 's/http:\/\/security\.ubuntu\.com\/ubuntu\//http:\/\/mirrors\.aliyun\.com\/ubuntu\//g' /etc/apt/sources.list \
    && export DEBIAN_FRONTEND=noninteractive \
    && apt-get update \
    && apt-get install -y -q --no-install-recommends \
        wget bzip2 tzdata rsync htop sysstat strace lsof net-tools gettext-base bash-completion netbase \
        gcc python3-dev zlib1g-dev virtualenv \
    && echo '$' > /etc/container_environment/ENV_DOLLAR \
    && rm -rf /etc/service/sshd \
    && apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime

RUN set -ex; true \
    && virtualenv -p python3 --no-setuptools --system-site-packages /venv-py3 \
    && mkdir -p ~/.pip && echo -e "[global]\nindex-url = https://mirrors.aliyun.com/simple" > ~/.pip/pip.conf \
    && source /venv-py3/bin/activate \
    && pip install -U pip setuptools \
    && pip install ipdb six pyrsistent fn toolz functoolsex pykka cython cffi gevent psutil typing retrying simplejson msgpack apscheduler tzlocal pytz dill requests \
        flask_cors flask-restful pyro4 pika pymongo PyMySQL SQLAlchemy redis python-redis-lock \
    && wget -q https://downloads.python.org/pypy/pypy3.6-v7.3.3-linux64.tar.bz2 -O /tmp/pypy3.tar.bz2 && tar xjf /tmp/pypy3.tar.bz2 -C /opt/ \
    && cd /opt/pypy*/bin/ && virtualenv -p ./pypy3 --no-setuptools /venv-pypy3 \
    && source /venv-pypy3/bin/activate \
    && pip install -U pip setuptools \
    && pip install ipdb six pyrsistent fn toolz functoolsex pykka cython cffi gevent psutil typing retrying simplejson msgpack apscheduler tzlocal pytz dill requests \
        flask_cors flask-restful pyro4 pika pymongo PyMySQL SQLAlchemy redis python-redis-lock \
    && apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /root/.cache/pip/*
