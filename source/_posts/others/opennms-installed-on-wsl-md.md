---
title: 在windows wsl2 下配置OpenNMS
date: 2020-12-24 10:11:31
tags:
categories:
- openNMS
description: openNMS是一个网管系统
---

### 背景

在windows 上配置没搞定，需要 jrrd2.dll 工具，暂时未找到预编译的版本，编译rrdtool源码，需要手动下载很多依赖库。

不想在虚拟机中开发，因此采用windows下开发， wsl中编译部署方案。

### opennms
[官方文档](https://qoswork.github.io/odoc/guide-install/index.html#_%E5%9C%A8_debian_%E4%B8%8A%E5%AE%89%E8%A3%85)

[github库](https://github.com/OpenNMS/opennms)

代码中的 readme 有相关源码编译布署的资料。

### postgresql

wsl2 中不能直接使用 systemctl, 有一个折中方法， 是下载一个[python2 版本的systemctl](https://superuser.com/questions/1556609/how-to-enable-systemd-on-wsl2-ubuntu-20-and-centos-8)

```sh
# 备份原有的systemctl
which systemctl
mv /usr/bin/systemctl /usr/bin/systemctl.old

# 下载python2.7, ubuntu 20.04 默认装有3.8.5
sudo apt install python2
sudo ln -s /usr/bin/python2 /usr/bin/python

# 下载python 版本的 systemctl
curl https://raw.githubusercontent.com/gdraheim/docker-systemctl-replacement/master/files/docker/systemctl.py >temp
sudo mv temp /usr/bin/systemctl
sudo chmod +x /usr/bin/systemctl
```

这样需然可以使用systemctl, 但是用来启动postgresql 服务还是不能。 

使用 service 来启动 postgresql 服务是可行的。
[在wsl中启动postgresql](https://harshityadav95.medium.com/postgresql-in-windows-subsystem-for-linux-wsl-6dc751ac1ff3)
```sh
sudo service postgresql start
```
接下来就是创建用户， 数据库
```sh
sudo -u postgres createuser postgres
sudo -u postgres createdb opennms
sudo -u postgres psql
psql=# alter user <username> with encrypted password '<password>';
```
缺少 jrrd/jrrd2 库， 直接下载

### 架构

horizon, minion, sentinel 这三个库的关系。 

通过 8980, opennms 网页访问的是horizon 的界面，与 pgAdmin又是什么关系。 pgAdmin 又要怎么去配置?


