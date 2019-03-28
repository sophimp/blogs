## ubuntu 16.04 编译aosp, 基本安装

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


## 第一次编译
> 04:21:56 ninja failed with: exit status 1
build/make/core/main.mk:21: recipe for target 'run_soong_ui' failed
make: *** [run_soong_ui] Error 1

> 解决办法：
- libstdc6++:i386


## 编译通过
- 在ubuntu 16.04 上， 第二次编译9.0的代码， 通过了， 在8G的I3笔记本上， 编译了一天
- 配置好环境后， 编译源码不是问题， linux也不是问题, 所以这些恐惧确是前期的跘脚石

