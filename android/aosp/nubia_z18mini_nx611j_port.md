
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
	
	尝试制作recovery?  先解决kernel的问题
	
	先理清启动流程, 再根据 nx589j, 一加六的配置来改写, 不能参考wayne, 因为这个有可能就是错的. 

	修改device, vendor 的product_packages应该是不会影响启动的. 

	验证kernel 的正确性, 如何拿到ramdisk.img, 从压缩包里拿
		以前的工具都过时了, 使用已有的脚本打包出来的img并不起作用, 有点迷了. 研究boot.img 也有点晚了
		已验证 bambooIV的kernel 与 z25 的ramdisk 是没问题的.  
		接下来, 对比 ramdisk, kernel 编译结果, mokee 编译出的kernel 使用z25工具打包也没有问题 

	接下来就是研究ramdisk 与 z25的脚本 到底有何不同的问题, 也仅仅是三行代码, 就会差别那么大? 
	 ramdisk 下的文件差别有 init init.rc init.usb.configs.rc init.zygote64_32.rc verity_key 
	 初步判断, mokee 的签名要确认,
	 直接将这几个文件复制换过去呢? 不好搞的是 init文件是个二进制文件, 怎么生成的?
	 内核的问题确定后, system.img 的问题
		
	android 的开机启动流程, 修改启动脚本

	为何源码不能编译出system.img? 直接使用make systemimage 编译出来的有1.2G, 合理吗? 
	build.prop. default.prop 这些都是有用的, 换上nubia 官方的总没错吧. 

[android 开机启动流程](https://blog.csdn.net/h655370/article/details/77727554)
[init.rc开机启动进程](https://blog.csdn.net/qq_28899635/article/details/56289063)
[SEAndroid 罗升阳](https://blog.csdn.net/luoshengyang/article/details/35392905)
[SEAndroid 阿拉神](https://blog.csdn.net/innost/article/details/19299937/)

	开机启动不了要怎么定位?
		暂时没有思路, 看看书, 构建嵌入式android 

[构建嵌入式Android 系统]() 这本书很有帮助

	先添加编译日志, 问题一个一个解决
	为何不成生systemimage, 换成eng试试, 这个脚本控制在哪里. 换成eng 没效果

	接下来还是要搞懂avb, vndk 的问题, 也就是在8.0 的事情会多一些, 一直在看, 也没个总结, 现在心不静, 效率不高, 不知道该干什么的时候, 理一理头绪, 归纳整理已知的知识

	vndk, 在8.0 为了统一hal 层, 让vendor 编译的库可以适用于多个版本, 出了此机制, 三个变量控制, 系统的自不必说, 仅vendor使用的, 该如何加进去呢?  系统的根据变量自会编译进去. 

	avb, android verify boot 2.0, android 启动流程验证, 这个也是个难点

	这条路是真的艰难, 但是胜利仿佛也在眼前. 


- kernel 与 ramdisk 的关系

[kernel与ramdisk的关系](https://blog.csdn.net/weixin_38629980/article/details/83820718)

	amdisk临时文件系统和内核一样,也是由bootloader通过低级读写命令加载进内存, 因此内核可以挂载内存里ramdisk文件系统.
	通俗的来说, 把所有可能需要的驱动/模块都放在ramdisk上,让内核将ramdisk当作根文件系统来安装,然后再用这个根文件系统上的驱动来安装真正的根文件系统.

	linux kernel 2.4中启动大致流程如下:
	[bootloader] 根据预先条件,将kernel和initrd载入到RAM
	[bootloader->kernel] 完成必要动作后,准备将执行权交给kernel
	[kernel] initrd被挂载到/dev/initrd,kernel对他解压后,复制到/dev/ram0
	[kernel] linux以R/W可读写模式将/dev/ram0挂载为暂时性的rootfs
	[kernel space->user space] 准备执行/dev/ram0上的/linuxrc程序
	[user space] /linuxrc与相关程序处理特定操作,如挂载rootfs
	[user space->kernel space] /linuxrc执行即将完毕,执行权交给kernel
	[kernel] linux挂载真正的rootfs并执行/sbin/init
	[user space] 执行各系统与应用程序


- vndk, avb

是什么, 做什么, 匹配规则
	
必须得从宏观来学习, 别人不会编程, 也一样可以完成适配工作, 就是宏观思想很强. 先从上层搞明白, 然后再深入到细节定制. 

	vndk 是为了约事vendor 的本地开发, 之前aosp 框架模块开发, 制约于vendor商, 现在想解耦这个限制, 通过vndk, hidl, hwbinder 体系架构, 约束vendor 开发, 可保证android 框架升级, 而vendor库不必升级, 且vendor库修改, 不影响框架修改.
	hidl 与hwbinder, 可使系统进程与vendor进程通信, 当然, 系统也保留了一些库, 可供vendor直接调用, 保证高效率. 
	硬件接口定义语言, 硬件binder机制. 
	avb, android verity boot, 机制, 验证系统启动时system, vendor分区. 这些很明显也影响系统的启动

android 8.0 是一个过渡版本, 努比亚选择了不用vndk, avb, 使用的还是之前的verified boot, 所以, 这个就有些坑了. 

[verified boot](http://luomingmao.com/2016/08/29/Verified-Boot/)

而vndk, avb 在9.0 都默认使用了, 移植也不涉及此方面的配置, 后续遇到再加强学习...

更具体术语:
	
	ota, a/b更新, dtbo

	dtbo 设备树, 8.0 是一个过渡的产品, 坑太多了.

	avb 在8.0 可以不用, 但是boot.img. system.img 签的过程得恢复

	vndk 避免不了要配置, 但是dump 下来的vndk 中版本为0.0.0 这样岂不是一直配不成功? 


匹配规则:

	原始开发的匹配规则暂且放置, 主要关注定制的配置. 这个


project treble, 看个大概, 还是不明所以, 真要搞明白这个, 不实战是不行的, 但是又没有实战环境, 实战环境是创造的, 只是现在没有时间去摸了, 但是真要没有一点头绪, 还必须得一点一点做, 哪怕无济于事, 对于总的行程来说, 还是前进着的. 

硬件知识:

	总线接口: 
	I^2C, SPI, UART, GPIO

	系统RAM

- 系统启动

	bootloader 对boot.img, system.img 验证, 现在bootloader 是努比亚官方的, 所以, key 是要拿官方的key
	先直接改源码, 等真正可以启动起来了, 再配置device, vendor 文件

	boot.img 按说是没有问题的, 怎么滴也应该加载到开机动画, 进入系统出错再说下一步的事
	
	bootloader 启动, 按说是比较简单的流程, 现在不止是系统启动不来, 连 boot.img 也启动不起来

	如果是本地配置的fstab 也不一样的缘故? 

刷机也只能寄希望于安装包, fastboot 不可用. 

fastboot 是与 bootloader 交互的, 所以, 可能得修改配套的bootloader, windows 上的fastboot 也一样不可用, 刷system.img 总是出错. 努比亚这个版本的系统是真得垃圾. 

要学习的内容太多了, 主要还是时间太仓促了, 如果有现成的, 我深入学习的动力也是不足的. 

学一学刷入recovery, 这个学习成本, 时间允许不? 拿两天出来搞? 看样子, 主要是fstab 的语法. 如果fstab可刷, 到少可以定位出来, 出问题的环节是在system.img, system.img 主要的代码也是官方的, 所以, 即使没有硬件驱动, 系统是可以启动的, 当然, display 驱动得是完好的. 这个在kernel 中已经有了. 

kernel 是已经支持模块加载内核了, 我得化被动为主动, 主动捋这些问题, 而不是出了哪里, 下意识就懞逼了. 

全编译一次系统, 时间也很久, 这跟开发应用的思路不能一样, 跑一跑看一看就知道了? 主要还是要多考虑一点, 一次编译, 尽可能的验证多一些的猜想. 

bamboo 进度要快一些, 编译出了可过入系统的Rom, 尽管还有很多问题待修复, 但是, 终究是可以进入系统了. 

结果证明, 并不是vndk 的原因
尝试移植了twrp, 想从这里找找路子, 但是移植到一半, 有一些问题没有解决, 即然搞出了系统, 还是继续在此上开发mokee 吧. 

整个系统的验证机制, 配置boot.img 使用 boot_singer 签名, 只需要 call verity.mk 即可? 

内核的编译, 也是bamboo 先编译出来的, 基本上我是在享受胜利的果实, 当然, 探索的过程也同样经历曲折, 关键性, 原理性的东西还是不尽然了解. 后续还待加深, 不说后续, 接下来的问题解决, 就需要去实践原理性的东西吧. 

内核的编译, bootloader 的校验, 意味着, 签名不能改变? 此处要试一试. 

编译完内核, ramdisk 是借用wayne 的, 从这看来 wayne 编译通过, 也是可以运行起来的. 所以, 他的方向才没有偏, 一直坚信, 只改device, vendor 是可以将系统跑起来的? 

我的方向也没错, 是长远的方向, 但不适合现在的情景, 所以, 总得来说, 路线还是存在缺陷, 不懂得取舍. 没有好的学习方法. 

一个不懂编程的人, 能做到如此地步, 说明什么呢? 他的学习能力是勿容置疑的, 毅力也很强大. 另一个方面也说明, 这个活的难度不是特别高. 主要还是做一些配置, 很多事情的难度都不高, 关键是要调整好思维. 调整学习的方法. 

确定好内核的可用性, 下一步的主要任务主要是加密, 校验, boot.img, system.img, vendor.img 是主要目标.

revoery.img 是正常的, 可以说明, 进入不了系统, 和system source 源码关系不大, 毕竟是开源的, 经历过验证的. 
那么可能出现的问题就是 签名校验, 加密校验没过, vendor 的blob 不正确, vendor 的blog不正确, 也比较好解决, 将所有可能的blob 都添加进去即可. 这点, 修改脚本才是正途, 脚本可用, 整体的效率大大地提高. 

接下来, 虽然进入了系统, 但是初步使用来看, wifi, camera, radio, bluetooth 都不可用.这些是下一步主要调试的部分. 

至于其他硬件的问题, 后续再说吧. 

能落地应用, 拿什么保证呢? 主功能都不出问题, 但是其他功能影响系统运行的话, 也难落地实用. 首先保证, 系统的其他操作不会导致挂死. 


