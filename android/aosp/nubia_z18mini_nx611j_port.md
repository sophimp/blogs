
## 努比亚 z18mini 移植过程

	主要是内核， vendor,  device 数据的获取

	vendor 数据，可以在 /vendor, /system/vendor 下获取到
	kernel 的源码应该也不是问题，剩下的就是devices下的工作

	为了确保文件的完整性，将现有系统下的所有可能的文件都copy 下来，但是有些bin 文件没有权限, 己经是root用户了


### 查看cpu 信息

	adb shell
	cat /proc/cpuinfo
	nubia z18mini 是 sdm660, 宣传称骁龙855+， 具体型号为 msm8976 plus
	在移植过程中， 有人的使用sdm命名， 有的使用msm8976 plus, 按说内部的内容是一样的
	直接搜索 sdm660, 能得到什么信

	vendor 资源，kernel 源码， 哪里去拿？
	
	mokee 传的内核源码都是 3.8 版本的， 而原本的源码都 4.4.78 了, 从哪里获取源码？ 
	kernel的角色是什么样的？ 是不是每家厂商的内核源码都不一致？ 内核是通用的，要做哪些适配工作，
	了解android 框架，当然还是 [官方文档](https://source.android.com/devices/architecture/kernel/android-common) 更有权威

	内核, framework, 能拿到厂家官方提供的内核， 再加上vendor部分的blob, 那么一款手机的硬件基本上是可以驱动起来了，那么framework层, sdk层，就属于应用层了，如果要兼容android通用性应用，那么必然是在framework层上扩展，而不能删减.

	先将已找到的内核源码都下载下来尝试一番，边做边思考， 弯路是避免不了的。

### 资源获取, 脚本编写

1. kernel 资源，先从github 上搜索了 xiaomi_sdm660 nubia_nx611j 的kernel源码，但都不确定可以用

msm8976 与 msm8976plus 还是有些不一样，但主体应该是一样的吧，看所有移植的机型， 内核的源码肯定是都没有修改的， 推断，理论上是可以直接用起来，主要是在编写编译脚本的时候， 串起来吧。

直接通过git log, 看看 nx589j 的机型修改了哪些文件, 主要是 dts 的编写， 
[DTS结构及其编译方法](https://blog.csdn.net/lichengtongxiazai/article/details/38941891)
[android 开发dts, 各种接口porting](https://www.xuebuyuan.com/1023185.html)

还是谷歌牛逼，搜索到了努比亚"官方的"(nubia_public, 未验证)的github库, 这样的话，主要先研究内核的编译, dts用到再研究

当前主要的工作是先将rom 移植跑起来，哪里有现成的工作， 哪里就先利用起来。在时间紧，任务急，工作量且大的情况下，只能如此

Lineageos 还在维护？ 先拿到kernel, vendor 资源，按nx589j实现 nx611j 的移植

device 资源，先copy nx589j 的配置 

vendor 资源，先将手机 /vendor, /system/vendor 下的资源 备份出来

编译配置脚本的编写，也是摸着石头过河，心里并没有谱， 主要还是之前的几款手机都是找到了现成的
	

2. [How to port Cyanogen/LineageOS to your own device](../../Port_Andoird_To_Your_Device_translate.md). 

通过翻译此文, 能够确定 kernel, device, vendor 这条路的正确性，然而每个开发人员的水平不同，相对于我来说， 是个新手，有些困难

那么, 就从nx589j 的三个文件的开始分析， 非打通此路不可, 一个月的时间，心里没谱

相关资料 [谈第三方Android ROM开发者是如何适配硬件的](https://toby.moe/android-shim/)

3. device

先从此文件夹开始, 应该是连接kernel 与 vendor文件夹的

- device/qcom 

可以复用

device/qcom/common , 下有dtbtool, power, recovery 

device/qcom/sepolicy 用来配置 SELinux, SELinux 的作用, 具体的型号也都有, 暂时可以复用起来
[Android中 SELinux权限](https://blog.csdn.net/x2017x/article/details/77847988)

如何先移植twrp 呢
源码在github上 [androdi-bootble-recovery](https://github.com/omnirom/android_bootable_recovery/), 
[编译教程](https://forum.xda-developers.com/showthread.php?t=1943625)

先将手机上所有的文件备份， 但是即使在root 权限下，有的文件同样不可以copy, 这时候，需要lsattr 命令查看文件状态，
但是android shell 的命令并不全，因此需要安装busybox, 大致思路，重新挂载 /system 分区为rw, 复制busybox 到/system/xbin下，改变busybox权限
使用busybox --install /system/xbin

上述操作并不能解决root 用户下, operation not permitted的问题, 改改分组试试呢？仍然不行
在 /vendor/rfs/msm/下还是有很多firmware 的，是否有用？ 怎么拿出来？

- 硬件层移植, shim编写
[为何msm8974不能移移android 8.0 系统](https://www.xda-developers.com/in-depth-capitulation-of-why-msm8974-devices-are-excluded-from-nougat/)
