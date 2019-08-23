
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

	此类错误, 主要还是在copy proprietary 的文件时, 找不到对应的文件
	解决此类问题, 还是直接从官方运行的系统中拿相应的文件, 当然官方的ROM 得先root, 
	如果当前系统中也找不到相关的文件, 那就删除配置文件中此文件的copy

2. 编译阶段, 遇到的问题也只是1类问题, 编译内核的源码, 努比亚官方有公布, 在github 上 [nubia_public](https://github.com/ztemt)

	可见, 真正要写的代码, 主要还是在shim 层, device 相关的配置文件, 适配相关的硬件工作
	对了, 还有系统启动的配置还未涉及, 这肯定也是个难点,需要学习, .te, .rc

3. 源码编译错误

误误1: 

	ninja: build stopped: subcommand failed.
	21:04:36 ninja failed with: exit status 1

	编译工作远远没有结束, 这不是源码错误, 但也没有其他提示, google 了一下

	1. 修改jack 配置, 增加参数 -Xmx8g 但是并未起作用
	2. 服务器进程打开文件数受限制, [使用ulimit 来修改配置](https://blog.csdn.net/touxiong/article/details/86233805)
	3. 这样的错误信息远远不足, 网上搜索, 能改的都改一下, bison 库切到mokee/mko-mr1分支试试

错误2:

	ninja: error: '/home/hrst/aosp/mokee_mko/out/target/common/obj/JAVA_LIBRARIES/libstagefright_wfd_intermediates/javalib.jar', needed by '/home/hrst/aosp/mokee_mko/out/target/product/nx611j/dex_bootjars/system/framework/arm64/boot.art', missing and no known rule to make it

	这个问题也一直卡在这里, 看日志意思是 生成boot.art 的时候, 缺少 javalib.jar, 在 build/core/java_common_lib 脚本中, 是有copy 的, 根据 intermediate.COMMON 来copy, 那个这个 变量是如何定义的? 需要什么样的规则来命名, 搜索的时候要等好久, 而且tag乱了, 串工程了
	
	真不行, 每个mk 文件, 都找一找, 看一看,  这也是没有办法的事. makefile 的依赖规则, 也就那回事, 克服畏难心理.

	突然想到了, libstagefright_wfd 这个库在 /system/lib  /system/lib64中,可在 product_copy_file 里配置, 并没有起作用

	再次查找, 在device下 PRODUCT_BOOT_JAR 里也有配置, 再结合日志, 应该问题就在这里了, 那么接下来就搞明白 product_boot_jar 这个参数是用来干嘛的. 本来配置文件中的内容本就不多, 再有不明的, 先将每个字段搞明白. 

	PRODUCT_BOOT_JAR 作为 jvm 的系统库, 在android 中 build/core/dex_preopt.mk 中有描述, 用来将 该字段中的jar 都打包成boot.jar 在开机时加载启动. 

	PRODUCT_PACKAGES 将app so 文件打包到system.img 下

	ipacm, ipanet 这两个库都可以直接拿, 不用现编译, 因为发现, 编译的源码也是从linux那里拿的, 当然这里可能会有问题, 留坑. 
	搞明白上述两个变量, 基本上写配置问题不大了, 想要编译通过, 写配置文件的内容并不多, 主要的工作还是在shim层, init.* 脚本, 内核移植 

	在vendor 下 Android.mk 中#include 声明路径库路径, 或者是在 nx611j-vendor.mk 中文件路径或名字不对

	打通了mka 的前期, 终于可以进入内核编译了,  但编译源码又出错了, 直接使用脚本是没有问题的, 下周再来研究源码编译脚本吧.

错误3:

	ninja: error: 'INSTALLED_KERNEL_HEADERS', needed by '/home/hrst/aosp/mokee_mko/out/target/product/NX611J/obj/SHARED_LIBRARIES/libcryptfs_hw_intermediates/cryptfs_hw.o', missing and no known rule to make it
	17:00:26 ninja failed with: exit status 1
	
	将所有的nx611j 换成 NX611J, 因为将内核中的文件夹换成上nx611j 后出问题了. 按kernel/NX611J/AndroidProduct.mk脚本配置PlatformBoadConfig.mk 中的kernel 相关配置参数, 就出现了上述问题, 目前一点思路都没有, 与nx589j的内核文件对比,也没有发现什么问题. 

	shared_librarys 应该还是device 下配置的问题, 但是Installed_kernel_headers 又是啥玩意

	这个错误还是与Crpto: target_hw_disk_encryption := true 配置有关

错误4:

	ninja: error: 'INSTALLED_KERNEL_HEADERS', needed by '/home/hrst/aosp/mokee_mko/out/target/product/NX611J/obj/EXECUTABLES/ebtables_intermediates/getethertype.o', missing and no known rule to make it
	17:20:47 ninja failed with: exit status 1

	与ettable 库相关, 上面这些库基本上都与 product_packages 中的库中的库相关, 这些库, 是整个工程中的所有makefile 中定义的, 并不只是vendor, device 下, 还有system, framework

	最后是因为 按官方的脚本配置 kernel_defconfigs, 而mokee 中要配置成 target_kernel_config

	靠GrepCode 搜索错误相关的代码, 在编译库中添加上 
	LOCAL_MODULE_CLASS := SHARED_LIBRARIES
	LOCAL_MODULE_SUFFIX := .so

	可以解决so 库不存在, 但是有 include

	嗯, 看样子, 是可以将内核编译通过了, 但是编译完刷机和开机还成问题. 

	又想多了, 并没有编译通过, 出现的问题不一样了.  
	明天再确定是对着 kernel.mk 的变量移植内核编译脚本, 而不是kernel下的KernelAndroid.mk

	还是要参考KernelAndroid.mk 和 sh 来修改 kernel.mk 脚本, 现在可确定是dst 没有找到. 很多文件也没有copy 

	主要还是device 中的配置文件, 影响到了内核的编译, 但愿这一次可以编译通过吧. 
	呵呵, 这是真得来不得半点虚假的, 问题的根源所在就是kernel.mk 的编译脚本问题, 

	卡在这里, 不知道要改哪里, 直接 make bootimage 是可以内核编译通过的. 先使make 单线程编译, 还能看到一点不一样的错误...

错误 5:

	[  6% 6803/108031] target  C++: vdc <= system/vold/vdc.cpp
	6 warnings generated.
	Suppressed 6 warnings (5 in non-user code, 1 with check filters).
	Use -header-filter=.* to display errors from all non-system headers. Use -system-headers to display errors from system headers as well.
	ninja: build stopped: subcommand failed.
	20:37:37 ninja failed with: exit status 1

	上一个问题都忘记了怎么解决的, 是否解决了, 这个问题只有在重新编的时候才会显示, 再编译就只显示ninja的错误, 这样改错不是个办法..
	效率太低了, 怎么看ninja的错误日志. 
	
	卡在这里走不下去了, 要等待, 但是一天的时间就这样过去了, 明天就周末了, 我要该怎么办, 就是编译过去了, 还有开机启动不起来的问题. 
	开机启动不了, 无非就是开机脚本的问题, 此时能想些什么? 还能做些什么? 内核的编译肯定要懂, init.rc 的作用, 绕不过去这个坎的. 

	repo status 查看本地源码是否齐全, 不齐全的想办法补全, 本来就是一个编译工作, 没有什么高智商的东本, 主要是学会, 心里畏惧什么呢? 

	上述这些错误, 大都是因为本地库不对, 想想也是, 报错在本地代码, 那只能是本地环境出问题了
	
- kernel, vendor, device
	
kernel 

	主要还是找开源的, 基本上不用修改什么 
	这是大错特错, 当然还要脚本对接. 
	kernel 下的AndroidKernel.mk 并没有起到作用, 直接是Makefile 来编译的. 

	与kernel 相关的编译放在 vendor/mk/build/tasks/kernel.mk 中, 所有的配置变量都在这里

vendor 主要还是搞 file copy, 使用现有的资源, 注意文件结构, proprietary 相当于根目录/, 下面还有一层

	vendor可能还有定制的内容, 暂时先不管
	可以直接使用device 下的脚本生成, 真牛逼, 这才是自动化

device 主要的配置工作主要还是在此文件夹, 连结kernel, vendor, 使用的qcom 库, 都要与kernel 的版本一致

	着重分析完此文件下的各种文件的作用, 不然此路还是打不通啊, 要配置哪些变量? 
	device 下的配置, 也需要结合 build 下的定制, lunch 函数, make 命令. 命名规则, 总体调试起来. 
	
###  device 文件分析
	
有一个与kernel 对应的common 

	从名字上看, common 肯定是想与同类机型共用起来, 所以, 理论上是common 是可以共用的. 
	当然还得分析不同平台特定的设置

与特定机型相关的配置 

	overlay 一些资源文件, 这个不影响使用, 顶多UI丑一些. audio
	shim 层的适配, 这个相对来说是机型特有的, bluetooth, liblight, mkhw, 
	启动脚本的配置, rootdir, selinux 的脚本配置 sepolicy
	全局编译脚本的编写 mk_combo.mk: 对接kernel, vendor 资源, 配置全局变量(只能通过编译日志来补充, 网上相关教程并不多)
	在 [Port_android_to_your_own_device]() 中有相关最基本的几个变量配置需要

	其实这些所有的功能, 还是需要查看相应的脚本文件, 即可了然, 但是脚本文件那么多, 还是要靠实战调试来看代码, 否则整体的时序流程还是摸不着头脑.
	跑 CTS 测试框架, 又该如何配置呢? 
	插桩的技术, 看似很高深, 其实只要有一些全局的思想, 从整体入手, 反射插桩而已

对比nx589j 与 xiaomi-wanye 的配置 

	先从官网上再读一读 [android 架构](https://source.android.google.cn/devices/architecture/hal-types.html)
	从android 8.0 后, hal 更加模块化, 采用hidl 语言编写了hal 层, 使移植更加方便一些, 前提是厂商要支持
	国内的厂商大都还是定制UI rom, 组装硬件, 然后按hal 层编写自身的rom, 所以既然接口是通用的, 移植应该更简单一些. 
	当然涉及到特有的部分, 还是要写shim层. 
	android 8.0 系统, 分为升级与搭载, 升级到8.0 的HAL使用直通式(使用hidl 封装了旧有的HAL), 直接出厂的机器搭载8.0 系统, 就直接使用绑定式(全新使用hidl的实现hal层)
	有一些特有的功能, 不管是升级还是搭载, 都使用直通式, 反复读, 收获还是有的.

	HIDL的设计, 新旧都得了解一番. 看了个大概, 现在的局面不允许仔细研读, 还是先进行文件比对, 实战中学习吧. 
	看完HIDL HAL层那么多东西, 感觉这个月想完成任务有些难. 

	非得每一行, 每条配置都搞明白不可达编译通过之目的. 


- 硬件层移植, shim编写
[为何msm8974不能移移android 8.0 系统](https://www.xda-developers.com/in-depth-capitulation-of-why-msm8974-devices-are-excluded-from-nougat/)


- bootlaoder 解锁

	努比亚z18mini 的 bootloader 解锁 fastboot oem nubia_unlock NUBIA_NX611J
	不同版本的fastboot还不一样, 有的可解锁, 有的不行

- 编译通过 

	编译通过, 也仅仅是走了三分之一的路
	没有system.img, 刷机包不可通过recovery 刷入, 配置不一定对
	make systemimage 可生成image, 但是刷机成问题

	fastboot 不能用, 增加了刷机的时间, 即使在windows上写system 仍然会失败. 

	下一步该如何走:
	
	尝试制作recovery? 
	启动是跟哪个相关的? bootimage?  
	
	先理清启动流程, 再根据 nx589j, 一加六的配置来改写, 不能参考wayne, 因为这个有可能就是错的. 


