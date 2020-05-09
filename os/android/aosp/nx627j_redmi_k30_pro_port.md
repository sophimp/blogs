
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


## Sat 09 May 2020 04:20:15 PM CST

**KeyErro: "partition size"**

找到对应的image ，补全相应的 image_partition_size, 如 board_bootimage_partition_size := 

**动态分区**

	android 10.0 的动态分区特性， 搞得recovery 刷不了机？

	redmi k30 pro 上， system分区没有了， boot.img 刷进去启动不了， fastboot -w 将userdata 清了之后， 连data 分区也找不到了， 挂载是按动态分区来的。

	先刷回官方的boot.img， 可以启动， 得先摸清楚k30 pro 的各个挂载点对应的物理分区在哪里, 不然格式化了， 不知道如何再分区了。 

redmi k30 pro 分区

/dev/block/sda18         11.5M    112.0K     10.9M   1% /metadata
/dev/block/dm-0           2.8G      2.8G         0 100% /system_root
/dev/block/dm-0           2.8G      2.8G         0 100% /system
/dev/block/dm-2           1.7G      1.7G         0 100% /vendor
/dev/block/dm-1         434.3M    433.0M         0 100% /product
/dev/block/dm-3         118.0M    872.0K    114.6M   1% /odm
/dev/block/sde51        447.9M    202.0M    245.8M  45% /firmware
/dev/block/sda22         58.0M      2.9M     53.2M   5% /persist
/dev/block/sde35         64.0M    352.0K     63.6M   1% /bt_firmware
/dev/block/sde49         59.0M     28.2M     29.6M  49% /dsp
/dev/block/sda31        975.9M    763.0M    186.6M  80% /cust
/dev/block/sda13          5.0M    160.0K      4.8M   3% /logfs
/dev/block/sde43         64.0M     32.0K     63.9M   0% /spunvm

