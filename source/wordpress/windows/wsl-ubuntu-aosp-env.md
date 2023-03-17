---
title: wsl 下配置aosp环境
uuid: 387
status: publish
date: 2021-03-25 10:10:42
tags: wsl, aosp
categories: Windows
description: windows下有了wsl, 对于跨平台开发确实方便很多，然而wsl还不成熟，`/`下的文件系统是VolFs, 而/mnt下使用的是DrvFs, 且wsl的运行格式是x86而linux下运行格式是elf32, 本文是记录在wsl下配置aosp的编译环境问题。

---

## 光标配置

windows terminal 配置同步在 [sophimp/vim](https://gitee.com/sophimp/vim) win_terminal_settings.json中

## 安装wsl2

[参考文章](https://www.omgubuntu.co.uk/how-to-install-wsl2-on-windows-10)

1. 安装wsl2 需要以下条件
	- Windows 10 May 2020 (2004), Windows 10 May 2019 (1903), or Windows 10 November 2019 (1909) or later
	- BIOS打开 Hyper-V Virtualization 支持

2. 允许 wsl 

管理员打开powershell, 执行
```sh
dism.exe /online /enable-feature /featurename:Microsoft-Windows-Subsystem-Linux /all /norestart
```

3. 允许`Virtual Machine Platform`

 Windows 10 (2004+) 命令
```sh
dism.exe /online /enable-feature /featurename:VirtualMachinePlatform /all /norestart
```

Windows 10 (1903+, 1909+) 命令
```sh
Enable-WindowsOptionalFeature -Online -FeatureName VirtualMachinePlatform -NoRestart
```

4. 设计 wsl2 为default

执行命令
```sh
wsl --set-default-version 2
```

5. 安装Ubuntu发行版

通过microsoft store 搜索喜欢的linux发行版安装。 

或者在cmd通过命令查找在线的发行版
```sh
wsl --list --online
wsl --install Ubuntu-20.04
```

如果是windows10 企业版, 可能没有装microsoft store, 安装可参考 {% post_link windows/microsoft-app-store-install-on-enterprise %}

到此，可以正常使用wsl了

## 安装archlinux

也有很多渠道可以安装

1. microsoft app store 搜索 archlinux安装

这个途径安装的不是最新的，问题比较多
有时间折腾的, 可以从这个安装，锻炼解决问题的能力, archlinux本身是滚动更新，搞定了环境后，相对也容易升级到最新版本。

2. 通过[yuk7/container-systemd-init-tool](https://github.com/yuk7/container-systemd-init-tool) 安装
  这个安装的也是别人打包好的，好久没有维护了，但是网上有很多教程是依赖于这个的

3. 通过[DDoSolitary/LxRunOffline](https://github.com/DDoSolitary/LxRunOffline/wiki) 安装

虽然这个工具也好久没有维护了， 但是这个工具是离线安装工具，可以自行下载最新的 arhclinux。
参考[在Wsl2 中安装 Archlinux](https://zhuanlan.zhihu.com/p/266585727)
鉴于链接有可能失效，再加上实践的过程中有些出入，还是将记录总结如下： 

1. 下载Archlinux [https://mirrors.tuna.tsinghua.edu.cn/archlinux/iso/latest/](https://mirrors.tuna.tsinghua.edu.cn/archlinux/iso/latest/)

找到 archlinux-bootstrap-2023.03.01-x86_64.tar.gz， 注意时间找当前最新的，后缀是 tar.gz文件

2. 安装archlinux到WSL

```cmd
LxRunOffline i -n (自定义名称) -f (Arch镜像位置) -d (安装系统的位置) -r root.x86_64
# 比如：
LxRunOffline i -n ArchLinux -f C:\Users\kainhuck\Downloads\archlinux-bootstrap-2020.10.01-x86_64.tar.gz -d C:\Users\kainhuck\Linux -r root.x86_64
wsl --set-version ArchLinux 2
```
3. 进入系统

```cmd
# 这里的Archlinux是上一步安装的时候自己定义的名字
wsl -d ArchLinux
```
在这里我们就进入了archlinux内部，然后以下操作在archlinux中进行
这里可以先ping一下archlinux是不是有网络, 如果没有网络，检测/etc/resolv.conf 的DNS是否配置好, 或者删除，会再次自动生成
执行命令

```sh
rm /etc/resolv.conf
重新启动Archlinux
exit
```
执行上述命令后会退出arch,回到powershell,然后在powershell中执行

```cmd
wsl --shutdown ArchLinux
然后再次进入Arch
wsl -d ArchLinux
在Arch中执行
cd /etc/
explorer.exe .
```
注意后面的点，执行这条命令后会用windows的文件管理器打开/etc目录，

> 这里只是为了方便使用windows下的编辑器来编辑archlinux下的配置文件 
> 为什么不直接在archlinux里修改呢？ 是因为上面下载的archlinux只有一个默认编辑器nano, 也安装不了vim, 当然如果习惯使用nano编辑， 也可以直接在archlinux中编辑

接下来就是配置archlinux的国内源，还是因为墙的原因
找到pacman.conf，在这个文件最后加入
```conf
[archlinuxcn]
Server = https://mirrors.tuna.tsinghua.edu.cn/archlinuxcn/$arch
```
然后进入下一级目录pacman.d,编辑里面的mirrolist文件，将China的源注释去掉（选择部分即可）

然后回到Arch，执行

```sh
pacman -Syy
pacman-key --init
pacman-key --populate
pacman -S archlinuxcn-keyring
pacman -S base base-devel vim git wget curl
```
然后别忘了给当前的root设置密码

```sh
passwd
```

然后新建一个普通用户

```sh
useradd -m -G wheel -s /bin/bash (用户名)
passwd (用户名)
```

将创建用户添加到sudoers 中，方便使用sudo

```sh
vim /etc/sudoers
# 将文件`/etc/sudoers中的wheel ALL=(ALL)` ALL那一行前面的注释去掉
```
查看当前用户id, 后面配置打开Archlinux默认使用当前普通用户用得到

```sh
id -u (用户名, 上面添加的用户)

```

4. 设置使用普通用户登录Archlinux
紧接上一步，退出Arch

在powershell中执行

```cmd
exit
lxrunoffline su -n (你的arch名字) -v (账户id)
# 如：

lxrunoffline su -n ArchLinux -v 1000

```

至此ArchLinux已经可以使用了

5. 接下来可以配置windows terminal，可提升体验

从microsoft app store 或 github [Windows Terminal](https://github.com/microsoft/terminal/releases)上下载安装即可
具体的配置，自行查询，也比较简单

## 将发行版由wsl1 转到 wsl2上来

```sh
wsl.exe --set-version Ubuntu 2
```
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

## aosp的源码环境同步


同步aosp源码，建议采取[科大ustc的源](https://lug.ustc.edu.cn/wiki/mirrors/help/aosp/), 清华tuna.tsinghua的源现在限制太多，下载非常慢。 当然，可能随着时间的推移，科大的源可能也会因为人多的原因，下载变慢，到时候再替换成企业的源。

大致步骤参考上面链接，以下简单记录。

1. 下载repo

```sh
mkdir ~/bin
PATH=~/bin:$PATH
curl -sSL  'https://gerrit-googlesource.proxy.ustclug.org/git-repo/+/master/repo?format=TEXT' |base64 -d > ~/bin/repo
chmod a+x ~/bin/repo
```
这里repo 放在~/bin下，后面如果再要同步，还要将其添加到环境变量，因此可以放在.bashrc(默认bash), .zshrc(zsh), .profile(通用)
```sh
export PATH=~/BIN:$PATH
```
2. 修改repo 里面的链接

编辑 ~/bin/repo，把 REPO_URL 一行替换成下面的：
REPO_URL = 'https://gerrit-googlesource.proxy.ustclug.org/git-repo'

3. 初始化仓库
```sh
repo init -u git://mirrors.ustc.edu.cn/aosp/platform/manifest
```
上面命令是同步最新的源码，如果需要同步某个[特定的版本](https://source.android.google.cn/setup/start/build-numbers?hl=zh-cn)。
```sh
repo init -u git://mirrors.ustc.edu.cn/aosp/platform/manifest -b android-4.0.1_r1
```

4. 修改成科大的源
修改 .repo/manifests.git/config ，将

```sh
url = https://android.googlesource.com/platform/manifest
```
修改成
```sh
url = git://mirrors.ustc.edu.cn/aosp/platform/manifest
```

或者修改.repo/manifests/default.xml 
将其中 review="https://android-review.googlesource.com/" 的链接修改为
```sh
url = git://mirrors.ustc.edu.cn/aosp/platform/manifest
```

5. 同步 aosp码 
```sh
repo sync
```

6. 遇到的问题

 同步aosp 源码，会提示./repo/manifests 有修改，要先提交，通过git diff 查看，没有修改，只有old version 644, new version 766 之类的提示。使用chmod 还修改不了文件权限。
这就是 wsl 的文件系统权限问题，可参考[DrvFs 文件系统权限问题](https://p3terx.com/archives/problems-and-solutions-encountered-in-wsl-use-2.html) 来配置。

主要是修改 /etc/wsl.conf 文件, 如果没有wsl.conf文件，创建一个, 添加以下配置, 然后重启wsl
```txt
[automount]
options = "metadata,umask=22,fmask=111"
```

到这里repo sync 不会再提示 ./repo/manifests/下有修改， 需要先commit的错误了， 进入./repo/manifests 下查看 git status 也没了修改。 
但是还会提示
```txt
shutil.Error: [(<DirEntry 'heads'>, '/mnt/e/aosp/aosp/.repo/projects/tools/tradefederation/core.git/refs/heads', "[Errno 13] Permission denied: '/mnt/e/aosp/aosp/.repo/projects/tools/tradefederation/core.git/refs/heads'"), (<DirEntry 'tags'>, '/mnt/e/aosp/aosp/.repo/projects/tools/tradefederation/core.git/refs/tags', "[Errno 13] Permission denied: '/mnt/e/aosp/aosp/.repo/projects/tools/tradefederation/core.git/refs/tags'"), ('/mnt/e/aosp/aosp/.repo/project-objects/platform/tools/tradefederation.git/refs', '/mnt/e/aosp/aosp/.repo/projects/tools/tradefederation/core.git/refs', "[Errno 13] Permission denied: '/mnt/e/aosp/aosp/.repo/projects/tools/tradefederation/core.git/refs'")]
```
这里Permission denied 还是文件权限问题。这里需要以管理员身份来运行wsl, 然后再同步即可。

## aosp的源码编译环境

wsl 1.0 版本要编译aosp, 还有很多问题，主要是文件系统与linux elf32格式的运行问题。

建议升级到wsl2编译，可[参考此篇文章](https://www.vectoros.club/post/fe9083b4.html)

没有权限问题和可执行文件的问题，编译aosp已有的机型还是比较容易的。按照官方指令即可。难的是移植机型。

目前我移植过两款机型 努比亚 z18mini (nx611j) 和 红米k30 pro (redmi_k30_pro)，经验有限。
其中 nx611j 的Mokee 和 LineageOS可以跑起来。redmi_k30_pro 内核替换成功，但是Mokee和LineageOs一直卡在开机动画。
相关记录可查看{% post_link android/rom/nubia_z18mini_nx611j_port %} 和 {% post_link android/rom/nx627j_redmi_k30_pro_port %}
