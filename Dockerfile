FROM phusion/baseimage:0.11

CMD ["/sbin/my_init"]

SHELL ["/bin/bash", "-c"]

ENV LANG C.UTF-8

RUN set -ex; \
    true \
    && sed -i 's/http:\/\/archive\.ubuntu\.com\/ubuntu\//http:\/\/mirrors\.163\.com\/ubuntu\//g' /etc/apt/sources.list \
    && sed -i 's/http:\/\/security\.ubuntu\.com\/ubuntu\//http:\/\/mirrors\.163\.com\/ubuntu\//g' /etc/apt/sources.list \
    && export DEBIAN_FRONTEND=noninteractive \
    && apt-get update \
    && apt-get install -y -q --no-install-recommends \
        wget bzip2 tzdata rsync htop sysstat strace lsof net-tools gettext-base bash-completion netbase \
        gcc python3-dev zlib1g-dev virtualenv \
    && rm -rf /etc/service/sshd \
    && apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime

RUN set -ex; true \
    && virtualenv -p python3 /venv-py3 \
    && mkdir -p ~/.pip && echo -e "[global]\nindex-url = https://pypi.tuna.tsinghua.edu.cn/simple" > ~/.pip/pip.conf \
    && source /venv-py3/bin/activate \
    && pip install ipdb six pyrsistent fn toolz functoolsex pykka cython cffi gevent psutil typing retrying simplejson msgpack apscheduler tzlocal pytz dill requests \
        flask_cors flask-restful pyro4 pika pymongo PyMySQL SQLAlchemy redis python-redis-lock \

    && wget -q https://bitbucket.org/squeaky/portable-pypy/downloads/pypy3.6-7.1.1-beta-linux_x86_64-portable.tar.bz2 -O /tmp/pypy3.tar.bz2 && tar xjf /tmp/pypy3.tar.bz2 -C /opt/ \
    && cd /opt/pypy*/bin/ && ./pypy ./virtualenv-pypy /venv-pypy3 \
    && source /venv-pypy3/bin/activate \
    && pip install ipdb six pyrsistent fn toolz functoolsex pykka cython cffi gevent psutil typing retrying simplejson msgpack apscheduler tzlocal pytz dill requests \
        flask_cors flask-restful pyro4 pika pymongo PyMySQL SQLAlchemy redis python-redis-lock \
    && apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /root/.cache/pip/*
