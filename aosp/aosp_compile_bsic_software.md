
## ubuntu 16.04 编译aosp, 基本环境安装

sudo apt-get install -y git flex bison gperf build-essential libncurses5-dev:i386
sudo apt-get install libx11-dev:i386 libreadline6-dev:i386 libgl1-mesa-dev g++-multilib
sudo apt-get install tofrodos python-markdown libxml2-utils xsltproc zlib1g-dev:i386
sudo apt-get install dpkg-dev libsdl1.2-dev libesd0-dev
sudo apt-get install git-core gnupg flex bison gperf build-essential
sudo apt-get install zip curl zlib1g-dev gcc-multilib g++-multilib
sudo apt-get install libc6-dev-i386
sudo apt-get install lib32ncurses5-dev x11proto-core-dev libx11-dev
sudo apt-get install lib32z-dev ccache
sudo apt-get install libgl1-mesa-dev libxml2-utils xsltproc unzip m4

## 源码下载

    [国内镜像及教程](https://mirrors.tuna.tsinghua.edu.cn/help/AOSP/)

## 源码编译

    [源码编译教程](https://blog.csdn.net/fuchaosz/article/details/51487585)


## 编译报错
> 04:21:56 ninja failed with: exit status 1
build/make/core/main.mk:21: recipe for target 'run_soong_ui' failed
make: *** [run_soong_ui] Error 1

> 解决办法：

    重新安装 libstdc6++:i386


## 编译结果
- 在ubuntu 16.04 上， 第二次编译9.0的代码， 通过了， 在8G的I3笔记本上， 编译了一天
- 配置好环境后， 编译源码不是问题， linux也不是问题, 按照教程， 没出什么问题， 在环境配置和源码下载上耗费了些时间 i
- 环境配置出现问题， 直接在google上搜索也都能解决

