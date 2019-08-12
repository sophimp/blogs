
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

propiretary-files.txt 直接查找vendor下的proprietary 目录的文件， 暂不要jar, apk 文件

lunch mk_nx611j-userdebug 过不去，之前已经遇到过的问题， 又有些忘记了. 回顾了下[mokee_research]() 当初适配 nx589j,在网上下载了相关的库，脚本都是自动写好的， 
那时候直接 lunch mk_nx589j-userdebug 就可以直接通过了， 也没有去细细研究脚本的衔接点，留着以后再研究，现在这个以后的时候就到了。
关键是这个以后基本上都是"临危受命" 的时机， 压力都是自己给自己的。

调试makefile 按逻辑走也没有那么困难, $(warning "") 可以打印相关变量信息, 确定是在build/core/product_config.mk 报错行数中看一看逻辑,
	mokee也修改了build 下的脚本，查找 device/nubia/nx611j/ 下的 mokee.mk 或者mokee_nx611j.mk 来编译, 所以此问题得解，衔接处找到了.

接下来，按此方法，打印调试信息, 按编译日志修改脚本配置， 使编译通过应该不成问题了! 

nx589j 分为了两个文件夹 msm8976 和 nx589j， 那么 nx611j 就将这device, vendor 下对应的这两个文件夹的mk 合二为一，
	看相关配置，还是可以看出一些眉目来的

export MK_BUILD
	...

这样算什么语法呢, 最后报错是在哪里， 为何没有行号

其他文件夹的用法

先使用 xiaomi sdm 660 相关的配置， 结合 n589j device, vendor的配置，试一试，真不行， 
再着重看一下小米的配置，对比一下，就差不多可以看到区别, 只不过是有些文件要重新再配置一次了
解决了一个问题check_product是通过了，又遇到了下一个问题, 怎么会去加载aosp_arm.mk呢

$(call inherit-product ) call 是异步调用的,不管放在当前文件哪个地方

对比nx589j的配置文件, 结合错误日志
	> build/core/combo/TARGET_linux-arm64.mk:38: *** Unknown ARM architecture version: arm64.  Stop.
最终在 sdm660-common 中找到了相关配置, TARGET_2ND_ARCH_VAR, 按 nx589j 中的msm8996-common 中的相关配置, 添加上就可以lunch 通过了

接下来就是编译 mka bacon 调试

###  编译调试xiaomi_sdm660-common相关的配置到 nx611j, 是否可以移植通过

1. ninja: error: '/home/hrst/aosp/mokee_mko/out/target/common/obj/JAVA_LIBRARIES/WfdCommon_intermediates/javalib.jar', needed by '/home/hrst/aosp/mokee_mko/out/target/product/nx611j/dex_bootjars/system/framework/arm64/boot.art', missing and no known rule to make it
17:34:21 ninja failed with: exit status 1



	


- 硬件层移植, shim编写
[为何msm8974不能移移android 8.0 系统](https://www.xda-developers.com/in-depth-capitulation-of-why-msm8974-devices-are-excluded-from-nougat/)
