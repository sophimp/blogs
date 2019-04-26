
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

