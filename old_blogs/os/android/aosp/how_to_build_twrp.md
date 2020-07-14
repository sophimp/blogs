
## `<译>` 如何编译 TWRP recovery

[原文: How to compile TWRP touch recovery](https://forum.xda-developers.com/showthread.php?t=1943625)

所有 TWRP 3.x 源码都是公开的。您可以自行编译它。本指南不会是一步一步、逐字逐句的的指南。如果您不熟悉基本的 Linux 命令和/或 AOSP 项目的构建，则可能操作不了此教程. 

您当前可以使用 Omni 5.1、Omni 6.0、Omni 7.1、Omni 8.1、CM 12.1、CM 13.0、CM 14.1 或 CM 15.1 源代码。建议使用 Omni 7.1。您可以在 CM 中构建，但可能会遇到一些小问题。如果您不知道如何修复文件问题，则应选择使用 Omni。

如果使用 CM，则需要将 TWRP 放在 CM/bootable/recovery-twrp 文件夹中，并在BoardConfig.mk文件中设置`RECOVERY_VARIANT := twrp`。TWRP 源代码可在此处找到：

https://github.com/omnirom/android_bootable_recovery 

选择最新的可用分支。Omni 不需要此步骤，因为 Omni 默认已包含 TWRP 源，但是，如果您使用的是旧版本的 Omni，则可能需要从最新分支中提取（最新的分支将在较旧的生成树中成功编译）

如果您只对构建 TWRP 感兴趣，则可能需要尝试使用较小的树。您可以尝试使用此清单。它在大多数情况下应该工作，但在某些情况下，您可能需要更多的存储库在您的树比此清单提供：
https://github.com/minimal-manifest-twrp

编译前
------

注意：如果添加或更改任何标志，则需要在重新编译之前进行清理或进行破坏，否则不会生效标志更改。

现在，您已经拥有了源代码，您需要为设备设置或更改一些生成标志。查找设备BoardConfig.mk。BoardConfig.mk位于您的device/vendor/device_comobo（例如device/lge/hammerhead/BoardConfig.mk）。

您的主板配置需要包括体系结构和平台设置。通常，如果您使用的是其他人创建的设备配置，则这些配置已包含在内，但如果您创建自己的配置，则可能需要添加它们。没有它们，恢复可能会在启动过程中出现故障，您只会在屏幕上一遍又一遍地看到 Teamwin 标语闪烁。

我们通常将所有标志放在BoardConfig.mk的底部，标题是#twrp对于您需要告诉 TWRP 使用什么主题的所有设备。此 TW_THEME 标志将替换默认的`DEVICE_RESOLUTION`标志。TWRP 现在使用缩放来拉伸任何主题以适合屏幕分辨率。目前有 5 个设置：纵向_hdpi、纵向_mdpi、横向_hdpi、横向_mdpi 和 watch_mdpi。对于纵向，您可能应该为 720x1280 及更高分辨率的分辨率选择 hdpi 主题。对于横向设备，请使用 1280x720 或更高的 hdpi 主题。
`TW_THEME := portrait_hdpi`

请注意，主题不支持旋转 90 度，并且当前没有旋转主题的选项。如果您发现触摸屏相对于屏幕旋转，则可以使用一些标志（本指南稍后将讨论）来旋转触摸输入以匹配屏幕的方向。

除了分辨率之外，我们还具有以下构建标志：

`RECOVERY_SDCARD_ON_DATA := true` -- 这允许设备上 /data/media 用来存储（大多数蜂窝和最初随 ICS 附带的设备，如 Galaxy Nexus），但是，这些类型的设备已经不需要此标志。如果您未定义此标志，并且在fstab 文件中不包含对 /sdcard、/internal_sd、/internal_sdcard 或 /emmc 的任何引用，则我们将自动假定设备正在使用模拟存储。

`BOARD_HAS_NO_REAL_SDCARD := true` -- 禁用 Sdcard 分区等操作，如果 TWRP 不适合您的恢复设置，可能会为您节省一些空间

`TW_NO_BATT_RECENT := true` -- 禁用未正确支持电池的设备的电池百分比显示

`TW_CUSTOM_POWER_BUTTON ：= 107 `-- 自定义电源按钮映射锁屏操作

`TW_NO_REBOOT_BOOTLOADER := true `-- 移除菜单中的 重启到bootloader 选项
`TW_NO_REBOOT_RECOVERY := true `-- 移除菜单中的 重启到 recovery 选项
`RECOVERY_TOUCHSCREEN_SWAP_XY := true `-- 交换xy轴的触摸映射
`RECOVERY_TOUCHSCREEN_FLIP_Y := true `-- 翻转y轴 触摸坐标
`RECOVERY_TOUCHSCREEN_FLIP_X := true `-- 翻转x轴 触摸坐标

`TWRP_EVENT_LOGGING := true` -- 启用触摸事件日志记录以帮助调试触摸屏问题（不要将其留待发布 - 它会非常快速地填满您的日志文件）
`BOARD_HAS_FLIPPED_SCREEN := true` -- 翻转屏幕, 用到倒置安装的屏幕

通过扫描recovery-twrp源码中的Android.mk文件，还可以找到其他构建标志。大多数其他构建标志不经常使用，因此我不会在这里记录它们。

*recovery.fstab*
---------------

TWRP 2.5 及更高版本支持一些新的recovery.fstab 功能，可用于扩展 TWRP 的备份/恢复功能。您不必添加 fstab 标志，因为大多数分区都是自动处理的。

请注意，TWRP 仅在版本 3.2.0 和更高版本中支持 v2 fstab。您仍然需要为较旧的 TWRP 使用 fstab 的"旧"格式（该格式的示例如下），甚至 TWRP 3.2.0 也仍然支持 v1 格式以及 v2 格式。为了最大化 TWRP 与生成树的兼容性，您可以创建 twrp.fstab，并使用 PRODUCT_COPY_FILES 将文件放在 /etc/twrp.fstab 中当 TWRP 启动时，如果它在 ramdisk 中找到一个 twrp.fstab，它将重命名 /etc/fstab 到 /etc/恢复.fstab.bak，然后重命名 /etc/twrp.fstab 到 /etc/恢复.fstab.实际上，这将"替换"设备文件随 TWRP fstab 一起提供 fstab 2 文件，允许您在设备文件和其他恢复中保持兼容性。

代码：
``` fstab
PRODUCT_COPY_FILES += device/lge/hammerhead/twrp.fstab:recovery/root/etc/twrp.fstab
```

TWRP 中的 fstab 可以包含 fstab 中列出的每个分区的一些"标志"。

下面是一个用于银河 S4 的 TWRP fstab 示例，我们将用于参考：

``` fstab 
/boot       emmc        /dev/block/platform/msm_sdcc.1/by-name/boot
/system     ext4        /dev/block/platform/msm_sdcc.1/by-name/system
/data       ext4        /dev/block/platform/msm_sdcc.1/by-name/userdata length=-16384
/cache      ext4        /dev/block/platform/msm_sdcc.1/by-name/cache
/recovery   emmc        /dev/block/platform/msm_sdcc.1/by-name/recovery
/efs        ext4        /dev/block/platform/msm_sdcc.1/by-name/efs                            flags=display="EFS";backup=1
/external_sd     vfat       /dev/block/mmcblk1p1    /dev/block/mmcblk1   flags=display="Micro SDcard";storage;wipeingui;removable
/usb-otg         vfat       /dev/block/sda1         /dev/block/sda       flags=display="USB-OTG";storage;wipeingui;removable
/preload    ext4        /dev/block/platform/msm_sdcc.1/by-name/hidden                            flags=display="Preload";wipeingui;backup=1
/modem      ext4        /dev/block/platform/msm_sdcc.1/by-name/apnhlos
/mdm		emmc		/dev/block/platform/msm_sdcc.1/by-name/mdm
``` 

标志将添加到由空格分隔的 fstab 中的分区列表的末尾（空格或制表正常）。标志仅影响该分区，而不影响任何其他分区。标志用分号分隔。如果显示名称要具有空格，则必须用引号包围显示名称。

``` fstab 
/external_sd  vfat  /dev/block/mmcblk1p1  flags=display="Micro SDcard";storage;wipeingui;removable
```
此分区的标志为它提供了一个显示名称的"微型 SDcard"，该名称会向用户显示。擦除使此分区可用于在高级擦除菜单中擦除。removable标志指示有时此分区可能不存在，以防止在启动期间显示安装错误。下面是标志的完整列表：

	`removable` -- 指示分区可能不存在，以防止在引导过程中显示安装错误
	`storage` -- 指示分区可用作存储，使分区可用作备份、还原、zip 安装等存储。
	`settingsstorage` -- 只应将一个分区设置为设置存储，此分区用作存储 TWRP 设置文件的位置
	`canbewiped` -- 指示分区可以由后端系统擦除，但可能不会在 GUI 中列出供用户擦除
	`userrmrf` -- 覆盖正常格式类型的擦除，并且仅允许使用 rm -rf 命令擦除分区
	`backup=`  -- 必须由等于符号继承，因此 backup=1 或 backup=0， 1 指示分区可以列在备份/还原列表中，而 0 可确保此分区不会显示在备份列表中。
	`wipeingui` - 使分区显示在 GUI 中，以允许用户选择它进行擦除的高级擦除菜单
	`wipeduringfactoryreset` -- 分区将在恢复出厂设置期间擦除

	`ignoreblkid` -- blkid用于确定 TWRP 正在使用的文件系统，此标志将导致 TWRP 跳过/忽略 blkid 的结果，并仅使用 fstab 中指定的文件系统
	`retainlayoutversion` -- 使 TWRP 在 /data 中保留 .layoutversion 文件，如索尼 Xperia S 等设备使用 /data/media，但仍有单独的 /sdcard 分区
	`symlink=` -- 导致 TWRP 在安装分区时运行额外的装载命令，通常与 /data/media 一起使用以创建 /sdcard
	`display=` -- 为在 GUI 中列出分区设置显示名称
	`storagename` -- 为分区设置存储名称，以便列在 GUI 存储列表中
	`backupname=` -- 为分区设置备份名称，以便列在 GUI 备份/还原列表中
	`length=` - 通常用于在 /data 分区末尾保留空白空间，以在 Android 的完整设备加密存在时存储解密密钥，不设置此项可能会导致无法加密设备
	`canencryptbackup=` -- 1 或 0 启用/禁用，如果用户选择加密（仅适用于 tar 备份，而不是映像），则 TWRP 会加密此分区的备份
	`userdataencryptbackup=` -- 1 或 0 启用/禁用，使 TWRP 仅加密此分区的用户数据部分，某些子数据库（如 /data/app）不会加密以节省时间
	`subpartitionof=` - 必须由等于符号和分区的路径继承，它是子分区。子分区被视为主分区的"部分"，因此，例如，TWRP 会自动使 /data 数据成为 /data 的子分区。这意味着 /data 数据不会显示在 GUI 列表中，但 /datadata 将在对 /data 执行这些操作时擦除、备份、还原、装载和卸载。使用子分区的一个很好的例子是 LG Optimus G 上的 3x efs 分区：

``` 
/efs1         emmc   /dev/block/mmcblk0p12 flags=backup=1;display=EFS
/efs2         emmc   /dev/block/mmcblk0p13 flags=backup=1;subpartitionof=/efs1
/efs3         emmc   /dev/block/mmcblk0p14 flags=backup=1;subpartitionof=/efs1
``` 
这将将所有 3 个分区合并为 TWRP GUI 中的单个"EFS"条目，允许在单个条目下一起备份和还原所有三个分区。

自 TWRP 3.2.0 起，TWRP 现在支持 版本 2 fstab，就像多年来在 Android 设备中 fstab 一样。是的，我知道我们采用这个非常缓慢，但我也看到了v2没有重大的优势，v2 fstab正在使用常规的Android以及recoveryy，我不希望因为设置TWRP 标志而出现完整的ROM构建崩溃或做其他奇怪的事情。版本 2 fstab 支持是自动的。您无需添加任何生成标志。常规版本 1 fstab 格式仍然有效，并且可以在相同的 fstab 中使用 v1 和 v2 类型。TWRP 3.2.0 还支持通过 v1 格式的星号作为通配符，这对于具有多个分区的 USB OTG 和微型 SD 卡非常有用。另请注意，v2 fstab 格式尚未经过广泛测试，因此开发人员应在发布给用户之前测试其 v2 fstabs（无论如何，您都应该始终进行测试！)

这是一行带有用于 USB OTG 驱动器的通配符 的 v1 fstab 配置。当用户插入驱动器时，所有分区都应显示在可用存储设备列表中：

``` 
/usb-otg  vfat   /dev/block/sda*  flags=removable;storage;display=USB-OTG
``` 
此行是为同一设备直接配置 v2 fstab ，并且应该可以工作。在这种情况下，内核将通知我们，新设备已通过 uevents 添加或删除

```
/devices/soc.0/f9200000.ssusb/f9200000.dwc3/xhci-hcd.0.auto/usb*    auto      auto    defaults      voldmanaged=usb:auto
```
除了 v2 fstab 之外，您还可以include 复用 v1 fstab 格式的 /etc/twrp.flags 。twrp.flags 文件可用于使用 TWRP 标志补充 v2 fstab、特别是v2 fstab 中未包含分区，以及重写 v2 fstab 中的设置。例如，我有一个华为设备，其存储 v2 fstab为 /etc/recovery.fstab。

```fstab
# Android fstab file.
#<src>                                                  <mnt_point>         <type>    <mnt_flags and options>                       <fs_mgr_flags>
# The filesystem that contains the filesystem checker binary (typically /system) cannot
# specify MF_CHECK, and must come before any filesystems that do specify MF_CHECK
/dev/block/bootdevice/by-name/system    /system    ext4    ro,barrier=1    wait,verify
/dev/block/bootdevice/by-name/cust    /cust    ext4    ro,barrier=1    wait,verify
/devices/hi_mci.1/mmc_host/mmc1/*                       auto                auto      defaults                                      voldmanaged=sdcard:auto,noemulatedsd
/devices/hisi-usb-otg/usb1/*                            auto                auto      defaults                                      voldmanaged=usbotg:auto
/dev/block/bootdevice/by-name/userdata         /data                f2fs     nosuid,nodev,noatime,discard,inline_data,inline_xattr wait,forceencrypt=footer,check
/dev/block/bootdevice/by-name/cache         /cache                ext4      rw,nosuid,nodev,noatime,data=ordered wait,check
/dev/block/bootdevice/by-name/splash2         /splash2                ext4      rw,nosuid,nodev,noatime,data=ordered,context=u:object_r:splash2_data_file:s0 wait,check
/dev/block/bootdevice/by-name/secure_storage         /sec_storage                ext4      rw,nosuid,nodev,noatime,discard,auto_da_alloc,mblk_io_submit,data=journal,context=u:object_r:teecd_data_file:s0 wait,check
```
此外我还include 了 /etc/twrp.flags

```fstab
/boot         emmc       /dev/block/platform/hi_mci.0/by-name/boot
/recovery     emmc       /dev/block/platform/hi_mci.0/by-name/recovery   flags=backup=1
/cust         ext4       /dev/block/platform/hi_mci.0/by-name/cust       flags=display="Cust";backup=1
/misc         emmc       /dev/block/platform/hi_mci.0/by-name/misc
/oeminfo      emmc       /dev/block/platform/hi_mci.0/by-name/oeminfo    flags=display="OEMinfo";backup=1
/data         f2fs       /dev/block/dm-0
/system_image emmc       /dev/block/platform/hi_mci.0/by-name/system
```

twrp.flags 中的前 2 行添加了 v2 fstab 中根本不存在的引导和恢复分区。
在 twrp.flags 文件中添加 /cust 行是为了告诉 TWRP 允许用户备份 cust 分区，并给它一个稍微更好的显示名称。
/misc 分区也只存在于 twrp.flags 文件中。
与 /cust 分区类似， /oeminfo 分区位于 twrp.flags 文件中，用于告诉 TWRP 允许用户备份它并给出显示名称。
需要 /data 是因为这款华为设备，像许多华为设备一样，使用一些特殊的华为二进制文件加密的，并使用用户无法更改的某种默认密码加密。我们使用华为二进制文件在recovery中自动解密设备。此处的 /data 行告诉 TWRP 使用 `/dev/block/dm-0`，而不是 `/dev/block/bootdevice/by-name/userdata`，这是正确挂载所需的，等等。最后，我们有 /system_image 行，以便 TWRP 将添加用于备份和恢复的系统映像选项。

随着我们添加更多新设备，我们将向 https://github.com/TeamWin/ 添加更多示例设备树，这将有助于您找到更多使用此新 fstab 支持的方法。请注意，此时使用 v2 fstab 格式是完全可选的，因此，如果这是更舒适的，或者如果您在 v2 格式支持方面遇到问题，请随时继续使用 v1。

如果您有任何疑问，请随时在 Freenode 上#twrp。如果你在这里发贴，我可能看不到它一段时间，因为我有很多线程在那里，没有办法，我跟踪他们所有。如果您成功地将TWRP移植到新设备，请告诉我们！我们喜欢听到成功的故事！

如果您有要提交的代码更改，请通过 [Omni Gerrit](https://gerrit.omnirom.org/) 服务器提交。[指南在这里](http://teamw.in/twrp2-gerrit)。

一旦你得到Omni或CM同步和你的TWRP标志设置，你应该做一个源./build/envsetup.sh 我们通常lunch device 是有疑问的, 所以像`lunch omni_hammerhead-eng`这样的格式配置吧.

在lunch device 后，这是大多数设备使用的命令：

```sh
make clean && make -j# recoveryimage
```
将 `#` 替换成cpu 核心数加一, 所以, 如果你是双核的, 就是 -j3, 四核的就是 -j5 等等. 
如果你移植的是三星设备, 你将会做 

``` sh
make -j# bootimage
```
大多数三星设备的recovery 使用包括ramdisk 的boot.img 替代其他设备上的分开的recovery分区

旧教程地址: http://forum.xda-developers.com/show...postcount=1471

## 编译出recovery 支持adb

[recovery 下支持Adb](https://www.jianshu.com/p/a0bdcce0a5e1)

[adb 下支持shell](https://blog.csdn.net/c_hnie/article/details/80756568)

[USB端口对adb, download, mass_message的支持](https://blog.cofface.com/archives/2647.html)


## 编译中出的问题

1. frameworks 下 undefined module "libskia" ...

export ALLOW_MISSING_DEPENDENCIES=true


2. adb, mass_storage 不能识别问题

[参考caffee解决方案](https://blog.cofface.com/archives/2647.html)

在 init.qcom.usb.rc 中添加一个属性

on property:sys.usb.config=diag,serial_smd,rmnet_bam,mass_storage,adb
    stop adbd
    write /sys/class/android_usb/android0/enable 0
    write /sys/class/android_usb/android0/idVendor 19d2
    write /sys/class/android_usb/android0/idProduct ffc1
    write /sys/class/android_usb/android0/f_diag/clients diag
    write /sys/class/android_usb/android0/f_serial/transports smd
    write /sys/class/android_usb/android0/f_rmnet/transports smd,bam
    write /sys/class/android_usb/android0/functions diag,serial,rmnet,mass_storage,adb
    write /sys/class/android_usb/android0/enable 1
    start adbd
    setprop sys.usb.state ${sys.usb.config}

在 system.prop 中添加

```
#Set composition for USB device                
#persist.sys.usb.config=diag,serial_smd,rmnet_bam,adb
persist.sys.usb.config=diag,serial_smd,rmnet_bam,mass_storage,adb
#For frameworks compatible process between BCM & NXP — xiaoshengtao
ro.config.nfc_chip_model=BCM                   
#Set read only default composition for USB     
#ro.sys.usb.default.config=diag,serial_smd,rmnet_bam,adb
ro.sys.usb.default.config=diag,serial_smd,rmnet_bam,mass_storage,adb
```

当编译下载后发现usb，adb等都不支持了，只有一个充电。后来听说，MSM8916的
USB的端点数不够引起的，无法在现有的端点上面支持过多的设备。据说其中的serial_tty
就用到了6路的端点数。
 
总结USB的配置必须要和属性事件完全一致，包括其中的功能的顺序。
另外idProduct对固件download的影响是通过电脑端的驱动完成的。
最后USB的功能不能超过芯片能支持的端点数。

