---
title: windows + wsl + archlinux - 日常与工作使用记录
date: 2023-02-08 12:39
uuid: 433
status: publish
tags: windows
categories: windows
description: 
---
# 碎碎念

linux还是很好玩的, 可控性很高, 然而折腾一圈最终发现，还是windows + wsl 更适合我。

得出这个结论的出发点：
1. 技术向产品思维的转变, 打造高效生产力工作流为主
2. 不狂热，不站队，不参与开源商业之争，正版盗版之争, 结合自身当下客观的因素，打造自己最高效的生产力即可，在满足生存之余，以分享开源回馈开源。
3. 适应技术的发展，微软跟linux并不是水火不容 wsl 的出现，到目前为止完全满足我自身的需求

对于生产力来说, 软件不一定是最新的就好, 好用，生态，才是效率关键. 
而我常用的软件, 开发工具, 从官网上下载, 也可以解决在国内网上找个软件难的问题. 
产生windows不好用主要原因, 是国内的网络环境问题，封闭，无下限的广告，盗版，导致软件安装困难，环境配置困难，经常性的蓝屏等问题。

封闭的网络带来的人为制造的信息差，让国内的互联网公司活得太滋润了, 劣币驱逐良币，导致现在恶性的循环。

记录使用操作系统的经验, 一是激励自己更加有效率地使用系统。二是也希望能帮助一部分新人, 少走些弯路, 尽一点自己的力量打破这种信息差。

我选择windows + wsl + archlinux是基于自己有一些linux的使用经验:
ubuntu, gentoo, deepin, archlinux, manjaro 都折腾过，时间跨度到目前(2023-03-18 10:58)大概也有7年了
gentoo当主力用过半年，archlinux当作主力用过一年半, 对于bootload, grub, DM(display manager), DE(deskptop environment), WM(window manager), systemd, network管理，硬件驱动，内核定制编译, iotcl, CPIO, 常用的应用编译安装等等, 都有过了解并实践。

亲身实践的这些经验打破了我的一些刻板印象： 
1. Linux 比 windows高效
2. linux命令行更强大，更适合自动化。 
3. linux 更安全, 不用受垃圾软件，360病毒的困扰
4. linux 是开源免费的，天生血统就比windows高贵
5. linux装软件更方便，一行命令搞定, 不用像在windows上满世界找软件。

> 如果不熟悉linux, 折腾一下linux还是有必要的，使用操作系统的理念是相通的，这也可以帮助我们更加高效地使用windows。
> 现在我的工作系统: NAS(PVE + archlinux + TrueNas), VPS(Ubuntu20.04), 工作机系统 Win10 + wsl + archlinux

以前是wsl + ubuntu，其实也够我用，现在换成archlinux 也是强迫自己跳出舒适区，在够用之余多折腾一点，多深入一点操作系统的知识的学习。

## 组机

当初买本也是为了公司方便携带, 家里还是需要一个台式机, 生产力还是要看台式机.
台式机我建议还是自己组机更划算一些.
配置根据自己用用途搜索当下主流的, 装机并不难, 线都标好了, 接口都是防误插的, 机箱线稍微麻烦点, 但是也都有标注. 
所以, 自己DIY, 真材实料有保证, 也花不了多少额外的时间成本, 了解计算机的一些基本的知识, 也是有利无害的, 顺手就学习了. 

用途:

	主要用途: 客户端开发
	其他：自媒体工作流: 视频剪辑，3D建模，图片处理等.
	未来可能的用途: 游戏开发，机器学习, 3D打印

	决策: 

		保留一定的升级空间, 前期主要满足我的客户端需求(尽可能快: 打开, 编译, LSP等) cpu二线, 内存够大, 过渡显卡点亮, 后期有需求再升级

客观因素:

	预算 6000-8000

## 机器配置 (2023-01-05)

	cpu: i5 13600kf
	board: ￥3390 华硕 b660m 重炮手, 4槽内存
	内存: ￥800 32G单片 ddr4 3000HZ, ddr5 
	散热: ￥300 够用
	电源: ￥500 够用，不出问题，不省
	机箱: ￥200 不在乎大小，美观，实用为主
	硬盘: ￥700 固态1T，2T, ￥800 机械 12T
	显卡: ￥310, 买了个 RX 580 矿卡, 点亮够用

	显示器, 键鼠都是以前买的, 主机花费 6300 + 

## 操作系统

由于中美贸易战的原因，决定优先选linux, 啥软件都使用正版，不香么，以前折腾了gentoo, ubuntu, deepin, archlinux, 都有或多或少的痛点，于是这次决定装 manjaro 试试。

尝试了一段时间，还是习惯于Windows下的开发，再加上terminal, wsl2的性能提升，linux的操作需求也够用了，因此，又换上了windows + wsl2(archlinux)

以前装windows都是从雨木林风，深度，风林火山，系统之家上找。这些个网站下载的windows, 夹带了很多私货。
这次，直接从官网上装，选择[massgravel/Microsoft-Activation-Scripts](https://github.com/massgravel/Microsoft-Activation-Scripts)来激活。
> 声明:在经济允许的情况下, 推荐使用正版!!!
系统盘也抛弃老毛桃，使用Rufus
具体装系统的细节都不细表了，傻瓜式安装

系统下载从官网的工具下载，制作成ISO, 国内网还挺耗时


# wsl, archlinux安装

windows + wsl + archlinux 的安装可参考[wsl 下的aosp 环境配置](https://blog.yiyitec.com/2021/03/25/wsl-%e4%b8%8b%e9%85%8d%e7%bd%aeaosp%e7%8e%af%e5%a2%83/), 

> 这篇文章是基于之前archlinux的使用改的，为了保留记忆时间点, 文章的时间还是保留创建时间的顺序，内容是持续更新

# 日常使用记录

在国内使用Windows, 得保持两个观念: 

1. 从官网上找下载，使用Google搜索，拒绝百度, 莫从什么华军软件园之类的网站下载。
2. 大多数软件也能找到开源替代方案，一般都够用，没必要在盗版上耗费太多时间

这样基本上能保证日常使用的安全性

### 搜索

搜索是自学最重要的技能之一，学习耗时并不长，但是收益确实最大的。

everything: 小巧，高效, 搜文件必备
findstr: cmd 命令，类似于 grep

浏览器搜索：[搜索指令](https://zhuanlan.zhihu.com/p/136076792)

    1. 双引号`""`精确查找
    2. 多关键字用空格隔开，多词检索
    3. 使用`-`去掉无关信息, 如 `-广告`，去掉广告
    4. `site:` 指定网站搜索
    5. `fitetype:` 指定搜索文件类型
    6. `title:` 或 intitle: 针对标题进行检索
    7. `inurl:` 搜索范围限定在url中
    8. `《》` 精确查找
    9. `+`, 必须包含关键字搜索
    10. `*和?` 通配符查找

Chrome/Chromium, Edge, Firefox, 浏览器方面 Edge 是在有了ChatGPT 以后崛起了, 但是论兼容性还是 Chrome/Chromium, Firefox 更好一些。

## 网络

由于墙的原因，很多工具都需要加上国内的源, 但是还是避免不了会遇到各种各种的网络相关的问题。
国内这样的网络环境，真得是一言难尽啊。 

pacman.conf 中添加archlinuxcn

    [archlinuxcn]
    Server = https://mirrors.cloud.tencent.com/archlinuxcn/$arch

pacman.d 中的 mirrors 去掉国内的镜像，保留几个国内的镜像源, 我一般选ustc, tuna, ali, tencent

## 添加非root用户，可以使用sudo 提权

```sh
useradd username
passwd username
usermod -aG wheel username
vim /etc/sudoers
```

## 中文环境

```sh
yay -S wqy-zenhei wqy-microhei
```

## 滚动升级
	
```sh
yay -Syyu
```
pacman的常用命令

    `pacman -S (软件名)`：安装软件，若有多个软件包，空格分隔
    `pacman -S --needed （软件名）`：安装软件，若存在，不重新安装最新的软件
    `pacman -Sy (软件名)`：安装软件前，先从远程仓库下载软件包数据库
    `pacman -Sv (软件名)`：输出操作信息后安装 
    `pacman -Sw (软件名)`：只下载软件包，而不安装 
    `pacman -U (软件名.pkg.tar.gz)`：安装本地软件包 
    `pacman -U (http://www.xxx.com/xxx.pkg.tar.xz)`：安装一个远程包# 卸载软件 
    `pacman -R (软件名)`：只卸载软件包不卸载依赖的软件 
    `pacman -Rv (软件名)`：卸载软件，并输出卸载信息 
    `pacman -Rs (软件名)`：卸载软件，并同时卸载该软件的依赖软件 
    `pacman -Rsc (软件名)`：卸载软件，并卸载依赖该软件的程序 
    `pacman -Ru (软件名)`：卸载软件，同时卸载不被任何软件所依赖# 搜索软件 
    `pacman -Ss (关键字)`：在仓库搜索包含关键字的软件包 
    `pacman -Sl `：显示软件仓库所有软件的列表 
    `pacman -Qs (关键字)`：搜索已安装的软件包 
    `pacman -Qu`：列出可升级的软件包 
    `pacman -Qt`：列出不被任何软件要求的软件包 
    `pacman -Q (软件名)`：查看软件包是否已安装 
    `pacman -Qi (软件包)`：查看某个软件包详细信息 
    `pacman -Ql (软件名)`：列出软件包所有文件安装路径# 软件包组 
    `pacman -Sg`：列出软件仓库上所有软件包组 
    `pacman -Qg`：列出本地已经安装的软件包组和子软件包 
    `pacman -Sg (软件包组)`：查看软件包组所包含的软件包 
    `pacman -Qg (软件包组)`：查看软件包组所包含的软件包# 更新系统 
    `pacman -Sy`：从服务器下载最新的软件包数据库到本地 
    `pacman -Su`：升级所有已安装的软件包 
    `pacman -Syu`：升级整个系统# 清理缓存 
    `pacman -Sc`：清理未安装的软件包文件 
    `pacman -Scc`：清理所有的缓存文件

## zsh 使用

### zsh 安装
[powerlevel10k 安装](https://github.com/romkatv/powerlevel10k#meslo-nerd-font-patched-for-powerlevel10k)

nerd-fonts-meta 安装

```sh
yay -S nerd-fonts-meta
```
[skywind3000的zsh配置](https://github.com/skywind3000/vim/tree/master/etc)

### zsh FAQ
+ 上下的时候, 根据已有字符匹配历史记录

安装antigen 管理插件，prezto 里的history-substring-search包含了这项功能
安装插件的时候，有问题优先查文档，我在抄配置的时候，遇到 `/sorin-ionescu/prezto/modules/history-substring-search/init.zsh:source:14: no such file or directory` 问题
[sorin-ionescu/prezto](https://github.com/sorin-ionescu/prezto) 的README有解决办法:

```sh
cd $ZPREZTODIR
git pull
git submodule sync --recursive
git submodule update --init --recursive
```

+ tab键提示很慢
提示命令的时候会慢，但是提示参数，路径的时候就很快。

### 磁盘清理

DiskGenius: 免费够用

### 图片处理
ShareX 
	截屏，简单地图片处理

图床

	[PicGo](https://github.com/Molunerfinn/PicGo), 图床管理工具

专业图片处理

	付费: PhotoShop
	开源: GIMP

### 音乐

[洛雪音乐](https://github.com/lyswhut/lx-music-desktop)

### 视频剪辑

### 工作流工具

Git, 源代码管理，基础工具
VScode: 开源的编辑器，脚本语言开发体验良好。
Vim: 现在大部分时间用来写文档，linux的一些配置编辑。
Idea Intellij系列: 一把梭, 破解网站()[], 不用去关注什么一堆的公众号，国内的网真TM头疼
> 声明：有能力了，一定要使用正版，为了更好的生态环境, 毕竟用爱发电很难持久！~

SqliteStudio: Sqlite 查看工具

词典:[GoldenDict](http://goldendict.org/), 欧陆

目前使用体验还是这两款体验最好的, 自己搭配词典，无广告，词典除了传统的韦伯，牛津, 还有一款开源的 [skywind3000/EDICT](https://github.com/skywind3000/ECDICT) 很好用。

通信：通信工具可就太多了

	微信/QQ/钉钉，国内有合作是避免不了
	Discord, 

AIGC： ChatGPT, Statable Diffusion

	现如今，AI是一个得力的助手，用好了跟不会用是两种不同的效率

### 翻墙

了解基本的翻墙相关的网络知识, 这个可以少交一些学费，同时也能提升解决问题的能力，提升网上冲浪体验

客户端： 
	Clash, Clash for Windows 开源，够用。
	OpenVpn: 私有网络, 公司网络

机场，我目前用的是[忍者云RenZheYun](https://renzhe.cloud/auth/register?code=a1gN), 怎么找机场，当初还困扰了我一番, 无非就是怕被坑，怕跑路，不晓得从哪里去找机场
1. 自架了一个vps, 应急用，同时有一台公网的vps, 有更多玩法, 比如blog, 家里的NAS, 服务器内网穿透, 自己产品临时实验场等。
2. 毒药频道或者其他广告，找到（价钱，流量, 节点）适合自己的，先按月付用着，用一段时间就有自己的心得了，没必要在这上面纠结太多，学费是避免不了的。

#### IDEA FAQ

`错误: 无效的源发行版：17`

    检查 gradle, java compiler,  project structure -> sdks 配置的jdk 是否一致。

`corretto-17.0.6\bin\java.exe'' finished with non-zero exit value 1`

    在 Desktop Compose 项目中报此错误, 换成 11, 18 都是一样的报错, 继续向上翻一翻，还是有更详细的日志 `Failed to create DirectX12 device.`


### 终端

老牌终端

    puty, xshell, mobaX,

新生代终端

    Windows Terminal, Visual Studio Code

windows terminal 下载, github 和 microsoft app store上都可以下载
microsoft store 在国内使用，有时候需要代理，有时候不需要代理, 都得尝试一下
登陆账号时 `0x80190001` 是网络报错, 分别开关代理试试

### Flutter 配置

安装flutter
```sh
yay -S flutter
```

配置环境变量 ANDROID_SDK

FAQ: 
1. `Please ensure that the SDK and/or project is installed in a location that has read/write permissions for the current user.`

```sh
# 查看当前用户是否在 flutterusers 组里
groups $whoaii
# 如果没有在flutterusers 组里, 需添加
usermod -aG flutterusers $(whoami)
```

