
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


## 切换分支

    [aosp切换源码分支](https://blog.csdn.net/fengxingzhe001/article/details/64921578)

    查看可切换分支
    cd .repo/manifests
    git branch -a | cut -d / -f 3

    切换分支
    清华镜像 https://aosp.tuna.tsinghua.edu.cn/
    repo init -u https://android.googlesource.com/platform/manifest -b android-7.0.0_r1
    repo init -u https://android.googlesource.com/platform/manifest -b android-8.1.0_r18
    repo init -u https://aosp.tuna.tsinghua.edu.cn/platform/manifest -b android-8.1.0_r18
    repo sync

    不同版本， 文件结构会有不一致， 切换完成仍需
    repo forall -c git reset --hard
    repo init -u https://android.googlesource.com/platform/manifest -b android-7.0.0_r1
    repo sync


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
- 在ubuntu 16.04 上， 第二次编译9.0的代码， 通过了， 在8G的I3笔记本上， 编译了一天
- 配置好环境后， 编译源码不是问题， linux也不是问题, 按照教程， 没出什么问题， 在环境配置和源码下载上耗费了些时间 i
- 环境配置出现问题， 直接在google上搜索也都能解决

