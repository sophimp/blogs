
## 努比亚 z20 移植, 和k30 pro移植


### android 10.0.0_r33代码同步出了问题

一直同步不下来，不知道是源的原因还是墙的原因。

aosp.tuna.tsinghua.edu.cn 一直没同步下来

然后翻墙， android.googlesource.com 好几次也没同步下来，多试几次最后成功了

可能不是墙的问题吧， 就是网络的问题， 中间出现好几次下载到一半， early EOF 了


### android 9.0, 10.0

9.0 还没有真正意义上支持android.bp, 至少在mokee中的device, vendor中配置中没有支持

10.0 倒是支持bp了， 但是 PATH_OVERRIDE_SOONG, KERNEL_MAKE_FLAGS 这些变量都没有配置对， 是我的device中要配置？ 这也不应该，可能需要下载一个完好的10.0的机型来搞， 但是这时间又不够了。 

bp 与 mk 互换， 已经有工具可以将 mk 转成 bp, 但是还没有见到将bp转成mk的

### lineage 

为何好多人都是先移植lineage OS 呢？ 

Lineage OS 相对于 Mokee 更加纯粹一些, 为了技术和便利。 Mokee 就涉及到利益了， 且是依托于LineageOS的。


### red mi k30 pro

Disallowed PATH tool "ld" used: 
"bison" is not allowed to be used. See https://android.googlesource.com/platform/build/+/master/Changes.md#PATH_Tools for more information.
"flex" is not allowed to be used. See https://android.googlesource.com/platform/build/+/master/Changes.md#PATH_Tools for more information.

	export TEMPRORARY_DISABLE_PATH_RESTRICTIONS=true

	还不能简单报就直拉disable, 看日志涉及到dtc 的编译， 所以，为何内核的源码编译不过， 可能是这里的问题
	[内网可访问链接](https://github.com/aosp-mirror/platform_build/blob/master/Changes.md)

进展比较顺利, soong编译链工具的问题， 竟然都给了链接, 虽然没有细看具体是为什么， 但是不妨碍解决了问题

### 从HAL层到APP层的程序

[使用HIDL+AIDL方式编写从HAL层到APP层的程序](http://max-shu.com/blog/?p=1075)


### android treble

[android treble 分析](https://jianshu.com/p/56bd1ea66aed)

treble 也是HIDL和AIDL的应用。 搞系统移植， 这是绕不过去的坎， 搞懂了这层机制， 至少在哪个硬件不工作的时候， 知道该如何去修复, 虽然也是找补丁， 但是至少可以判断找的补丁修的对错与否。 

HIDL, 硬件接口定义语言， 是为了定义硬件接口， 然后翻译成对应的头文件， oem 或者edl 负责实现. 

AIDL 是为了解决跨进程通信， 使用binder, 当然与hidl对应的还有一个hwbinder. 

如何通信呢？ 通过 /dev/binder, /dev/hwbinder, 这里又涉及到了linux的文件操作， /dev/binder, /dev/hwbinder 是文件， 在这里是可以共享的内存区域。 

这里又涉及到了内存共享的知识。 

有必要写一写对操作系统的理解

### 移植过程

> 一直找不到一个合适的记录方式， 每一个话题开出来了， 但是前期我又学不到那么深入。 所以， 还是先以流水帐的形式记录。 后续有精力就整理， 没有精力就放这吧。 作为一个过程， 也有一定的参考性

> 流水框架: 复盘， 疑问(待学习的知识，遇到的问题)， 解决(相关资料网站，以前学习的总结)

**Fri 08 May 2020 04:38:10 PM CST**

复盘:

事情有些棘手了

之前搞混了 redmi k30 与 redmi k30 pro, github 上的库也并不是都能用的, 大多都是学生移植的，库都是半成品, 或者建了个空仓.

qualcomm 865+， sm8250 相关的资料并不多, 关键信息还是参考 wiki. 

考查阶段， 我对自己过于自信了， 现在看来， 想在预期内搞定移植， 风险很大。 

硬件到上层一这关， 必须得打破了。 各个参数都代表什么意思， 在哪个脚本中用到？ 

**疑问:**

开源的kernel 库， 为何没有相关说明呢？ 

编译脚本的流程该如何理. 

kernel 补丁哪里去找, codeaurora 为何没有qualcomm 865+ 相关的仓库？ 

kernel 打补丁， 好几种方式, git am, git apply, diff, patch, 补丁还有mailbox, git commit, 该如何去打这个补丁？ 

xiaomi 10 的 device 库可以参考

当前的主要任务还是搞清楚 hidl 的机制， 点亮手机，再解决其他问题。

点亮手机按说只需要解决kernel问题就可以了, 因为recovery 就是一个例子。 我需要做哪些工作？ 

编译kernel，涉及的脚本， 按说还是从 makefile 开始， .config 与 linux 的 make menuconfig 生成的.config应该是等价的， 这里只是手动写出来罢了

.config 在哪里可以查得到? 

.config 除了编译对应的模块， 还有何作用， 是否影响手机启动。 

接下来的方案， sm8250 的内核 先不抱那么大的希望， 官方提供的内核也可以编译通过。 

mkbootimg 出错，解析 device 对应的脚本在哪里。 蓝牙， wifi, light, vibrate, 与 5G 这些应该不会影响开机的. 

需要配置哪个变量。 

按说只添加recovery 的配置，也应该能启动起系统来的。 

先换 boot.img 看看内核是否能正常使用

dump .so, .boot.img, .rc 破除权限， 需要更改system的挂载，这需要开发或内测版才能做到... 还有没有其他的方法呢？ 

确定了 redmi-k30-pro 的代号就是 lmi, 小米公布的kernel 都已经命名了。 

AndroidBlobs, AndroidDummy 仓库分别公布了出场的ROM dumps 

ShivamKumarJha/android_tools, ROM开发者的工具, 都有工具了， ROM移植就变得相对简单了， 其实学会了rom 移植， 后续肯定会简单的多. 

启动过程， 为何要经过bootloader? 为何要先加载dtbo, 加载内核, 启动系统？为何要一级一级的引导到操作系统呢？ 

	方便扩展， 理论上也是可以一键到底的， 但是后续再加一个硬件， dtbo 要跟着变吗？ 换一个系统， bootloader 要重写吗？ 
	内核加载完了， 启动过程与硬件相关的加载就结束了， 操作系统是基于内核的软件应用架构. 

注释掉 avb ，出现了dynamic  partions 的错误, 何为dynamic partions ?

	可以通过ota 升级，动态改变用户分区大小, 只用于用户分区
	[动态分区 Dynamic Partitions](https://source.android.com/devices/tech/ota/dynamic_partitions/implement)


### Sat 09 May 2020 04:20:15 PM CST

**KeyErro: "partition size"**

找到对应的image ，补全相应的 image_partition_size, 如 board_bootimage_partition_size := 

**动态分区**

	android 10.0 的动态分区特性， 搞得recovery 刷不了机？

	redmi k30 pro 上， system分区没有了， boot.img 刷进去启动不了， fastboot -w 将userdata 清了之后， 连data 分区也找不到了， 挂载是按动态分区来的。

	先刷回官方的boot.img， 可以启动， 得先摸清楚k30 pro 的各个挂载点对应的物理分区在哪里, 不然格式化了， 不知道如何再分区了。 

redmi k30 pro 分区

Filesystem                      Size  Used Avail Use% Mounted on
tmpfs                           2.7G  1.0M  2.7G   1% /dev
tmpfs                           2.7G     0  2.7G   0% /mnt
tmpfs                           2.7G     0  2.7G   0% /apex
/dev/block/dm-7                 118M  876K  117M   1% /odm
tmpfs                           2.7G  7.5M  2.7G   1% /sbin
/sbin/.magisk/block/system_root 3.0G  3.0G  9.3M 100% /sbin/.magisk/mirror/system_root
none                            2.7G     0  2.7G   0% /sys/fs/cgroup
/dev/block/sda18                 11M  112K   11M   1% /metadata
/dev/block/sda22                 58M  2.9M   55M   6% /mnt/vendor/persist
/dev/block/sde43                 64M   32K   64M   1% /mnt/vendor/spunvm
/dev/block/sde51                448M  204M  244M  46% /vendor/firmware_mnt
/dev/block/sde49                 59M   28M   31M  48% /vendor/dsp
/dev/block/sde35                 64M  352K   64M   1% /vendor/bt_firmware
/dev/block/sda13                4.9M  160K  4.8M   4% /dev/logfs
/dev/block/sda31                976M  763M  213M  79% /cust
/dev/block/loop2                 21M   21M   32K 100% /apex/com.android.media.swcodec@290000000
/dev/block/loop3                1.6M  1.6M   28K  99% /apex/com.android.resolv@290000000
/dev/block/loop4                5.0M  5.0M   32K 100% /apex/com.android.conscrypt@290000000
/dev/block/loop5                 96M   96M   36K 100% /apex/com.android.runtime@1
/dev/block/loop6                5.4M  5.3M   28K 100% /apex/com.android.media@290000000
/dev/block/loop7                232K   36K  196K  16% /apex/com.android.apex.cts.shim@1
/dev/block/loop8                836K  808K   28K  97% /apex/com.android.tzdata@290000000
/sbin/.magisk/block/product     435M  434M  1.3M 100% /sbin/.magisk/mirror/product
/sbin/.magisk/block/vendor      1.7G  1.7G  5.3M 100% /sbin/.magisk/mirror/vendor
/sbin/.magisk/block/data        107G  7.5G   99G   8% /sbin/.magisk/mirror/data
/data/media                     107G  7.5G   99G   8% /mnt/runtime/default/emulated

dtbo image: /dev/block/sde47


/dev/block/by-name

 metadata -> /dev/block/sda18
 secdata -> /dev/block/sde11
 super -> /dev/block/sda32
 userdata -> /dev/block/sda34
 vbmeta -> /dev/block/sde16
 vbmeta_odm -> /dev/block/sde27
 vbmeta_product -> /dev/block/sde26
 vbmeta_system -> /dev/block/sde17
 vbmeta_vendor -> /dev/block/sde25
dev/block/sda18 on /metadata type ext4 (rw,seclabel,relatime)
/dev/block/sda34 on /data type f2fs (rw,lazytime,seclabel,relatime,background_gc=on,discard,no_heap,user_xattr,inline_xattr,acl,inline_data,inline_dentry,flush_merge,extent_cache,mode=adaptive,active_logs=6,alloc_mode=default,fsync_mode=posix)
/dev/block/sda34 on /sdcard type f2fs (rw,lazytime,seclabel,relatime,background_gc=on,discard,no_heap,user_xattr,inline_xattr,acl,inline_data,inline_dentry,flush_merge,extent_cache,mode=adaptive,active_logs=6,alloc_mode=default,fsync_mode=posix)

### Sun 10 May 2020 10:53:06 AM CST

为何编译出来的包不能刷机？

	对比发现少了 odm, product, dynamic_partition_op_list, 相关的文件, exaid.img 是什么不用管吧。 vendor 与 firmware 按说也不用管的。 

	对比了oneplus 的包， 编译成payload.bin 文件来刷机？ 

	nx611j 的包是有vendor 和 file_contexts.bin 的

	可能关键还是在dynmaic partition 上 

[动态分区](https://source.android.google.cn/devices/tech/ota/dynamic_partitions/implement?hl=zh-cn#upgrading-devices)

	动态分区要使用 android 启动时验证(AVB), 不能与AVB1.0搭配使用

avb 验证 2.0
	
	启动时验证， 先搞明白在device中是怎么配置的
	avb 的验证是一样的吗？ 如果用官方的 boot.img, 使用自编的system.img, 能通过吗？ 如果用到加密的key, 那定然是不能通过的了。 
	所以， 能否不开始avb验证呢？ 

selinux 如何配置

	/dev/block/platform/soc/10000\.ufshc/by-name/system   u:object_r:system_block_device:s0
	/dev/block/platform/soc/10000\.ufshc/by-name/vendor   u:object_r:system_block_device:s0

	放在哪个文件里 放在 te 后缀的文件中, selinux 也得学一学

redmi k30 pro 不是A/B分区的设备， 但是支持动态分区, 教程里没有关于 非a/b分区的动态分区, a/b分区，无非是增加了个保险机制， 双缓冲的思想。去掉A/B即可

fastbootd

	fastboot(非用户空间的刷写工具) 无法理解动态分区， 因此无法对其刷写， 因此使用用户空间实现的 fastbootd 来刷写

	新adb 命令

```sh
adb reboot fastboot # 在system下， 重启进入fastbootd模式， 在 recovery 下， 不重启直接进入fastbootd 模式
```
	fastbootd命令
```sh
	fastboot reboot recovery
	fastboot reboot fastboot
	getvar is-userspace
	getvar is-logical:<partition>
	getvar super-partition-name
	create-logical-partition <partition> <size>
	resize-logical-partition <partition> <size>
```
	没想象中那么简单， 解决了system.img 的刷入问题， 同样不能启动.

	添加动态分区， 编译不过去, 在releasescripts 下的脚本会出错. 


## Mon 11 May 2020 10:07:49 AM CST

**android 10.0 启动的过程:**

	先从bootloader 启动， 这里还有一个fastboot 和 fastbootd 之分, 

	加载内核, 这里还有一个ramdisk.img, 是放在boot.img 还是 system.img, 以BOARD_SYSTEM_AS_ROOT 


**avb 2.0启动验证**

	接着昨天的继续， 之所以不放在昨天， 就先使用流水帐的方式记录，看看效果。 

	avb 启动验证，从固件的只读部分启动。

	VBMeta, 包含很多描述符(boot payload, system payload hashtree, vendor..., userdata, other partitions), 都以加密方式签名。 

	这些签名需保证同一个, 否则会验证不通过， 所以， 要么所有分区都替换， 要么不使用avb签名? 还是每个分区可以使用不同的签名， VBMeta 带有签名吗？ 

	VBMeta分区要不要变呢?

	dm-verity

	内核命令 -> 设备树/设备树叠加层 -> 验证启动

**ramdisk**

	ramdisk 就是内存中的root文件压缩后生成的文件，其中有一个init.rc 命令文件，用于启动初始化创建好文件目录， 然后再根据 fstab 挂载相应的目录？ 


使用缓存的miui 开发版，也不能在recovery里安装，且zip 还不能解压

**apex 文件格式**

	也是 android 10.0 带来的一种容器格式， 编译需要内核支持 
	用来帮助更新不适用于标准 Android 应用模型的系统组件。 暂时先不管， 不影系统的移植

**dto/dtbo**

	dtbo.img, 在哪里去拿, 是因为我的dtbo不全吗导致的编译错误？ 明显是找不到recovery.img

	官方的boot.img 解压出来的只有initrd.img, 没有dtbo.img, 但是在redmi_lmi_dumps 里有dtbo.img, dtbo.img 为只读文件， 不可写。 
	
	这说明官方编译走的还是 system_as_root = false, ramdisk.img 放在了boot.img里  

	解压出来的 boot.cfg 可以补充修正 kernel 的配置
	
**[recovery img](https://source.android.google.cn/devices/bootloader/recovery-image?hl=zh-cn)**

	非a/b设备的recovery.img
	acpio 与 dtbo, 两种架构来描述无法检测到的设备。 
	android 9.0+ 的recovery.img 格式如下:
		启动头文件	(1页)
		内核		(l页)
		Ramdisk		(m页)
		第二阶段	(n页)
		恢复DTBO	(o页)
		后面的lmno只是变量吗？ dtbo.img 要放在第二阶段 

	现在小米的boot.img 中就没有放 dtbo. 只有 前面三个, 后面两个本来也就是放在recovery.img 中的, 那么刚才编译recovery生成不了， 是不是因为dtbo.img的问题呢？ 

###	Tue 12 May 2020 09:48:23 AM CST

recovery 添加了配置， 编译不过去

odm, product 添加了配置， 编译不过去

	can not make seperate image

boot 因为dtb, dtbo的问题， 也编不过去， 这个添加预编译， 或者在 Image.gz 后面加一个-dtb,  能解决问题， Image.gz-dtb

[liblp] Block device system size must be a multiple of its block size.

	这个错误搞半天， 还是因为英语水平的问题。 明明说的就是， system 的size 一定要是 block size 的倍数。 

[update 升级原理分析](https://blog.csdn.net/u013306216/article/details/102570202)

动态分区 一直影响编译过不去

	vendor is in target super_qti_dynamic_partitions_partition_list but no BlockDifference object is provided.

	先将qti_dynamic_partition 里只留system试一试， 其他的要怎么加? 

	只留system 确实可以刷机了， 但是product, vendor, odm 分区挂载不上， 刷了一半机，当然还是启动不了

	在test_common.py 中发现了蛛丝蚂迹，官方的教程是我没看明白？ 为何与代码中的不一样呢？ 
	事情同样没有那么顺利， 继续看源码吧， 不要一味地期待这一次就能过， 试验加看源码. 

### Wed 13 May 2020 09:20:23 AM CST

当前编译，动态分区不带 vendor, product, odm 可以编译成功， 但是刷机完， 不能正常挂载 vendor, product, odm 分区。
带上这些动态分区， 又编译不通过， 这个问题需要继续搞。 

直接将编译出来的system.img, boot.img, recovery.img 刷机都不能正常工作。 今天先搞一搞内核编译，将boot.img 这一块搞定。
这里应该也能搞明白加密的方式？ 

**lmi 内核编译**

	小米官方并不是没有出怎么编译内核的脚本， 只是我自己没找到。 MiCode的仓库， 还待再挖掘.

	envsetup.sh 补充配置编译环境
	build.sh
	buildkernel.sh

	初步从名字上看， 调用先后顺序是 envsetup.sh -> buildKernel.sh / build.sh

	buildkernel.sh 和 build.sh 为何要有两个， build.sh 是否包括了buildkernel的功能

添加dts

	在已有dts的情况下
	enable interfaces, 打开dts 所描术的接口， 这一步移植时候是否需要再做?
	copy hardware components, 复制对应芯片/设备的硬件组件
	添加自定义的hardware, 检查硬件的驱动是否已经存在， 
		检查 Documentation/devicetree/bindings, 小米的kernel中没有这个文件, 但是开源的device tree 中有这个文件夹， 要放在哪里呢？ 
		直接在dtsi 下创建一个vendor 文件夹，然后直接copy过去。。。在dts 下的makefile 已经有检查vendor
	编译platform device tree, 将device tree file 添加到makefile中

	但是在device 的配置下要如何编译, 这也是一个问题

添加driver

	仓库名已经说明了要添加在哪里 vendor_qcom_opensource_data-kernel, 自建一个data-kernel

Non-symlink out/target/product/lmi/system/product detected!
You cannot install files to out/target/product/lmi/system/product while building a separate product.img!

	TARGET_COPY_OUT_VENDOR := system/vendor
	TARGET_COPY_OUT_PRODUCT := system/product
	TARGET_COPY_OUT_ODM := system/odm

	但是这样， 又不能使用vendor.img, 导致后面的 dynamic时， product, odm, vendor 都没有了。

	既然是没有 symlink, 那就手动创建一个symlink, 这也是可以的。。。
	最终的解决办法是 去掉 PRODUCT_BUILD_PRODUCT_IMAGE := true 的配置
	然后再设置
	TARGET_COPY_OUT_VENDOR := vendor
	TARGET_COPY_OUT_PRODUCT := product
	TARGET_COPY_OUT_ODM := odm

	如果还是会出现，至对应的文件夹下查看是否已存在同名的文件夹， 若出现, 删险即可。 

AssertionError: product is in target super_qti_dynamic_partitions_partition_list but no BlockDifference object is provided.

	又回到这个问题了
	最后看来 TARGET_COPY_OUT_VENDOR,  TARGET_COPY_OUT_PRODUCT, TARGET_COPY_OUT_ODM 这几个变量配合 
	BOARD_VENDORIMAGE_FILE_SYSTEM_TYPE... 这几个变量, 再修改脚本(后续官方应该会修复吧， 或者我直接gerrit 修复一下？)
	build/make/tools/releasetools/ota_from_target_files.py 中只检测了 system 和 vendor的
	redmi k30 pro 的qti_dynamic_partitions 分组里包括四个的, 所以，不能迷信官方，官方也是在不断增加新的特性的， 这里的特性应该就属于没有来得及添加吧。
	遇到问题 还是要这样一个个的解决， 不然， 一天两天还是陷在原地，有了源码的情况下，从源码着手解决问题，虽然可能慢点， 但是靠谱的

TypeError: unsupported operand type(s) for *: 'NoneType' and 'float'

	这里要看具体的源码， 某个字段是非整型，然后查看对应的BoardConfig.mk 里是否有相关字段未设置
	还是要设置cache_size大小, 对应BoardConfig.mk 中BOARD_CACHEIMAGE_PARTITION_SIZE

fatal: No names found, cannot describe anything.
FAILED: ninja: 'out/target/product/lmi/system/system/vendor', needed by 'out/target/product/lmi/obj/NOTICE.html', missing and no known rule to make it
	
	是因为删掉 system/vendor 的缘故？  为何vendor.img 不能编译出来了， 感觉应该是添加修改了 device/../Android.mk 的创建symlink的原因
	所以就先手动删除掉 system/vendor， 然后再创建一个链接， 发现不行了。 

	就是 BOARD_VENDORIMAGE_FILE_SYSTEM_TYPE 的问题， 之前是将字段写错了, 这也是没有提示的一个大问题。 

### Thu 14 May 2020 09:33:32 AM CST

编译是一个流程， 最后打包的脚本是另一个流程，所谓的打包脚本就是将所有的资源集中在一起生成更新脚本， 大部分更新脚本也就是设置环境变量， copy操作
应用管理软件呢？ 多一个卸载与清理的工作。 

ROM移植所涉及的语言

	c/c++, java, makefile, shell, python, go, perl, xml, vim script

ROM移植所涉及的工具

	prebuilts toolchain,  shell cmd, vim 一个代码查看神器, 

avbtool add_hash_footer: error: argument --partition_size: expected one argument

	先给avb_enable关掉, 试试可否正常刷机, 不能正常启动的时候
	关掉确实不可以正常刷机， 如何配置？  
[build-system-integration](https://android.googlesource.com/platform/external/avb#Build-System-Integration)
	需要配置 bootimage, dtbo, recovery的partition size, 如 BOARD_BOOTIMAGE_PARTITION_SIZE

/home/hrst/aosp/lineage-17_0_1/out/host/linux-x86/bin/avbtool: Error getting public key: unable to load Public Key

	avb 的pubkey 要怎么配置， pubkey 与 x509.pem 是保持致的吗？ 


[avb2.0 README](https://android.googlesource.com/platform/external/avb/+/master/README.MD)

### Fri 15 May 2020 10:50:03 AM CST

avb 的启动流程怎么关闭？ 为何在recovery关掉了也还是进入不了boot? avb 验证是fastboot 负责？ 

```sh
	# 只能在userdebug编译的 ROM 下使用
	fastboot --disable-verity --disable-verification flash vbmeta vbmeta.img
```
	果然是有一步这样的操作的， 原来还要刷掉vbmeta.img

	[如何刷入android Q gsi 到treble设备](https://www.androidjungles.com/how-to-install-android-q-gsi-on-project-treble-devices/)

```sh
	# 检查是否支持 treble : 
	adb shell getprop ro.treble.enabled
	# 检查是否兼容 Andoird Q GSI, 
	adb shell 
	cat /system/etc/ld.config.29.txt | grep default.isolated 
	# 看 namespace.defualt.isolated=true 说明该设备兼容 Android Q GSI

	# 待尝试
	adb disable-verity
	adb enable-verity
```

刷了vbmeta.img 不管是关不关 验证， 都进入不了开机动画， 看来kernel与system 的编译还是都有问题, 哪里出了问题呢？ 

system_as_root 到底是true 还是不设置呢？ 

换一个内核源码编译试试， 打的补丁好像更多一些.

	缺少一些文件 .S, .i 文件， 感觉这个内核也有些不靠谱， 先给错误解决， 编着试一试吧。。。

vbmeta.img 是否需要刷

	刷了也不管用， 但是刷google 的GSI 貌似还有点用，至少可以进系统启动页了
	这个还真不太好搞，关键是没啥头绪

刷GSI的img

	在fastbootd模式下
```sh
	fastboot -u flash system name_of_system.img
```

avb 2.0 

	刷机启动不了， 最有可能的还是这里的问题, 

	vbmeta 记录了所有待验证分区的元数据, hash，sha512_r4096

SEAndroid
	
### Sat 16 May 2020 09:16:38 AM CST

avb 原理
	
	avb 是用来起启动验证各个分区的一套机制, 根据需要验证想验证的分区， 待验证的分区信息都记录在vbmeta分区，但是android不同的分区好像还有vbmeta_partition? 
	
	使用什么来验证呢？ 有加密算法， 还有hash值, 还有hashtree, 加密签名。 

	vbmeta 分区， boot的哈希值， system, vendor...的hashtree，为何还会有hashtree? 保存每个文件的hash值，所以这个原则就是每个文件都得验证.
	这样一来， 如果还想共用其他分区， vbmeta 分区还不能统一刷？ 为了兼容GSI， 所以才会有vbmeta_system, vbmeta_vendor? 那为何google 的GSI刷进去也同样启动不了呢？ 
	vbmeta 本身也是被签名的, 签名会有加密功能吗？ 还是说也只是验证当前apk

	刷完vbmeta, boot.img 还能进去， 说明什么呢？ boot.img 的hash值没有放在vbmeta? 那为何我的系统又启动不了呢？ 为何关掉avb 还是进不去呢？ 
	是没有关成功，还是我编译的系统和boot.img 有问题，大概率可能是后者。 

	如何去查看每个分区的构成, 允许单独更新一个分区， 前提是更新的分区签名保持不变。 不然还是不能验证。 

	链式分区的结构是什么， 只会记录分区名字 和 签名公钥？ 

	vbmeta 不存在加密， 只负责验证每个分区文件的完整性。 所以，如果能查看vbmeta 并手动修改， 也可以达到启动的目的， 
	查看vbmeta

	回滚保护, 如果只是一个index验证, 有什么用呢？ 能防止正常升级，降级的问题， 但是假如强制刷一个低的index, 是不是意味着也可以降级？ 
	是跟version 一样的， 已存在的apk, 只能安装 >= version 的apk升级而不能降级。 

	vbmeta 还有一个digest, 这么多验证？ 目的为何？ 

	avbtool 主是要用来生成vbmeta.img， 用来验证boot分区， system分区，及其他分区， vbmeta 分区中还可以包含其他分区的公钥， 间接性授权。 

	有公钥，没有私钥， 也不能保证相同的加密， 所以更新vbmeta 分区可以取消这种验证， 这又回到了查看与修改vbmeta 数据。

	可以直接刷system.img 以及 vbmeta_system 分区， 这意味着， 可以直接更新system.img 而不管其他分区？ 先刷回原系统看一看是否还会重新启动... 

	如何编译得到system 的vbmeta呢？ 

	dm-verity 是第一代avb吗？ 
		如何确认dm-verity关闭 adb shell mount , 可看到 vendor, system 分区挂载上了

	需要vbmeta 分区和vbsystem 分区同时关掉验证才可以, 看来刷机有望了。 但愿其他分区没有再验证。 所以这是小米手机为第三方ROM留了一点希望？ 
	
	HLOS 是什么

	Persistent Digest 
		需要放到内核 cmdline 中更新？ 

	内核版本大于4.9 必须要开始avb2.0, recovery, system 默认为chain, 其他的默认为hash

**dm-verity**	

	device mapper, 是一个虚拟块设备，专门用于文件系统的校验. 
	
	dm-verity, 与 avb 同时验证， dm-verity 验证的块有 /， /product, /vendor, /odm, /data, 看来product 与vendor 

	内核不要编译dm-verity, boot.img， 与vbmeta 分区都不开始 dm-verity, 与 avb, 会可行吗？ 到底是系统不行还是验证不通过？ 

	1. 创建 ext4 类型的system.img 
	2. 为system.img 创建hashtree
	3. 为hashtree 再创建一个 dm-verity table
	4. 为 dm-verity table 再签名
	5. 将dm-verity table 与其签名打包到 verity metadata
	6. 将system.img, dm-verity metadata, hashtree 组合在一起

	可以不管dm-verity 吗？ 合部替换掉dm-verity所在的分区， 是不是也可以达到目标？dm-verity 相关的验证信息都放在对应的img中， 那也不应该会影响验证啊
	所以， 启动不了不是dm-verity验证的原因。

	android 7.0 以前， dm-verity验证不通过， 还会提示是否继续，android 7.0 以后， 不通过直接重启到fastboot

	dm-verity 是集成内核的驱动程序, 用于大分区的验证。 

**android 验证启动流程**

[验证启动](https://source.android.google.cn/security/verifiedboot?hl=zh-cn)

	确保所有已执行代码均来自可信来源, 以防止遭受攻击扣损坏。 

	从受硬件保护的信任根到引导加载程序，再到启动分区和其他已验证分区(system, vendor, oem) 的完整信任链。 

	必须得先从这里突破了， 验证越来越多， 还真不知道是哪种原因导致启动不了. 

	受硬件保护的信任根应该不用管，可修改吗？ 可以自定义。 
	加密算法还是有些迷， 信任根密钥放在手机上，不可以读到吗？ 受硬件保护是硬件加密？ 既然在验证的时候还要读取信任根， 那么应该也能在读的时候dump下来啊？ 不读取信任根， 怎么保证计算的hash值一样呢? 公钥吗? 即然公钥算的hash值能一样， 为何不能用公钥来加密呢?然后将值写回去呢？
	信任根只能硬件厂商的程序来读， 剩下的交给fastboot 来验证? 那这样的话，其他分区的加密又是如何与信任根联系的呢？

	引导加载程序 到启动分区， 这里一盘先经过dm-verity 验证， 再经过avb 验证. 

	boot, dtbo等小分区，是直接加载到内存， 实时计算hash值来校验 
	预期的hash值是放在vbmeta分区或者分区的末尾或开头， 或同时以上两个位置. 
	最重要的是这些什是由信任根以直接或间接的方式签名的。 所以，自定义的ROM必须得关掉这个验证？ 或者走自己设置信任根的验证？ 

	从这里看， 还是要全面禁掉验证才行。

	启动状态传达给用户： 怎么在小米上就没看到这一屏， 是没有进入到这一步？

	黄色： 设有自定义信任根的已锁定的设备屏幕警告。 
	橙色： 针对未锁定设备的警各屏幕。
	红色(EIO)： 针对dm-verity损坏的警告屏幕。
	红色(未找到操作系统): 未找到有效的操作系统

	引导加载程序通过内核命令androidboot.verifiedstate 将启动时验证状态传达给Android. 设置为 greend, yellow, oragne. 
	这应该是在开发时使用，如何获取到这个值呢？ 

## Mon 18 May 2020 03:01:39 PM CST

** DTB/DTBO **

	也是有可能造成设备不启动的原因。

	先使用official rom dump 下来的 dt.img kernel 和 dtbo.img 但愿能工作吧。

	真要是工作了, 说明问题还是出在kernel编译上

ld.lld: error: out/target/product/lmi/obj/STATIC_LIBRARIES/libc++_static_intermediates/libc++_static.a(locale.o): invalid sh_type for string table, expected SHT_STRTAB

	很大可能是之前做的尝试的库，链接来了， 缓存没清掉。 清理 .soong 和 out/target/product/ 下对应 locale.o, 和 libc++_static.a 的缓存
	
prodcut 分区必须得要么？ lineage 要为product分区填了什么?

	先不带product试一试，/vendor, /product, /odm 这些还是会存在分区挂载不上的问题。 

	不带分区， 升级包太小了， 带分区， 一下子多了46000+的源码加入编译，看来product是必须要编译的

product, vendor, odm system

	system, product 是必须要编译的， vendor 虽然内容不多， 但是为了凑分区， 也还是要带, odm 基本上也没啥东西， 同样带上. 
	但是如果还是不能刷机，那也得每个组合都试一试
	对比官方脚本， dynamic partition 里四个分区都带了. 
	但是最后刷vbmeta 分区的时候， 只更新了 system, vbmeta_system, 因此， 我也不必再去编译 vbmeta_product, vbmeta_odm, vbmeta_vendor分区

	mkbootimg 工具里有 --dtb 选项， 这里使用dt.img 不行， 那就先换成里面的dtb试一试, 里面有4个dtb, 其中三个是不同的版本， 另一个名字还乱码了。
	四个一起加入dtb, 搞得recovery.img 过大， 编译不过去，那么就先使用最高版本与最高版本和乱码名字组合来编译试一试。 

avbtool make_vbmeta_image: error: argument --include_descriptors_from_image: expected one argument

	这个错误， 是动态分区里的image没有编译全, 如
	BOARD_QTI_DYNAMIC_PARTITIONS_PARTITION_LIST := system product vendor odm
	就需要将该四个分区的image都得编译出来。 
	编译分区image需配置
	BOARD_PRODUCTIMAGE_FILE_SYSTEM_TYPE := ext4
	BOARD_VENDORIMAGE_FILE_SYSTEM_TYPE := ext4
	BOARD_ODMIMAGE_FILE_SYSTEM_TYPE := ext4
	TARGET_COPY_OUT_VENDOR := vendor
	TARGET_COPY_OUT_PRODUCT := product
	TARGET_COPY_OUT_ODM := odm	

### Tue 19 May 2020 10:05:06 AM CST

**dtc dtb dts**

	如何将多个dtb集成一个呢？ dtc 可以将  dtb -> dts,  那么如何将多个dts集成一个呢？
	dtc 使用方法查看 dtc -h 即可

	目前dtc都是一对一的转换。合并的话，只能通过diff, 相同的节点以最新的为主，不同的节点都手动加进来. 

	dtc 还可以直接从运行的系统中dump下来dts.

** boot.img**
	
	使用预编译dtb, dtbo.img 可以启动， 但还是有很多驱动找不到， 打不开应用, 只能呆在桌面。 

	看官方公布的dtsi 也都是全的， 为何源码编译的就不行呢？ 至少应该dtbo 是OK 的, 先将预编译的搞定， 再接着搞源码

make: O=/home/hrst/aosp/lineage-17_0_1/out/soong/.temp/sbox144823481: No such file or directory.  Stop.
	
	这个问题是因为 device.mk 下的 PRODUCT_PACKAGES 里有的库依赖不全， 去掉或者添加完整依赖即可。 
	我这里是因为 BoardConfig 中关于wifi的配置导置的
	主要还是因为编译了wlan, 但是使用的是预编译的kernel, 没有kernel_include导致的, 加入内核源码编译就没有此问题

	然而目前使用lmi的源码，编译出来的boot.img 不能用. 大概率是dtb的问题， dtb又跟path_tool 有关。所以，得继续解决bison, flex等path_tool问题

**系统启动**

	boot.img 是正常的， recovery是正常的， 现在系统卡在欢迎界面的前一个步骤。 所以，验让的问题应该是过了， 问题出在系统启动. 


### Wed 20 May 2020 12:03:44 PM CST

**卡在boot logo**

	卡在boot logo 这里

	/proc/last_kmsg 手机里并没有，但是有last_mcrash
	/cache/recovery/last_log
	/proc/kmsg
	/dev/log
	
	并没有看到什么有效的信息。 
	补充system,vendor lib, lib64, bin 也没有个标准， 难不成几千个库都要一个个校对么。 关键因素还不在这里。 卡在boot logo 也可能是userdata 分区格式不对。是因为recovery 刷机格式命令不对？ 这条路也暂时只能放弃，一时间怎么去搞通recovery.
	
	基本可以确定，是新编的系统userdata分区的原因, 每次卡在boot logo, 再进入recvoery, 就看不到data分区了. 重新格式化就能看到了

	加入了BOARD_DYNAMIC_PARTITION_RETROFIT := true, 挂载/odm 不行，不懂的选项， 宁愿不加，格式化一下 data 分区就可以了，看来odm, 不仅仅是动态分区里的。与data分区也有关系。 

	fstab 的修改并没有起作用， 但是可以确定就是userdata分区不能正确格式化的问题

build/make/core/Makefile:28: error: overriding commands for target out/target/product/lmi/vendor/lib/libgui_vendor.so', previously defined at build/make/core/base_rules.mk:480

	这里是base_rules.mk 里本地编译的module(Android.mk, Android.bp) 与 proprietary-file.txt 或 device.mk 中的库重复了，删除掉任意一方中重复的部分即可
	问题是如何拿到 本地编译的模块呢？
	根据日志中的行数， 将本地模块打印出来是否可行, 可行， 但是本地编译的库太多了， 人工校对是不可行的

### Thu 21 May 2020 09:11:52 AM CST

**userdata 分区的格式化**

	fstab 起没起作用
	rc 文件入手
	gerrit 搜索

	是否是userdata 分区的原因？ 修改了fstab, 还是会卡在boot logo，再重启到recovery, data 分区也是好好的。 但是还是进不去系统
	将miui相关的rc 拷贝过去？ 感觉应该不是这个问题吧。

	修改fstab 是一个错误的方向？ bootdevice, 与 platform/soc/ 下的具体芯片型号有何不同？
	
host_init_verifier: device/xiaomi/lmi/rootdir/etc/init.qcom.rc: 577: Unable to find UID for 'vendor_qrtr': getpwnam failed: No such file or directory
host_init_verifier: device/xiaomi/lmi/rootdir/etc/init.qcom.rc: 578: Unable to decode GID for 'vendor_qrtr': getpwnam failed: No such file or directo

	rc 文件缺少group 怎么办, 在 config.fs 里配置

### Fri 22 May 2020 10:11:53 AM CST

**系统的启动流程**

	还是得从整个流程分析一下， 到里是为何卡住
	bootloader |-> system 
				|->boot: kernel -> ramdisk 
				|- > init -> init.rc -> zygote
					|-> services: bootanimation

	充电流程OK了， 说明vbmeta_system := system product, vendor, odm 这个思路是正确的，接下来补充lib, 与 lib64 这个思路应该也是正确的。
	fstab 能在recovery启动好， 说明也是正确的, init.rc 不是我来定制的，大概率也是OK的

	init.qcom.rc 什么时候加载呢，是这个文件的问题么？ 直接在stock rom 里dump下来的， 按说也没什么问题,  

	根据vbmeta_system 的设置，chain_parition应该是包含 vendor 与 product 预编译库如何补全，是不是因为这的问题呢?

	qcom, qcom-caf 下的包， 也可能是这个原因，目前只有sm8150, 找到8250的包试一试

	还是没有启动起来， 明天只有继续比对boardconfig.mk device.mk proprietary-file.txt 来解决问题了，应该就是这里面哪个没有配好

**sm8250 qcom-caf 打包**

	看来很有可能是这个问题， 得打个包试一试
	如何打包呢？ 先得找到发布的相关路径，之前google 上也搜索到过， 然后都是tag, 不会check 然后就放弃了
	搜索一下如何得到tag的代码就好了. 自己动手， 丰衣足食。
	
```sh
	# 查看tag
	git tag 
	# check tag 需要创建一个分支
	git checkout -b <branch name> <tag name>
```
	感觉很有可能是这个问题， 
	并不是这个问题，添加了sm8250 的qcom-caf 的库， 与使用预编译好的 so库效果一样。 so为不需重新链接。

	卡在系统启动不了，至底是因为什么呢？display相关的库， 按说也在qcom-caf里编译了

**kernel**
	
	官方开源的kernel没有问题，主要还是dtb与dtbo的问题。 
	ramdisk也没有问题，说明 fstab.qcom 也没有问题
	
	dtb的问题， 很可能就是path_tools 的问题， 需要使用clang? 不能使用 ld, bison, flex, gcc, 如何替换编译工具。
	
### Sat 23 May 2020 09:31:00 AM CST

**sm8150相关的移植**

	卡着进不了系统，关机状态下可充电，问题出在了selinux

	这里的问题太多了， avb, encryption, keymaster, gatekeepr, selinux, 哪个环节都可能出问题而导至卡在开机界面。

	selinux 一时半会还看不明白， avb的问题应该也是解决了的， 不然连boot.img 就进不了才对。 
	vbmeta_system 的逻辑分区就是 system, product.
	keymaster, gatekeepr 会影响开机么, 这应该是开机后才会影响

	dynamic partition, 现在的分区方式应该是没什么问题了。 可以充电， 启动多了一下震动了， 说明还是有一点进步？ 

	sepolicy 还待再继续研究, te, file_contex, 大概率也是这里的问题
	
	fstab 应该也是没什么问题的, recovery 可以正常加载

	recovery 现在又回到了/cache 挂载不了, 这个问题可能也是加密的原因. 

	qcom-caf 突然又编译不过去了， 屏蔽了， 会影响吗？ 与其他BoardConfig的差别最大的就是在这里。

	还是继续比对已成功的移植，动态分区的问题先不用管了， 就算没有vendor 与 odm， 应该也能正常启动的， 所以，vendor 与 odm 的库可能更多的是基于系统的应用用得到， 在启动的时候应该不用。 
	现在的问题是先点亮， recovery, 与 关机状态下充电都可以正常。 难不成是light库? 今晚再加班验证一下？ 

	
### Mon 25 May 2020 09:35:29 AM CST

**开机启动**
	
	rom 移植， vendor, product, 不应该是启动流程所必须的，保证了boot.img 正常， ROM自身应该保证自身的运行顺畅.

	product, vendor, 是针对自身的硬件发挥完全的功能， 有些功能不是必须有的。 

	所以这样一想， 移植就变得简单多了。 至少点亮起来，应该简单多了。 
	并没有那么简单， 按说现在的rc 与 te文件没什么问题了， 还是一样启动不了。 去掉vendor库， 系统直接启动不了了, 所以，vendor库还是有作用的。
	现在也只剩下补一补vendor, 如何dump stock rom 呢？ 

**keymaster**

	修改了系统版本，安全补丁等重要信息， 就会进入keymaster 锁定页。 这个时候，只能进入recovery双清。

**init.rc 的加载**

	里面是有包含  /vendor/etc/init/hw/init.qcom.rc

	vold.decrypt=trigger_restart_framework, 才会触发 start bootanim

	如何才能将属性变成 trigger_restart_framework

**metadata**

	擦除了metadata分区， 装官方的ROM也启动不了了, 会直接进入recovery， 但是充电流程还可以， 说明充电流程是不用验证的。 
	一直启动不了可能也是这个原因。 
	格式化一下data分区就可以了，看来metadata分区也是系统启动的时候才会刷写的
	那么，清除metadata分区再格式化， 是否可以进入呢？

ld.lld: error: undefined symbol: HMI
referenced by BootControl.cpp:107 (hardware/interfaces/boot/1.0/default/BootControl.cpp:107)
	
	这个问题可能也需要解决，定义 PRODUCT_STATIC_BOOT_CONTROL_HAL :=  就会出现这个错误

### Tue 26 May 2020 09:20:27 AM CST

** init.rc 加载源码**


	这一步是走到了
	init.cpp -> ro.bootmode -> trigger charger
							-> trigger late_init

	init.rc -> late_init -> 
				 early_fs
				 fs
				 post_fs
				 late_fs
				 post_fs_data
				 load_persist_props_action
				 zygote-start
				 firmware_mounts_complete
				 early-boot
				 boot

	
	early_fs -> start vold 
		需要先挂载metadata, 然后用vold 来处理userdata 的 checkpointing, 看来这里很可能有问题。 vold_decrypt 的属性更改应该就在vold代码里。 

		start void 但是没看见vold 的services 注册，应该是加入了环境变量

		如何处理userdata的checkpoint?

	post_fs -> 
		exec - system system -- /system/bin/vdc checkpoint markBootAttempt
		...
		restorecon_recursive /cache
		...
		restorecon_recursive /metadata

		restorecon_recursive 作用, 与 restorecon 有何不一样

	late_fs ->
		class_start early_hal ->
			init.qcom.rc -> vendor.sensors 走得通

	post_fs_data
		mark_post_data
		start vold 为何又要再次检查checkpoint
		exec - system system -- /system/bin/vdc checkpoint prepareCheckpoint
		...
		restorecon /data	
		installkey /data	没有installkey, 只有vendor/bin 下的 KmInstallKeyBox, 是否需要替换, 在init.qcom.rc 是否可以替换
		bootchar start		哪里都没有找到bootchart, 这里可能就是第二屏？ 
		exec -- /system/bin/fsverity_init	在apex前执行, 这里的验证应该也还没有走到, 验证就需要key, 这里的key需要依赖信任根么, 打包有此elf
		enter_default_mount_ns
		start apexd			不标注的就直接看源码注释,下同
		...
		parse_apex_configs

		init_user0

		restore --recuresive --skip-ce /data , 设置 selinux context

mkuserimg_mke2fs.py ERROR: Failed to run e2fsdroid_cmd: set_selinux_xattr: No such file or directory searching for label "/existing_folders"
e2fsdroid: No such file or directory while configuring the file system

	更新sepolicy下的 file.te, file_contexts

** 找到触发 trigger_restart_framework时机**

	一个好的编程环境真得很重要， 接下来还要将vim 的环境再好好整一整， 熟悉起来。 
	system/core/fs_mgr/fs_mgr_vendor_overlay.cpp 
	system/vold/crypfs.cpp	

	hardware/qcom-caf/sdm/
	hardware/qcom/		这两个路径下也发现了不一样的地方

### Wed 27 May 2020 09:38:30 AM CST

**启动流程**

	见到启动动画就是胜利
	见到画面太难了， 打了一天的qcom的补丁.

	一个启动流程太多验证了 avb2.0, dm-verity, SELinux, dynamic partition, keymaster, cryptfshw(hardware disk encryption), ab分区
	其中avb2.0 涉及到的分区又多了几种组合， avb2.0 + ab/非ab分区 + 动态/非动态分区. 

	boot rom -> bootloader -> kernel -> init -> zygote -> dalvik vm -> system servers -> managers

	现在肯定是卡在init 这里了, 分析init.cpp

### Thu 28 May 2020 09:21:02 AM CST

**SELinux**

	这个也可能是启动不了的原因。今天将所有的selinux加上，错误修改出来，再编译出来看看。

	先将正常启动的系统内核日志拿出来. 
	adb shell su -c dmesg > dmesg.log
	[还有什么日志？](https://zybuluo.com/guhuizaifeiyang/note/886803)
	系统日志, init日志, bootchart日志，
	除了内核日志， 在bootstrap 界面， 其他的日志都拿不到。 难道就没有办法了吗？
	
	通过比对官方系统启动与lineage recovery启动的dmesg日志， 并未发现问题

	sepolicy 应该不成问题了， 问题出在哪里呢？ 
	
	init.cpp 也没看出什么门道， 在init.rc中只有在vold.decrypt=triggerrestart_framewrok时才会触发， 而上面说的是在a/b update verifier才可以
	这要是闹哪样？ redmi k30 pro 是非A/B动态分区的. 官方教程里恰恰没有这个说法. 
	
**init.cpp**

	
build_image.py - ERROR   : Failed to build out/target/product/lmi/obj/PACKAGING/systemimage_intermediates/system.img from out/target/product/lmi/system
Out of space? Out of inodes? The tree size of /home/hrst/aosp/lineage-17_0_1/out/soong/.temp/tmpVLn8BF is 974251008 bytes (929 MB), with reserved space of 0 bytes (0 MB).
The max image size for filesystem files is 2113515520 bytes (2015 MB), out of a total partition size of 2147483648 bytes (2048 MB).
common.ExternalError: Failed to run command '['mkuserimg_mke2fs', '-s', '/home/hrst/aosp/lineage-17_0_1/out/soong/.temp/tmpKLMoyj', 'out/target/product/lmi/obj/PACKAGING/systemimage_intermediates/system.img', 'ext4', '/', '991031296', '-j', '0', '-D', 'out/target/product/lmi/system', '-L', '/', '-i', '16384', '-M', '0', '-c', '--inode_size', '256', 'out/target/product/lmi/obj/ETC/file_contexts.bin_intermediates/file_contexts.bin']' (exit code 4):

	什么是innode count
	这个问题怎么突然出现了， 不应该啊
	BOARD_ROOT_EXTRA_FOLDERS := existing_folders persist metada firmware
	exsiting_folders 是个什么鬼， 为何会检测这个文件

### Fri 29 May 2020 10:10:15 AM CST
vendor/qcom/opensource/fm-commonsys/jni/Android.mk: error: "libqcomfm_jni (SHARED_LIBRARIES android-arm64) missing libbtconfigstore (SHARED_LIBRARIES android-arm64)" 
You can set ALLOW_MISSING_DEPENDENCIES=true in your environment if this is intentional, but that may defer real problems until later in the build.
vendor/qcom/opensource/fm-commonsys/jni/Android.mk: error: "libqcomfm_jni (SHARED_LIBRARIES android-arm) missing libbtconfigstore (SHARED_LIBRARIES android-arm)" 
You can set ALLOW_MISSING_DEPENDENCIES=true in your environment if this is intentional, but that may defer real problems until later in the build.
vendor/qcom/opensource/fm-commonsys/fm_hci/Android.mk: error: "libfm-hci (SHARED_LIBRARIES android-arm64) missing android.hidl.base@1.0 (SHARED_LIBRARIES android-arm64)" 
You can set ALLOW_MISSING_DEPENDENCIES=true in your environment if this is intentional, but that may defer real problems until later in the build.
vendor/qcom/opensource/fm-commonsys/fm_hci/Android.mk: error: "libfm-hci (SHARED_LIBRARIES android-arm64) missing vendor.qti.hardware.fm@1.0 (SHARED_LIBRARIES android-arm64)" 
You can set ALLOW_MISSING_DEPENDENCIES=true in your environment if this is intentional, but that may defer real problems until later in the build.
vendor/qcom/opensource/fm-commonsys/fm_hci/Android.mk: error: "libfm-hci (SHARED_LIBRARIES android-arm) missing android.hidl.base@1.0 (SHARED_LIBRARIES android-arm)" 
You can set ALLOW_MISSING_DEPENDENCIES=true in your environment if this is intentional, but that may defer real problems until later in the build.
vendor/qcom/opensource/fm-commonsys/fm_hci/Android.mk: error: "libfm-hci (SHARED_LIBRARIES android-arm) missing vendor.qti.hardware.fm@1.0 (SHARED_LIBRARIES android-arm)" 
You can set ALLOW_MISSING_DEPENDENCIES=true in your environment if this is intentional, but that may defer real problems until later in the build.
vendor/qcom/opensource/location/gnsspps/Android.mk: error: "libgnsspps (SHARED_LIBRARIES android-arm64) missing libgps.utils (SHARED_LIBRARIES android-arm64)" 
You can set ALLOW_MISSING_DEPENDENCIES=true in your environment if this is intentional, but that may defer real problems until later in the build.
vendor/qcom/opensource/location/gnsspps/Android.mk: error: "libgnsspps (SHARED_LIBRARIES android-arm) missing libgps.utils (SHARED_LIBRARIES android-arm)" 
You can set ALLOW_MISSING_DEPENDENCIES=true in your environment if this is intentional, but that may defer real problems until later in the build.
vendor/qcom/opensource/location/loc_api/loc_api_v02/Android.mk: error: "libloc_api_v02 (SHARED_LIBRARIES android-arm64) missing libqmi_cci (SHARED_LIBRARIES android-arm64)" 
You can set ALLOW_MISSING_DEPENDENCIES=true in your environment if this is intentional, but that may defer real problems until later in the build.
vendor/qcom/opensource/location/loc_api/loc_api_v02/Android.mk: error: "libloc_api_v02 (SHARED_LIBRARIES android-arm64) missing libqmi_common_so (SHARED_LIBRARIES android-arm64)" 
You can set ALLOW_MISSING_DEPENDENCIES=true in your environment if this is intentional, but that may defer real problems until later in the build.
vendor/qcom/opensource/location/loc_api/loc_api_v02/Android.mk: error: "libloc_api_v02 (SHARED_LIBRARIES android-arm64) missing libloc_core (SHARED_LIBRARIES android-arm64)" 
You can set ALLOW_MISSING_DEPENDENCIES=true in your environment if this is intentional, but that may defer real problems until later in the build.
vendor/qcom/opensource/location/loc_api/loc_api_v02/Android.mk: error: "libloc_api_v02 (SHARED_LIBRARIES android-arm64) missing libgps.utils (SHARED_LIBRARIES android-arm64)" 
You can set ALLOW_MISSING_DEPENDENCIES=true in your environment if this is intentional, but that may defer real problems until later in the build.
vendor/qcom/opensource/location/loc_api/loc_api_v02/Android.mk: error: "libloc_api_v02 (SHARED_LIBRARIES android-arm) missing libqmi_cci (SHARED_LIBRARIES android-arm)" 
You can set ALLOW_MISSING_DEPENDENCIES=true in your environment if this is intentional, but that may defer real problms until later in the build.
vendor/qcom/opensource/location/loc_api/loc_api_v02/Android.mk: error: "libloc_api_v02 (SHARED_LIBRARIES android-arm) missing libqmi_common_so (SHARED_LIBRARIES android-arm)" 
You can set ALLOW_MISSING_DEPENDENCIES=true in your environment if this is intentional, but that may defer real problems until later in the build.
vendor/qcom/opensource/location/loc_api/loc_api_v02/Android.mk: error: "libloc_api_v02 (SHARED_LIBRARIES android-arm) missing libloc_core (SHARED_LIBRARIES android-arm)" 
You can set ALLOW_MISSING_DEPENDENCIES=true in your environment if this is intentional, but that may defer real problems until later in the build.
vendor/qcom/opensource/location/loc_api/loc_api_v02/Android.mk: error: "libloc_api_v02 (SHARED_LIBRARIES android-arm) missing libgps.utils (SHARED_LIBRARIES android-arm)" 
You can set ALLOW_MISSING_DEPENDENCIES=true in your environment if this is intentional, but that may defer real problems until later in the build.
vendor/qcom/opensource/location/synergy_loc_api/Android.mk: error: "libsynergy_loc_api (SHARED_LIBRARIES android-arm64) missing libqmi_cci (SHARED_LIBRARIES android-arm64)" 
You can set ALLOW_MISSING_DEPENDENCIES=true in your environment if this is intentional, but that may defer real problems until later in the build.
vendor/qcom/opensource/location/synergy_loc_api/Android.mk: error: "libsynergy_loc_api (SHARED_LIBRARIES android-arm64) missing libqmi_common_so (SHARED_LIBRARIES android-arm64)" 
You can set ALLOW_MISSING_DEPENDENCIES=true in your environment if this is intentional, but that may defer real problems until later in the build.
vendor/qcom/opensource/location/synergy_loc_api/Android.mk: error: "libsynergy_loc_api (SHARED_LIBRARIES android-arm64) missing libloc_core (SHARED_LIBRARIES android-arm64)" 
You can set ALLOW_MISSING_DEPENDENCIES=true in your environment if this is intentional, but that may defer real problems until later in the build.
vendor/qcom/opensource/location/synergy_loc_api/Android.mk: error: "libsynergy_loc_api (SHARED_LIBRARIES android-arm64) missing libgps.utils (SHARED_LIBRARIES android-arm64)" 
You can set ALLOW_MISSING_DEPENDENCIES=true in your environment if this is intentional, but that may defer real problems until later in the build.
vendor/qcom/opensource/location/synergy_loc_api/Android.mk: error: "libsynergy_loc_api (SHARED_LIBRARIES android-arm) missing libqmi_cci (SHARED_LIBRARIES android-arm)" 
You can set ALLOW_MISSING_DEPENDENCIES=true in your environment if this is intentional, but that may defer real problems until later in the build.
vendor/qcom/opensource/location/synergy_loc_api/Android.mk: error: "libsynergy_loc_api (SHARED_LIBRARIES android-arm) missing libqmi_common_so (SHARED_LIBRARIES android-arm)" 
You can set ALLOW_MISSING_DEPENDENCIES=true in your environment if this is intentional, but that may defer real problems until later in the build.
vendor/qcom/opensource/location/synergy_loc_api/Android.mk: error: "libsynergy_loc_api (SHARED_LIBRARIES android-arm) missing libloc_core (SHARED_LIBRARIES android-arm)" 
You can set ALLOW_MISSING_DEPENDENCIES=true in your environment if this is intentional, but that may defer real problems until later in the build.
vendor/qcom/opensource/location/synergy_loc_api/Android.mk: error: "libsynergy_loc_api (SHARED_LIBRARIES android-arm) missing libgps.utils (SHARED_LIBRARIES android-arm)" 
You can set ALLOW_MISSING_DEPENDENCIES=true in your environment if this is intentional, but that may defer real problems until later in the build.
vendor/qcom/opensource/location/utils/loc_socket/Android.mk: error: "libloc_socket (SHARED_LIBRARIES android-arm64) missing libgps.utils (SHARED_LIBRARIES android-arm64)" 
You can set ALLOW_MISSING_DEPENDENCIES=true in your environment if this is intentional, but that may defer real problems until later in the build.
vendor/qcom/opensource/location/utils/loc_socket/Android.mk: error: "libloc_socket (SHARED_LIBRARIES android-arm64) missing libqsocket (SHARED_LIBRARIES android-arm64)" 
You can set ALLOW_MISSING_DEPENDENCIES=true in your environment if this is intentional, but that may defer real problems until later in the build.
vendor/qcom/opensource/location/utils/loc_socket/Android.mk: error: "libloc_socket (SHARED_LIBRARIES android-arm) missing libgps.utils (SHARED_LIBRARIES android-arm)" 
You can set ALLOW_MISSING_DEPENDENCIES=true in your environment if this is intentional, but that may defer real problems until later in the build.
vendor/qcom/opensource/location/utils/loc_socket/Android.mk: error: "libloc_socket (SHARED_LIBRARIES android-arm) missing libqsocket (SHARED_LIBRARIES android-arm)" 
e

	待补全的库

**dtb编译**

	有可能是dtb的问题，boot.img unpack出来的dtb只有4个， 而dump中dtbo下有13个dtb, 肯定是不对等的。
	而我现在使用的预编译dtb 和刷进去的dtbo.img 肯定也是不对等的， recovery可以理解为first stage 没有加载dtbo, 
	那为何替换到原有的系统是可以的呢？ 原有的系统虽然可以启动， 但是第一次启动明显有问题， 所有的应用都打不开, 而放到移植的ROM中就有可能是致命的
	所以，再次使用开源的dtb试一试.  

	很大可能是dtb的问题， 虽然现在编译还没有过， 但是可以通过unpacking boot.img 来查看是否编译成功。 
	还是脚本的设置 
	BOARD_KERNEL_IMAGE_NAME := Image.gz-dtb 后面跟-dtb 是加在内核后面，还是放在boot.img里

	BOARD_INCLUDE_DTB_IN_BOOTIMG := true  这个设置为true了， 但是boot.img里还是没有dtb

	BOARD_KERNEL_SETPERATED_DTBO := true 这个在编译源码的时候， 设置为true, 是为了单独编译出dtbo.img


**boot.img**
	
	kernel, 编译出来相关30M
	dtb,  编译出来相差2M
	ramdisk, 编译出来相差 fstab.qcom, verity_key

	如果不指定BOARD_MKBOOTIMG_ARGS 还编不进去dtb， 
	要编译dtb, 需要设置 BOARD_INCLUDE_DTB_IN_BOOTIMG := true
	相关逻辑是在vendor/lineage/build/tools/task/kernel.mk 中， 这时候不用指定BOARD_MKBOOTIMG_ARGS的-dtb参数。 

	但是编译出来的boot.img 还是启动不了， 是内核的原因？

	dtb.img 与 dtbo.img还不能同时生成， 这肯定是脚本有问题

	有几种试验方法:

		1. lmi-defconfig 中取消 CONFIG_BUILD_ARM64_DT_OVERLY=y 的设置， 但是这样，又不能包含 lmi,cmi,umi 的配置了。可能dtb里就是只有kona的设置吧。因为dump下来的也是这样
		2. ramdisk 中如何添加上verity_key 与 fstab.qcom
		3. 将所有的都替换成stock, kernel要如何替换, 编译错误一时半会还不好解决
		4. 先生成dtbo.img 再以预编译dtbo 与dtb配合
		
	使用预编译的 dtb, dtbo.img 源码编译内核， 还是启动不了， 但是手动刷入stock boot.img，竟然可以启动adbd服务，但是界面还是黑的， 依旧卡在boot logo
	看来， dtb 与 dtbo 不对应的方向是正确的。 

### Mon 01 Jun 2020 09:10:27 AM CST

将stock的dtb反编译成dts, 看看是否可以.

* 试一试配套版本的dtb,  与 dtbo
	全部使用 BOARD_MKBOOTIMG_ARGS来编译boot.img

	事实证明是不行的，但是这样还是不能确定boot.img 与 stock.img是配套的， boot.img 是从11.0.16版本拿的， dtbo.img 是从11.0.10版本dump下来的

	使用booting 中的四4个dtb来编译呢？ 

	同样不行， 看来这样样子是不行的

* 内核源码的编译

	[参考教程](https://github.com/MiCode/Xiaomi_Kernel_OpenSource/wiki/How-to-compile-kernel-standalone)

	按说使用源码编译不应该连亮都点不起来

	还是要参考已有的内核与device 配置

	bindings有什么用

	data-kernel, dlkm 用来动态加载内核模块，这个还是很有用的， 需要加进来

	CONFIG_BUILD_ARM64_DT_OVERLAY=y

	还是要配置在lmi_defconfig中, 这样也可以解释得通了，为何明明修改了，dtbo 却没有编译

	设置环境变量与放在.config里有何不同？

* ramdisk的定制， fstab, verity_key

* 不使用dtbo.mk ，直接使用 makefile中的编译规则试一试。 
	编译不过，脚本一时半会修改不了

* 再次尝试源码编译

	借荐了StorySea的源码，打上了audio-kernel, 与 data-kernel的代码， 但是依旧不能启动, 这样问题就大了

WARNING: EXPORT symbol "gsi_write_channel_scratch" [vmlinux] version generation failed, symbol will not be versioned.
kernel/time/time.o: In function `__do_sys_gettimeofday':
/home/hrst/aosp/lineage-17_0_1/kernel/xiaomi/sm8250/kernel/time/time.c:148: undefined reference to `do_gettimeofday'

	换成gcc编译， 没有此问题， 再切回clang, 因为有缓存的原因也没有问题，但是终究是个问题， 暂时以micode wiki的环境初始化，重新安装了一波

[/home/hrst/aosp/lineage-17_0_1/kernel/xiaomi/sm8250/scripts/Makefile.headersinst:106: usr//audio/dsp/elliptic/.install] Error 1
[/home/hrst/aosp/lineage-17_0_1/kernel/xiaomi/sm8250/scripts/Makefile.headersinst:32: elliptic] Error 2
[/home/hrst/aosp/lineage-17_0_1/kernel/xiaomi/sm8250/scripts/Makefile.headersinst:32: dsp] Error 2

	audio-kernel库编译不过


### Tue 02 Jun 2020 09:11:47 AM CST

**复盘**

	到现在还是启动不了:
	
	内核编译阶段: 
		MiCode的公布的源码都已经集成且编译通过， 使用预编译好歹还能卡着， 使用源码编译， 直接到bootloader
		
		qcom-caf 搜索到的 sm8250的源码也集成进去，可以编译通过了， 难不成还有什么打包问题么？ 这个应该在Android.mk里已经有了

	验证阶段:
		bootloader 负责验证 boot.img vbmeta.img , 加载 dtb ，传递内核命令启动内核 
		boot.img 是avb1.0， 通过自带的verity_key 验证，这个验证方式是否可控， 还是说已经放到bootloader中了，不可改， 那为何使用预编译的dtb,dtbo就可以启动起来呢？ 
		vbmeta 中负责对vbmeta_system进行校验， vbmeta_system中又存在对system的校验key, system,vendor先采用dm-verity进行校验。
		dm-verity是由内核负责校验， 是如何校验的呢？ 
		为何会卡住？ 为何会将adbd启动起来了，但是还是进入不了bootanim, 进入不了启动画面？ 

		这里面任何一个环节都可能造成卡住， 所以， 每一个环节如何验证工作OK？ 如何去排除问题？ 

		使用预编译的dtb, dtbo可以启动起来原系统， 说明boot.img 不存在verity_key验证问题。现在boot.img 启动不了， 还是说明dtb, dtbo本身的问题。 
		既然如此， 单独编译dtb, 手动合成boot.img 验证是否可行。 

		编译阶段与手动打包阶段是分开的， 打包阶段就是将所需要的文件与库放到一起， 然后写好刷机脚本。 

	接下来的方向:
		先搞定boot.img, 能启动原系统， 说明boot.img 是可以的。
		
		接下来就是dtbo.img 与 vbmeta.img vbmeta_system.img 这几个如何得知验证是否通过呢？ 

		分析这些img, 比对整个结构， 这里无非就是key 与hash值. 

		这一关搞定了还是启动不了， 才是rc文件或者库文件的问题。 

		这个策略就是假定整个系统的编译脚本是OK的， 所以打包出来的系统应该也是OK的，
		当然, avb1.0, 动态分区， 非A/B 更新这些都没有参考， 但是10.0 也不可能不支持非A/B启动吧
		
		boot.img 和 dtbo.img 是读入到内存通过hash值来验证的， 这个预期的hash值存在哪里呢？ 
		通常存在每个经过验证的分区的末尾或开头，专用分区中, 或同时位于两个位置。

		boot.img 应该是存在末尾， 因为替换可以验证成功。 

		dtbo.img, 应该是存在vbmeta.img 中 

		system, vendor, product, odm 应该是同时存在vbmeta_system, vbmeta分区中

		为何要这样搞一套呢？ 生成这套key是根据信任根来生成的？ 那么移植其他系统也就拿不到这个信任根。

		如果不是根据信任根生成的， 那么对安全保护有没有作用啊， 想要修改ROM的人整体替换一套就可以了。

boot.img 替换工作, 验证boot.img 没有问题

	还得使用手动集成的dtb ? 为何直接将反译的源码放进去就不行呢？ 

	手动集成只有用一个kona_v2.1, 而代码编译的多出来了好多， 这些会有影响么？ 手动集成的也不行了

	unpack_bootimg 解压出来的dtb并不能用， 而且mkbootimg 就不能正常启动了， 开始是因为校验的原因， 关了校验， 虽然可以启动，但是不正常，必须要重启一次才能正常。

	那么正常的打包方式该是什么样的呢？ 原内核里通过unpack_bootimg 可以看到有dtb的存在。
	但是使用abooting 就看不到，这个应该是工具的原因， 那么再下载几个其他的工具试一试。

	换一种编译方式， 使用内核带dtb的形式， 看看booting 里是否还可以解析出来dtb的存在？ 

boot.img dtbo.img vbmeta.img, vbmeta_system.img 分析验证, 是否需要手动打包，添加验证。 

	mkbootimg 手动打包的boot.img 可以启动, 说明不用验证hashtree? 那么内核启动不了就是因为dtb与dtbo的原因？ 

	使用mkbootimg 手动打包也启动不了了， 只能见到开机动画， 还是会无限重启， 说明， unpack下来的包里面的内容有问题， 或者 mkbootimg 有问题。

	添国avbtool是一样的效果, 照我的理解，这应该是启动起来了， 但是data分区未能验证成功， 删除了data分区， 也同样启动不了。 是dtb的问题？ 
	dtb确实很重要， 屏幕显示一样需要dtb.  

	mkdtimg 不能读 boot.img unpack出来的dtb, 但是可以读 dtbo.img， 所以， unpack出来的dtb有损失
	
	avbtool 可以读 vbmeta.img vbmeta_system.img

	exaid.img 竟然也是一个boot.img 只不过内容要大得多， 这个是为了什么呢?  擦除exaid分区也不影响启动，exaid是干什么的呢？ 

root digest 是干什么的

avb 校验

	第一阶段挂载vendor 是通过device tree, 第二阶段再通过vendor 中的fstab 来挂载其他分区
	
	avb 与 dm-verity是绑定的， 所以第一阶段， 不仅要传ftb节点， 还要传vbmeta节点，目的是开始dm-verity功能。
	device tree 中的vbmeta 的节点配置要与vbmeta.img 所包含的分区一致， 否则校验失败. 

	fastboot --disable-verity --disable-verification flash 并不一定起作用, 除非不止验证分区， 还需要vbmeta 拿到启动分区？ 

	刷完vbmeta 分区与 vbmeta_system分区，还得再重新刷一下boot.img 才行

	vbmeta 的形式已经一样了， 除了root digest, salt

加密验证的原理

	要想加密，肯定还有一个私钥是不能暴露的， 那么意味着移植的ROM必须关掉验证？ 

	如果只是像第三方下载给一个sha256值, 那也只是保证局部修改的安全, 如push一个系统分区的app, root, 
	如果整体都修改了， 再重新生成对应分区就可以为所欲为了。如果全部替换了， 那安全就属于自己的责任， 不能怪到官方ROM了
	官方本来就是只保证自己的系统安全性就行了， 所以， 这个验证应该不影响移植。 

	verity_key 的分解替换优先级放到最后。 
	
	salt 是随机值
	root digest, 是根所salt, private key, algorithm 计算出来的 
	verity_key 是不是计算root digest的因素呢？ 到底有没有用到信任根。 还是只是某个分区使用了信任根。 

	不管如何，在dts 中先关掉avb验证


哪一个device tree 中有vbmeta节点

	在kona.dtsi 中， 但是recvoery也确实在vbmeta.img 中有， 不用禁用， 只不过官方的recovery是chain partition, 自编的是 hash验证

内核的补丁还打错了不成

	打了 data-kernel, audio-kernel 补丁，反而不能正常启动了，先去掉试一试

	
### Wed 03 Jun 2020 09:28:42 AM CST

abooting 直接替换kernel试试, 还有没有其他解压booting 的工具， 小米的工具？ 
	
	abooting 替换过的kernel并不能正常启动，哪怕是替换成 unpack出来的kernel
	abooting 有问题
	fastboot --disable-verity --disable-verification 并不管用，还是会再校验boot.img 
	unpacking出来的kernel有问题？ 
	
	unlock状态下， 不会去验证boot.img recovery.img 小米会校验吗？ 应该不会, 因为之前有替换自己的内核成功过，先假设其不验证。 
	无论是解锁或锁定状态下，都支持avb, 锁定状态下， 难证不通过是致命的， 非锁定状态下
	AVB_SLOT_VERIFY_RESULT_ERROR_PUBLIC_KEY_REJECTED
	AVB_SLOT_VERIFY_RESULT_ERROR_VERIFICATION
	AVB_SLOT_VERIFY_RESULT_ERROR_ROLLBACK_INDEX
	这几种状态并不是致命

	那么问题就集中在boot.img 上: kernel, ramdisk, dtb, dtbo上了
	之前是有启动过原系统，但是第一次会crash重启，第二次就好了，但是同样的dtb, dtbo为何Lineage就启动不了？ 
	unlock 只是不校验boot.img 与 recovery.img， 并没有说不校验dtbo.img, vbmeta, 所以还是要确定fastboot 验证的key是否是自定义的还是有一个信任根

	先替换kernel能成功启动再说

fastboot 验证是否用到信任根。sha256算法原理

	可以替换自定义信任根
```sh
	# 得到公钥
	avbtool extract_public_key --key key.pem --output pkmd.bin
	# 刷入
	fastboot flash avb_custom_key pkmd.bin
	fastboot erase avb_custom_key
```
	但是这并不影响原有系统的启动, 到这里，暂且认为现有的系统vbmeta验证功能是OK的

vbmeta, vbmeta.img 除了read的信息， 还有没有其他的手段再作比较？

	信任链， 从信任根开始验证， 自定义信任根不知是否工作。

dtb 的编译，dtbo是如何对应上

	Image.gz-dtb 是直接使用 cat Image.gz dtb > Image.gz-dtb 中的
	当前的内核编译， 是不带dtb 的， 但是用不用压缩呢？ 原系统的boot.img 应该是没有使用压缩. 
	
	使用dump下来的dtb, 修改脚本， 直接拼接dtb, 就是不知道会不会编译出dtbo, 

devicetree还有哪里可以拿到, 只是kona的可以否？ 只能等小米开放？

	先提个issue, 
	只是kona的应该是不可以的，反编译出来的代码时面的fragment 还是挺多的

### Thu 04 Jun 2020 09:21:55 AM CST

dtb,dtbo

	使用dump dtb ，修改脚本看看效果。

		dtbo 就是直接使用mkdtimg create 来创建的

		直接使用dump dtb 会报这个错误:
		The file size and FDT size are not matched.
		
	dtb 与 dtbo有何区别
		使用mkdtimg dump 都解析不出来 ftsize， 为何编译的dtbo就可以生成dtbo.img

		一般 soc的设备节点作为 dtb, 其他设备作为dto, dto可以对dtb的节点进行引用和修改。 
		dtb文件与dtbo的文件格式相同。但是还是建议将名字改为dtbo, 以区分主dt

		内核的加载流程：
			将dtb加载到内存, 将dtbo加载到内存，将dtbo叠加dtb合成dt

		所以dtb是kona 的三个版本是对的

	修复lmi-overlay-dtbo.dts 编译警告， 只是警告， 为何会有错误呢？ 
		修复不了， 不是简单的include 几个dtsi就行的, 先假定lmi-sm8250-overlay.dts是正确的

	源码dtb, dtbo 配合stock kernel

		好歹现在编译的内核还会卡在那里，说明dtb, dtbo是OK的？ 
		
编译内核再次验证 Image.gz, Image, 为何就启动不了呢？

	在源码中找到了unpack_bootimg.py, mkbootimg, 现在可以确定工具都是OK的， 将原boot.img 解包再封包可以正常启动

	替换自编译的 kernel, ramdisk, dtb, 都会造成启动不起来。

	ramdisk 里面就差了一个fstab.qcom, verity_key, 然而 --disable_verification vbmeta分区， 还是不能正常启动，fstab.qcom 和 verity_key都用到了没？
		已验证， veirty_key可以没有， 但是fstab.qcom 一定得有。 编译的init也没有问题。 说明--disable_verification还是有用的

	dtb 与 dtbo相信源码应该也对应上了， 那么问题主要还是kernel上

	看业问题就是卡在内核上，并不是其他的什么验证。 

	已确定编译的内核有问题， ramdisk 中缺少 fstab 

编译的设备树验证

	去掉 BUILD_WITHOUT_VENDOR, qcom-caf/kona库竟然编译不过了，display, media, audio 各种缺少库, 不编译vendor的时候，可以正常通过. 
	这里面有什么关联？ PRODUCT_PACKAGES 里的库也会影响冲突

	原来是kernel/../techpack/audio 下的补丁， 这两个地方打补丁有些冲突，还是直接打在内核中比较好， 改动的地方比较少。
	但是这样又回去了， 打在内核里的补丁还是跑不起来

	BUILD_WITHOUT_VENDOR := true 这个配置很神奇，去掉了， 各种冲突，主要是编译了 qcom-caf 里的选项
	看来一直都没有编译里面的代码？
	这个配置还是需要去掉, 


	product_copy_files 一定程度上是可以避免再编译的，源码编译是为了打补丁， 现在我主要是为了跑起来。 


内核继续验证

	内核在之前记得是有编译成功过的。 现在恢复源码竟然也不能启动起来

ramdisk 为何会缺少fstab

	实现不行就先使用预编译的

### Fri 05 Jun 2020 09:37:48 AM CST

**qcom-caf/kona编译**

	各种找不到头文件的， 是因为lineage将codeaurora 的代码都放在了 qcom-caf中， 而Android.mk 中的local_c_includes 路径还没有改
	因此根据编译错误修改一下include路径

	按步就班改完编译问题， 但是启动还是卡在boot logo, 而且连震都不震一下。 

	这是什么逻辑？ 换boot.img, dtbo.img, vbmeta.img 都是一样的效果。 说明进入到哪一步了？ 系统起作用了？ 缺少库？ 

	以前这几个任一个对不上都会重启到fastboot, 何种原因会卡住呢？ vbmeta 就没过？ 

	自编的dtb 是可以了， 看来问题就出在kernel 和 lineage 的配置了。 
	kernel也暂时先使用预译的， 那么着重来攻克 lineage 的配置了。 

	问题是出在dtbo上，换了dtbo是同样卡在那不动了, 连震都不震一下。 

**dtbo**

	缺少的源码， 只能等小米公开了。

	暂时也先使用预编译的dtbo， 这也说明了当初的思路是正确的？ 
	至少recovery 和kernel可以启动起来。 但是不确定dtb是否正确。 
	这折腾了7天， 就是为了确定dtb的问题。 kernel要怎么玩？ 为何不能启动原系统了？ 

**lineage配置**

	这不又相当于搞回来了, 最终device, vendor配置还是有问题的

	能想到的就是初始化的时候， 需要初使化某些属性, 这里确实有一个init.cpp
	或者在初始化的时候， vendor下的库不全 

	vendor库为何一下子就变得那么小了, 开始还有800M

	参考 k20 pro 的配置， 再加上一个 sdm660的配置， 综合看看缺少什么。 

**kernel的问题**

	现在启动不了了， 什么原因？ BoardConfig.mk, device.mk 的修改？ 这又能影响内核什么呢？ 
	
	Image, Image.gz 应该是不影响启动的。 确实是不影响启动，只影响启动的时间。

	没办法， 对着 k20 pro 的内核与配置一点点抠。 sm8150 与 sm8250 肯定还是有很多共通的地方。 除了5G的差别。 

techpack 补丁， audio 是放在vendor下还是放在 techpack下？ 

	先放在vendor下，后面再看情况。 看来还是要放在kernel下， audio-kernel 与 techpack/audio 文件夹一样， 但是内容差别很大。 

kbuild 对比

	自动检测出techpack 下的module 逻辑验证， audio-kernel, data-kernel是否被打进去了。 
	
	这样一搞， 内核的问题解决了， 可以正常启动原系统

### Sat 06 Jun 2020 01:51:26 PM CST

FAILED: ninja: 'out/target/product/lmi/obj_arm/SHARED_LIBRARIES/libgps.utils_intermediates/export_includes', needed by 'out/target/product/lmi/obj_arm/SHARED_LIBRARIES/libgnsspps_intermediates/import_includes', missing and no known rule to make it

	去掉device.mk中的 libgnsspps , 可能会影响gps的功能？ 

kernel/xiaomi/sm8250/include/uapi/linux/types.h:10:2: error: "Attempt to use kernel headers from user space, see http://kernelnewbies.org/KernelHeaders" [-Werror,-W#warnings]

	在camerate_motor 中Android.bp 加入 kernel/../include/uapi ，就会出现这个问题， 但是不加吧，msic/drv8846.h 又找不到。 

	在sm8150 的代码里找到了文件， 对应的 patch打上去，可以编译通过， 但不确定功能正常。 
	

**复盘**
	
	内核的问题解决了， 基于atomsand 的代码，再结合raphael 内核的commit 打了几个补丁， 就可以正常启动原系统了。 

	ramdisk 的问题还没有解决， 缺少fstab, 不会启动不了就是因为内核不知道加载这个fstab吧。 
	文档上不是说先在dtsi中挂载vendor, 再从vendor里按fstab.qcom挂载其他的盘么, 怎么会还要从ramdisk 里挂载呢？ 

	dtbo 的问题也是一样， 只能先使用prebuilt 的, 先以启动系统为目标， 后期再修复这些问题。

	recovery 除了分辨率， 其他也运行完好.

	终于看见为何启动不了了， 还是老问题， twrp-wzsx150 的recovery不显示这个信息, 之前的recovery 分辨率太低， 导致显示不全. 
	
	还是data corrupted 错误。 这几周折腾也是折腾的更明折一些，至少内核是更加完善了。 点亮的问题应该就是卡在分区加密上了。 

	关机充电的流程不行了。看来不仅仅是换个boot.img那么简单。

Can nott load android system. Your data maybe corrupt. If you continue to get this message, you may need to perform a factory reset. 	

	然而 factory reset 并不起作用。 
	
	
### Mon 08 Jun 2020 09:53:51 AM CST

内核，启动，迫在眉捷

	内核OK， 关机充电流程， data corrupt 问题
	关机充电问题， 还是要换一个boot.img 才行， dtb 验证是OK的， 那只能说明是 ramdisk的问题。 

	系统启动不了， 大概率还是因为 userdata 分区格式化问题, 系统的格式化不识别，如何查看到原系统的userdata分区是如何格式化的?
	
	从挂载结果上看，能看出什么?

	挂载结果上看， 就是一个f2fs 分区， 还能有什么参数? 

	分析源码要从哪里分析， 先按结果搜索

	看到了一个格式化的方式， 必须使用最新fastboot, 最好使用编译出来的fastboot，是可行的

```sh
	fastboot format:f2fs userdata
```
	不过这样也证明了一个问题，启动不起来，并不是因为userdata格式化的问题

	
### Tue 09 Jun 2020 09:44:16 AM CST

如何启动起来？ 之前不用刷boot.img就可以关机充电， 现在还必须重新刷boot.img， 是什么原因呢？ recovery.img 还是可以启动起来。 

如何启动起来？ k30 的移植并没有多少参考， 研究init.rc， 那里也并没有init.rc 

picasso 的刷机脚本， 少了 backuptool 的功能。 先去掉这个功能看看效果

	目前是修改了makefile 中backup的设置，还未在device.mk, BoardConfig.mk 中找到相关配置。 
	去掉backuptool， 刷机确实没有问题了。
	
ramdisk 中确实带有fstab.qcom, 要如何编进去

	手动复制进去， 倒是也能解决问题， 但是编译出来的rom 刷机还是不能正常启动

	这是vbmeta.img 的原因？ 解锁的bootloader不会再验证vbmeta? 

	如果验证， 那就没法去搞了啊，拿不到私钥， 如何去移植。
	 
	但是红米k20, k20 pro, k30 都可以移植， 说明vbmeta应该不是问题的。 红米k30的刷机包也只有 system, product, 
	现在刷机脚本保持了一致， 为何就是启动不了呢？ 连关机充电的动画也不显示了。 
	
### Wed 10 Jun 2020 09:31:54 AM CST

	内核可确定没有问题, dtb, dtbo 也没有问题。 自编的boot.img 刷入可启动， 说明boot.img 验证也没有问题

	vbmeta.img, vbmeta_system.img 这里的验证， 还需要确定，是否使用有信任根作为私钥。 如果使用公钥， 公钥是否有附带

	system.img, product.img 出问题:

		selinux 应该是没有问题了

		hardware/qcom-caf 的源码无能力修改， 待确定是否正常编译进rom中

		vendor/qcom 编译OK，暂时假定也没有问题，优先级最后
		device/qcom sepolicy 也可以保证编译通过， 暂时假定也没有问题， 优先级放到最后。 

	编译全部的分区， 需要确定vbmeta, vbmeta_system的正确定。
	只编译system, product, 需要确定 hardware/qcom 的驱动库可以正常.  是否需要重签名? picasso 是如何解决这个问题的? 

	不管vbmeta_system是否正常, 都是需要刷机的再看. 

	全编译, 关机充电正常了, 且会卡在那里不动, 而不是直接重启. 

	ramdisk 中 copy fstab.qcom 的问题解决了, 需要在Android.mk 中, 使用 TARGET_RAMDISK_OUT 这个变量

	同时发现 TARGET_COPY_OUT_VENDOR, TARGET_COPY_OUT_PRODUCT这些变量都没有值, 再一查看out下的文件, 也确实都没有copy过去, 
	怪不得vendor包怎么这么小. 
	
TARGET_COPY_OUT_VENDOR, TARGET_COPY_OUT_PRODUCT 的copy 问题

	board_config.mk 解析的时候确实会替换相关的值, 为何没有copy 呢

	PRODUCT_COPY_FILES 是在最后某个地方重新赋值了.

### Thu 11 Jun 2020 10:14:13 AM CST

	kona, vendor, kernel 目前应该是都正确了, 再开不了机, 那就只能是vbmeta的问题了. 

proprietary-files.txt 有那么多与已有的库重复的规则怎么办? 

	编译一次去掉一个无疑是最没有效率的办法.
		先去掉所有PRODUCT_COPY_FILES 的规则(在最后的地方重新赋空即可) 
		编译通过了, 再查找out目录下, system, vendor 中 rc, so, xml 所有已生成文件列表
		再写一个小工具, 根据已生成文件列表, 去掉proprietary-files.txt 中已有那些已存在的行. 

无限重启到recovery

	关机可以正常充电, vendor的库也尽可能的多, boot.img 没有问题, hardware/qcom-caf/kona 的库也编译进来了. 能有什么问题呢? 
	vendor 库不一样? 如何dump 11.0.16的库呢?

	启动系统会重启到recovery, 无限重启到recovery

	vbmeta 在没有私钥的情况下, 如何解决?  这具暂时没有好的思路, 看来 --disable-verification 对vbmeta_system 分区是有作用的
	在vbmeta.img 一致的情况下, vbmeta_system 不一致也可以启动起来.

	先从 vendor库配套上来解决, 增加了vendor库确实不会一直卡在那里了, 说明这个vendor 库还是有影响的. 

编译尝试

	kernel cmdline 增加 selinux, init_fatal_reboot_target

	恢复system/core的修改

	重新dump v11.0.16的库

		恢复原system/core

		补充android_tool/proprietary-files.sh 生成的库, 工作量太多, 暂时放弃, 因为vendor/bin 下有很多即使没有,也重复了编译规则. 
	
	只保留system product 分区, 不动vbmeta, dtbo, vbmeta_system分区
		禁掉vbmeta的验证

	组合打包 stock rom 的 system 与product, 看看刷机后能否正常启动. 
		只使用zip 打包不能成功刷机, 看来还需要研究一下 ota_from_target_files.py
		如果直接刷system.img, product.img呢

system/core是否还有其他补丁? 

	已经有在10.0上移植成功的机型, 按说system/core 出问题的机率也没那么大. 

dump 11.0.16 库

[Extracting proprietary blobs from LineageOS zip files](https://wiki.lineageos.org/extracting_blobs_from_zips.html)

	直接从 stock system 的shell中copy, 这个方法有很多库没有权限
	还可以使用dd, 直接将某个分区做成image, 然后再挂载image

	从recovery 中dump, 应该可以dump system, product, vendor, odm 的库, 但是firmware, dtbo, boot.img 这些该如何dump呢

	lineage 的脚本, 是否可以直接从升级包中dump? 肯定有工具可以dump
	
	从升级包中dump, 也是将xxx.transfer.list 转成 image, 再挂载image

	dump的思想:
		拿到对应分区的image, 然后直接将image挂载, 即可访问文件. 
		升级包中, transfer.list 可以使用 brotli, sdat2img 转成image
		运行的系统, 可以使用 dd 工具, 将分区做成image. 

	dtbo, dt, boot 暂时只能从stock system中使用dd 来dump? 暂时未试验, 不影响移植, 主要还是 system, product, vendor, odm 这四个分区

### Fri 12 Jun 2020 09:38:43 AM CST

手机变砖了?

	清除了 keymaster 分区, 手机就彻底黑屏了? 

twrp 

	ws-150 的 twrp 并不支持fastbootd 刷 system, product

```bash
	fastboot oem device-info 
	fastboot getvar all
```

### Sat 13 Jun 2020 02:48:18 PM CST

**code aurora补丁** 

	突然发现, 远远没有那么简单. 关于system, platform, external 这些包下面都有补丁需要打, 怪不得没有sm8250的支持, 但是 samsang 那些机型又是怎么支持的呢? 与这些有关系吗? 也得看一看代码, 验证一下. 

	这一下子又有很多事情可做了. 整个团队都还没有开始搞 8250 的补丁?  如何确定当前的rom 需要打这个补丁呢? 

	有没有codeauraro 的整体工程或者统一管理的工具? 应该不是每一个库都分开下载的吧? 
	在platform/manifest 目录下, 同样使用 repo 管理, 但是还没发现如何操作. 

	看源码验证, 这个工作量就不是一个人可以搞定的了. 先将我觉得可能有影响的几个库打一下补丁试一试. 
	

### Mon 15 Jun 2020 03:16:23 PM CST

验证直接刷product.img, system.img 是否可以正常启动. 

	官方的system.img, product.img 直接刷入是可以运行的,  自编译的system.img, product.img 刷入任意一个都启动不了. 
	应该不是vbmeta的原因, 因为, 将vbmeta_system分区都擦除了, 原生的系统同样还是可以启动. 

	所以, 最终应该是system.img , product.img 的原因. 

替换system/core 为codeaurora 代码, 看看效果. 
	
	优先使用git 补丁的形式
	真不行, 看看codeaurora库下的移植是否可行

	应该不至于所有的代码都要打补丁, 先见到开机动画才是目的.
	如果替了了system/core, 可以见到开机动画, 那整份代码都不靠谱, 可能工作量更大. 

读源码, blog

### Tue 16 Jun 2020 02:32:13 PM CST

codeaurora/quic/la 源码checkout 下来了. 验证了repo 只是一个多git管理工具, 所以, 不用死板的非得下载 qcom-caf 的官方repo. 

先对着device/qcom/kona 库改动一番

FAILED: ninja: 'out/target/product/lmi/obj/SHARED_LIBRARIES/vendor.qti.hardware.audiohalext@1.0_intermediates/export_includes', needed by 'out/target/product/lmi/obj/SHARED_LIBRARIES/libaudiopolicymanager_intermediates/import_includes', missing and no known rule to make it
14:28:19 ninja failed with: exit status 1

	这个问题, 遇到过很多次, 原来是没有彻底解决. 如何在obj/下生成规则呢? 
	$(call add-prebuilt-files) 这个函数也并不起作用. 

	是由于引进了 kona-audio.mk , 里面有一个 USE_CUSTOM_AUDIO_POLICY := 1 变量, 导致 include 没有找到system/media/audio_utils/include

	出现这样的问题, 还是得在 needed by 的编译规则下去找问题. 

### Wed 17 Jun 2020 10:19:30 AM CST

FAILED: out/soong/.intermediates/system/core/init/libinit/android_arm64_armv8-a_cortex-a75_recovery_static/libinit.a
echo "module libinit missing dependencies: libinit_msm" && false
module libinit missing dependencies: libinit_msm

	出现这个问题是由于将 quic-la 中的 device/qcom/common/init 中的 libinit_msms 移植过来.
	搜索确认是Android.mk 转成 Android.bp 出现的问题, 直接写成 Android.bp 就没有了问题, 具体是哪一块语法转错了, 也没深究. 

libinit_kona

	设置一些属性
	这些也有用于验证吗? 或者是开始没有去加载 prop 文件? 
	好像起了一些作用, 现在卡在无限重启上, 而不是直接就进入bootlaoder 了. 
	去掉了return 的逻辑, 又回到了重启到recovery的场景中, 看来只设置几个property并不起作用. 

	或者说是设置错了吗? 

system/core 

	libinit_kona 还不能解决问题, 就得给system/core打一打补丁了. 
	如何打补丁? 先统一看下diff 的情况. 大致看看哪些可能影响启动
	如何对比 commit 来打补丁? 

	diff 的内容太多了, 以 init, vold 来搜索log, 也不得法. 

	打了一个core的补丁, 就相当于全编译了, 但愿也只需打这个补丁吧. 能启动就行, 后面的事情再说. 

android 10 GSI

	刷入GSI 可以进入开机动画, 但是也进入不了系统 

	GSI 与 官方的image 刷入的时候都会有一行 Invalid sparse file format at header magic

	GSI 的大小是 1.3G, 而自编出来的只有 826M, 差别在哪里? gsapp?

	这也说明了, --disable-verification 是有作用的, 我的系统启动不了是代码问题, 而不是验证问题. 

	这样一来, 问题就大了, 代码的问题, 以哪个代码打包为准呢? 要打哪些包呢? 

	先搜索他人研究的android 10 的启动流程, 大概率是没有想要的, 还是得自己看代码. 
	然而这个代码量, 也是不小的. 

### Thu 18 Jun 2020 09:30:03 AM CST

将system下所有的库都打补丁

	当然要写工具了, 找到第一个(最新)相同commit 的hash值, 再做hash值到最新提交的patch, 然后再打入到现有的代码中. 

	core, chre, extras, libhidl, netd, sepolicy, 只有这几个库可以打补丁, 其他的库都更新到最新了. 
	然而,虽然编译过了, 但是还是启动不起来. 
	
复盘

	无修止的打补丁是没用的, 其他的机型有跑起来的, 说明系统应该是能正常跑起来的. 
	现在
