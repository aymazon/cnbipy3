# cnbipy3
基于 docker baseimage 的基础镜像

1. 修改成中国时区
2. 修改 apt 国内镜像（aliyun）和 pip 的国内镜像（aliyun）
3. 必备的基础分析工具和基础函数库
4. 禁用默认开启的 sshd 服务
5. 准备 python3 的虚环境在 /venv-py3/ 下, 可以使用 activate-py3 来激活虚环境

总共大小 250M 左右, 使用如下命令进行探索, 其余参考 baseimage 官方文档
``` bash
docker run --rm -it --cap-add=SYS_PTRACE aymazon/cnbipy3 /sbin/my_init --skip-startup-files --skip-runit --quiet -- bash -l
```
