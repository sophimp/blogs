---
title: AOSP源码同步与编译
uuid: 252
status: publish
date: 2019-03-28 18:02:57
tags: AOSP, ROM
categories: ROM, Android
description: 编译aosp源码的步骤, 编译不会很麻烦， 下载同步有国内的源， 编译有自动化脚本， 然后这是学习android系统，ROM移植的第一步。 
---

## 源码下载

[`国内镜像及教程: https://mirrors.tuna.tsinghua.edu.cn/help/AOSP/`](https://mirrors.tuna.tsinghua.edu.cn/help/AOSP/)

## ubuntu 16.04 基本环境安装

1. 更换软件源

        sudo gedit /etc/apt/sources.list 

        deb http://mirrors.aliyun.com/ubuntu/ quantal main restricted universe multiverse
        deb http://mirrors.aliyun.com/ubuntu/ quantal-security main restricted universe multiverse
        deb http://mirrors.aliyun.com/ubuntu/ quantal-updates main restricted universe multiverse
        deb http://mirrors.aliyun.com/ubuntu/ quantal-proposed main restricted universe multiverse
        deb http://mirrors.aliyun.com/ubuntu/ quantal-backports main restricted universe multiverse
        deb-src http://mirrors.aliyun.com/ubuntu/ quantal main restricted universe multiverse
        deb-src http://mirrors.aliyun.com/ubuntu/ quantal-security main restricted universe multiverse
        deb-src http://mirrors.aliyun.com/ubuntu/ quantal-updates main restricted universe multiverse
        deb-src http://mirrors.aliyun.com/ubuntu/ quantal-proposed main restricted universe multiverse
        deb-src http://mirrors.aliyun.com/ubuntu/ quantal-backports main restricted universe multiverse

2. 安装依赖

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

3. 安装openJDK8

        sudo add-apt-repository ppa:openjdk-r/ppa 
        sudo apt-get update
        sudo apt-get install openjdk-8-jdk 

## 开始编译

[源码编译教程](http://blog.csdn.net/fuchaosz/article/details/51487585)
[分模块编译](https://www.jianshu.com/p/9605f895d153)

1. 在 .bashrc文件末尾添加：export USE_CCACHE = 1

        echo export USE_CCACHE=1 >> ~/.bashrc

2. 为了提高编译效率，设置编译器高速缓存:

        prebuilts/misc/linux-x86/ccache/ccache -M 50G

3. 接着导入编译Android源码所需的环境变量和其它参数:

        source build/envsetup.sh
4. 运行lunch命令选择编译目标:

        lunch

        目标机的Nexus5X 选择 aosp_bullhead-userdebug, 其他型号请查[官方型号对应编译目标]()

5. 切换分支

        [aosp切换源码分支](https://blog.csdn.net/fengxingzhe001/article/details/64921578)
        我选择的是android-8.1.0_r18 目标

        查看可切换分支
        cd .repo/manifests
        git branch -a | cut -d / -f 3

        切换分支
        清华镜像 https://aosp.tuna.tsinghua.edu.cn/
        repo init -u https://android.googlesource.com/platform/manifest -b android-8.1.0_r18
        repo init -u https://aosp.tuna.tsinghua.edu.cn/platform/manifest -b android-8.1.0_r18
        repo sync

        不同版本， 文件结构会有不一致， 切换完成仍需
        repo forall -c git reset --hard
        repo init -u https://android.googlesource.com/platform/manifest -b android-8.1.0_r18
        repo sync

6. 编译

        make -j6
        6代表线程数 一盘是电脑核心数的2倍

## 编译报错
1.  04:21:56 ninja failed with: exit status 1

`build/make/core/main.mk:21: recipe for target 'run_soong_ui' failed
make: *** [run_soong_ui] Error 1

> 解决办法：

    重新安装 libstdc6++:i386
`
2. /bin/bash out/target/common/obj/JAVA_LIBRARIES/framework_intermediates/with-local/classes.dex.rsp
java.lang.IllegalArgumentException: Self-suppression not permitted

3. jack server out of memory error

[解决办法](https://blog.csdn.net/yasin_lee/article/details/53330457)

## 编译结果
- 在ubuntu 16.04 上， 第二次编译8.0的代码， 通过了， 在8G的I3笔记本上， 编译了一天
- 配置好环境后， 编译源码不是问题， linux也不是问题, 按照教程， 没出什么问题， 在环境配置和源码下载上耗费了些时间
- 环境配置出现问题， 直接在google上搜索也都能解决

# mokee

[官方网站](https://www.mokeedev.com/)

## 源码下载
[源码下载](https://bbs.mokeedev.com/t/topic/21)

## 环境配置
如上, 其他的 linux 系统也可以编译, 关键是看怎么配置

## 编译
1. 切换分支
    * mk8.1

        repo init -u https://github.com/Mokee/android -b mko-mr1
        repo sync --force-sync # 降版本用
2. 分支
    * mkp 是主线最新版本
    * mko 是8.0版本, 后面的字符应该是跟谷歌官方对应的
    * 不同版本对makefile作了适配, 不支持的版本想要自支持, 应该也是可以这样干的?

3. 分支切换报错

报错后, 可以重新下载, 关于git 相关的同步文件都保存在 .repo/下, 根据报错路径, 在此文件下, 将对应的文件下删除, 重新下载即可.
暴力方法是将.repo 整个文件夹都删除了, 重新下载. 

出错的原因是什么呢? 切换分支, 残留了文件, git 的信息也有残留, 而不同版本支持的机型不一样, 所以有的第三方的东西就会下载不到.

进入 .repo/manifests/ 下git查看当前分支是否有未提交的文件， 或者git文件损坏,  如果已有完整工程，可以将 manifests.git .git 全部删除，重新copy一份

## 编译结果
	
直接 lunch mk_combo-userdebug, mka bacon 编译，没有问题

## 生成系统签名脚本
```sh
#!/bin/sh

rm shared.*
rm *.keystore

KEYSTORE_NAME=$1

if [ ! -n "$1" ]
then
	KEYSTORE_NAME='mkp_enchilada_system_debug'
fi

# 把pkcs8格式的私钥转化成pkcs12格式：
openssl pkcs8 -in platform.pk8 -inform DER -outform PEM -out shared.priv.pem -nocrypt

# 把x509.pem公钥转换成pkcs12格式： alias: androiddebugkey 密码都是：android
openssl pkcs12 -export -in platform.x509.pem -inkey shared.priv.pem -out shared.pk12 -name androiddebugkey -password pass:android

# 生成platform.keystore
keytool -importkeystore -deststorepass android -destkeypass android -destkeystore $KEYSTORE_NAME.keystore -srckeystore shared.pk12 -srcstoretype PKCS12 -srcstorepass android -alias androiddebugkey

```
