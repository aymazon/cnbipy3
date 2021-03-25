# cnbipy3
基于 docker baseimage 的基础镜像

1. 修改成中国时区
2. 修改 apt 国内镜像（aliyun）和 pip 的国内镜像（aliyun）
3. 必备的基础工具
4. 禁用默认开启的 sshd 服务
5. 准备 python3 和 pypy3 的虚环境在 /venv-{python3|pypy3}/ 下
