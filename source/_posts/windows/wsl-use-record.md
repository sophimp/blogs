---
title: WSL 使用的一些指令记录
date: 2021-04-30 14:35:05
tags:
- WSL
categories:
- Windows
description: 记录使用wsl过程中一些指令, 技巧
---

### wsl安装

{% post_link ./wsl-ubuntu-aosp-env.md 安装wsl2 %}`

### wsl 修改安装目录

查看所有分发版本
```cmd
wsl -l --all  -v
```
导出分发版为tar文件到d盘
```cmd
wsl --export Ubuntu-20.04 d:\ubuntu20.04.tar
```
注销当前分发版
```cmd
wsl --unregister Ubuntu-20.04
```

重新导入并安装分发版在d:\ubuntu
```cmd
wsl --import Ubuntu-20.04 d:\ubuntu d:\ubuntu20.04.tar --version 2
```

设置默认登陆用户为安装时用户名
```cmd
ubuntu2004 config --default-user Username
```
删除tar文件(可选)
```cmd
del d:\ubuntu20.04.tar
```
