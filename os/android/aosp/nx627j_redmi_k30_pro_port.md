
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

Q: biso, flex path tool is not allowed to be used

A: export TEMPRORARY_DISABLE_PATH_RESTRICTIONS=true

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

	修改fstab 是一个错误的方向？ 挂载不应该是, bootdevice, 与 platform/soc/ 下的具体芯片型号有何不同？
	
host_init_verifier: device/xiaomi/lmi/rootdir/etc/init.qcom.rc: 577: Unable to find UID for 'vendor_qrtr': getpwnam failed: No such file or directory
host_init_verifier: device/xiaomi/lmi/rootdir/etc/init.qcom.rc: 578: Unable to decode GID for 'vendor_qrtr': getpwnam failed: No such file or directo

	rc 文件缺少group 怎么办, 在 config.fs 里配置
