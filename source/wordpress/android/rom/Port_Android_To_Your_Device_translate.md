---
title: (译)如何移植 CyanogenOS/LineageOS 到您自己的手机
uuid: 246
status: publish
date: 2019-08-02 18:31:29
tags: ROM移植, LineageOS
categories: ROM
description: 此教程有一定的参考性， 相对于一个新手来说, 不够全面，这与每个人的知识积累有关, 但ROM移植的教程本来就少，权且看之。 
---

原文见 [How To Port Cyanogen/LineageOS Android To Your Own Device](https://fat-tire.github.io/porting-intro.html#Prerequisites)

### 1. 移植过程的一些提示

显然您可能会遇到手机或平板电脑或任何其他设备尚未提供CyanogenMod的产品。

你之前已经在计算机上为其他设备构建了CyanogenMod，并且您对此过程感到满意。实际上，您仍然可以获得源代码并准备好处理一个大项目。

看起来这是你发光的机会！

	注意:

	出于本教程的目的，所有目录的路径引用都是相对于源码的根止录（即您执行repo init的位置），并且文件夹名称也相对于那里。
	如果你按照构建指南查看到此篇文章，源代码的根目录在 〜/android/system

### 2. 先决条件

将CyanogenMod移植到新设备可能非常简单或非常困难，具体取决于设备本身，是否目前运行最新版本的Android，当然还有作为开发人员的技能。

如果没有为之前的另一台设备构建过CyanogenMod（和recovery），那么移植将会非常困难。因此，如果你还编译过源码，请试一试[build or two](https://fat-tire.github.io/)。

	提示:

	如果您通过CyanogenMod学习中心找到此页面以外的其他页面，请访问 [Development]() 以获取更多信息。


此外，您应该熟悉CyanogenMod源代码。你应该期望，除了一些罕见的例外，你需要做的几乎所有事情都将在/device/[vendor]/[codename]，/vendor/[vendor]/[codename]和/kernel/[vendor]/[codename]目录。

	提示:

	有关CyanogenMod源文件夹中的位置的更详细概述，请参见[此处]()。事实上，如果你打算做移植，你真的应该读这个。

### 3. 收集手机的信息

在开始移植之前，您需要尽可能多地收集有关设备的信息。转到[维基百科]()并确定产品名称，代码名称，体系结构，内存大小，内部存储大小和平台体系结构。将此信息放在一个文件中以便于检索。尽量了解该设备，包括它可能与其他设备有任何相似之处。

	提示:

	许多设备在架构上与已经在市场上具有现有CM端口的其他设备类似。
	当新设备出现时，看看您是否可以查看它是否与其他设备相同，只是屏幕尺寸不同或内存较多或存在其他一些细微差别。
	如果您发现设备的同一系列的机型(上一款产品和同期产品)，可能已经为您完成了大部分工作！

您需要的大部分信息都可以在线获取，但假设设备已经运行非CyanogenMod版Android系统，您也可以从设备本身获取一些信息。要查看包含此信息的文件，可能需要root设备。但是，有时您可以在线查找库存固件更新包，并可以从.zip存档文件中查看该文件。

#### 3.1 查看当前手机的 /system/build.prop

假设设备已在运行Android系统，则设备上应该有一个文件/system/build.prop，其中可能包含有用的信息，这些信息将在您进行移植时发挥作用。此文件包含Android使用的各种参数和设置的定义。

因此，如果您之前已在计算机上安装了adb，则可以使用以下命令将此文件提取到计算机：

> adb pull /system/build.prop

如果您收到与权限相关的错误，则可能需要root设备才能访问此文件。但是，还有其他方法可以找到此文件。例如，它可以在线包含在任何库存固件“升级”包中。

一旦你有了这个文件......

	* 记下ro.product.manufacturer参数的值。这将是您的供应商名称。 [vendor]是设备制造商/供应商的名称。 CM已经为大多数主要供应商建立了命名约定，例如samsung，htc，lge等。请注意，在这些目录名称中，供应商始终是小写的，不包含空格。
	* 记下ro.product.device参数的值。这将是您的设备代号。 [codename]对应于设备本身的项目代码名称。这几乎与设备的销售名称完全不一致。如果您之前已经构建过CM（并且想更好地再次构建它！），那么您应该熟悉每个设备的代码名称的概念。如供应商名称，代号始终为小写且不包含空格。
	注意：

	有时，设备会在其他参数中识别，例如ro.product.board

保持build.prop文件很方便，后续可随时供参考。

#### 3.2 检查boot.img, recovery.img 

如上所述，在进行移植时，您可能希望使用您知道可用的现有预构建内核，而不是使用源代码重新构建一个内核。您可能需要从设备中提取此内核文件，具体取决于您的设备。内核可以作为单个文件存在（就像在许多OMAP设备上一样），也可以与ramdisk一起包装在引导或恢复分区中。

同样，存储的ramdisk的内容可能非常有用，通常可以提取和审查。可能是设备需要来自存储的ramdisk的特定文件才能正常启动，加载模块等。在大多数情况下，您可以从设备本身查看ramdisk中的文件，但您可能更愿意查看完整目录。

	注意：

	ramdisk是一小组文件和目录，与内核一起加载到内存中。然后内核运行ramdisk中的一个叫init的文件，然后运行一个脚本（init.rc，init。[codename] .rc等）加载Android的其余部分。 ramdisk和内核可以使用名称为mkbootimg，mkimage和其他方法的工具以多种不同方式打包在一起。

您可以使用dd在根植的Android设备上经常提取boot和recovery映像（到名为boot.img和recovery.img的文件）。或者，如果您可以访问供应商提供的更新.zip文件，您通常可以在其中找到这些文件。

#### 3.3 收集一切可使用的源代码

使用Android的任何设备的制造商或供应商至少需要根据请求为所有GPL组件提供源代码，包括（尤其）内核。您肯定需要保存一份内核源代码放在手边。

#### 3.4 决定分区方案

移动设备的主要长期存储部分 - 通常是“emmc”（embeded multimedia card嵌入式多媒体卡） - 非常类似于计算机硬盘驱动器以特定方式识别和隔离不同的数据区域。这些独特的区域称为分区，它们可以存储任何类型的数据。一些分区包含原始数据: 固件，内核，ramdisk等。通常，分区被格式化为使用内核将识别的特定文件系统，以便可以在那里读取和写入单个文件和目录。

在用CyanogenMod替换已装的操作系统之前，确定设备的分区方案很重要。您构建的recovery.img需要此信息才能知道在哪里可以找到各种Android目录。特别是，您想知道将哪些分区分配给/system，/data，/cache 和 /sdcard。

您想知道哪些分区存在，哪些设备，它们的安装方式以及分区的大小。此信息可能稍后传送到/ vendor目录中的BoardConfig.mk文件。

如果幸运的话，可以在recovery.img文件中找到recovery.fstab文件，从而加快了确定哪些内容的过程。此外，ramdisk中的init.[codename].rc文件可能包含该信息。查找安装分区顶部附近的线条。

另外，命令：

> $ cat /proc/partitions

从正在运行的设备也可以帮助您识别分区。另请参阅/proc/emmc，/proc/mounts 或/proc/mtd。您还可以从命令mount获取一些信息（以root身份运行）。

还要检查/cache/recovery.log或/tmp/recovery.log。

最后，如果您有bootloader的源代码（例如许多基于OMAP的设备使用的u-boot），您也可能会在那里找到相关信息。

	注意：

	请注意，在某些极少数情况下，例如HP Touchpad，会使用抽象的虚拟文件系统。

### 4. 创建三个文件目录

现在您已经收集了有关设备的信息，现在可以为您的设备配置生成文件夹，这些文件夹位于以下目录中(相对于源码目录)。

* device/[vendor]/[codename]/  -- 这是特定于您的设备的安装文件所在的位置。device/目录包含99-100％的配置设置和特定设备的其他代码。你需要很好地了解这个目录。如上所述，在启动此设备的文件夹时，最好为现有设备调整目录，该设备在体系结构上与您要移植的设备相似。例如，查找基于相同平台的设备。

* vendor/[vendor]/[codename]/  -- vendor/目录包含从原始设备备份的专有二进制“blob”（或由供应商提供，例如Google Nexus设备和某些TI图形blob）。

* kernel/[vendor]/[codename]/  -- 内核源码放在这里。当您第一次开始移植工作时，您可能希望通过使用预构建的内核（例如库存安装附带的内核）而不是从头构建内核来简化操作。其中的诀窍是从现有系统中提取出内核文件，然后将其与新的ramdisk一起重新打包到您的设备可以使用的表单中。这可能因设备而异，因此查看使用类似架构的类似设备可能会有所帮助。从源代码构建内核对于每个设备都不是绝对必要的，但是在开源的精神下，它是CyanogenMod的首选实践。有关CyanogenMod如何从头开始构建内核源代码的详细讨论，请参见此处。
生成这些目录至少有三种方法：

#### 4.1 方法一: 使用 mkvendor.sh 生成文件结构

	使用build/tools/device/中的mkvendor.sh脚本自动生成目录。
	注意：

	mkvendor脚本仅适用于使用标准boot.img文件的设备，使用标准的Android约定和标头。
	它不适用于偏离此标准的设备（Nook Color，Touchpad等）。

此脚本接受三个参数：vendor，codename和boot.img文件。

用法示例：

> $ ./build/tools/device/mkvendor.sh samsung i9300~ / Desktop / i9300boot.img

在上面的示例中，samsung表示供应商，i9300表示代号，最后一个参数是boot.img文件的路径，该文件使用dd从引导分区中提取或由供应商在更新.zip中提供，如上所述。

上面的命令应该在您的CyanogenMod源代码库结构中创建/device/samsung/i9300/文件夹。在文件夹中，文件为AndroidBoard.mk，AndroidProducts.mk，BoardConfig.mk，cm.mk，device_[codename].mk，kernel（二进制），recovery.fstab等。

这不会构建内核/目录。当您准备构建内核时，您将需要稍后执行此操作。

	注意：

	如果它返回消息“unpackbootimg not found。你的android构建环境是否已设置并且是否已构建主机工具？”
	请确保在设置开发人员环境期间运行以下命令：

	$ make -j4 otatools


#### 4.2 方法二: fork一个同类机型的github仓库

如果您有一个GitHub帐户，您可能希望首先分配另一个类似设备，然后为您的设备重命名。有关如何命名存储库的讨论，请参阅有关设置github的部分。

始终确保您符合您fork的任何存储库的许可。


#### 4.3 方法三: 手动创建所有的目录和文件

您始终可以从空目录开始，然后手动开始创建文件。这是最不推荐的，也许是最繁琐的方法，但它可能是最有启发性的。您可以查看其他设备以获取所需文件的参考。

### 5. 编写定制文件

device/文件夹中有许多文件。我们将首先关注四个文件BoardConfig.mk，device_[codename].mk，cm.mk，recovery.fstab和内核，以便为您的设备恢复工作。

	提示 -- 从恢复开始！

	第一个主要步骤是为您的设备获取工作 recovery.img，以便轻松测试后续update.zips，并在必要时进行备份。因此，接下来的几个步骤将更多地关注恢复工作，而不是让CM本身工作。一旦恢复建立并安全运行，您为此完成的工作将直接应用于CM部件。

让我们检查这些文件：

#### 5.1 BoardConfig.mk

此文件包含有关设备主板，CPU和其他硬件架构的重要架构和构建信息。获得此文件至关重要。

要获得基本的恢复引导，需要在此文件中设置一些参数。

必须在BoardConfig中正确设置以下参数才能编译工作恢复映像：

TARGET_ARCH：这是设备的架构，它通常类似于arm或omap3。

BOARD_KERNEL_CMDLINE：并非所有设备都传递启动参数，但是如果您的设备执行此操作，则必须正确填写以便成功启动。
	您可以在ramdisk.img中找到此信息。 （您可以在此处了解有关配置集成内核源代码的更多信息。）

BOARD_KERNEL_PAGESIZE：库存boot.img的页面大小，必须正确设置才能启动。这个的典型值是2048和4096，这些信息可以从库存内核中提取。

BOARD_BOOTIMAGE_PARTITION_SIZE：分配给内核映像分区的字节数。

BOARD_RECOVERYIMAGE_PARTITION_SIZE：分配给恢复映像分区的字节数。

BOARD_SYSTEMIMAGE_PARTITION_SIZE：分配给Android系统文件系统分区的字节数。

BOARD_USERDATAIMAGE_PARTITION_SIZE：分配给Android数据文件系统分区的字节数。

	注意：

	上述信息可以通过将/proc/partitions或/proc/mtd的大小乘以块大小（通常为1024）来获得。

BOARD_HAS_NO_SELECT_BUTTON :(可选），如果您的设备需要使用其“电源”按钮确认恢复中的选择，请使用此选项。

BOARD_FORCE_RAMDISK_ADDRESS/BOARD_MKBOOTIMG_ARGS :(可选），使用这些来强制ramdisk的特定地址。这通常需要在较大的分区上，
	以便在预期存在的位置正确加载ramdisk。该值可以从库存内核获得。前者从Android 4.2.x开始被弃用，后者现在将在4.2.x及更高版本中使用。

#### 5.2 device_codename.mk

device_codename.mk makefile包含有关要构建的Android软件包以及在何处复制特定文件和软件包或在编译期间设置的特定属性的说明。

此文件可用于在编译时将重要文件复制到ramdisk中。

	* PRODUCT_COPY_FILES：用于在编译期间将文件复制到ramdisk中，该文件位于$ OUT/recovery/root。

	例：

	$（LOCAL_PATH/sbin/offmode_charging：recovery/root/sbin/offmode_charging\

这会将文件offmode_charging二进制文件复制到ramdisk中的sbin文件夹中。

	* PRODUCT_NAME / PRODUCT_DEVICE：用于设置代号的值。这是您使用Lunch加载的设备的名称。

#### 5.3 kernel

这只是预构建的内核映像或您自己构建的用于引导设备的内核。内核的格式可以是zImage或uImage，具体取决于设备体系结构的要求。

#### 5.4 cm.mk

您需要对此文件进行一些更改用来集成 lunch, brunch, 和 breakfast 命令，以便您的设备显示在列表中并正确构建。您还将设置一些变量（请参阅其他设备）以指示应使用的开机动画的大小，无论是平板电脑还是手机等。

其中一些设置不仅用于构建恢复，但您现在也可以设置它们，因为一旦恢复完成并正常工作，此处的设置将非常重要。

再次，看看你的类似设备，以了解这里的设置应该是什么。这很直观。

#### 5.5 recovery.fstab

recovery.fstab为设备中的每个分区定义文件系统装入点，文件系统类型和块设备。它的工作方式与标准Linux操作系统中的/etc/fstab几乎完全相同。

	例：

	/system		ext4	/dev/block/mmcblk0p32
	这将mmcblk0p32的块设备设置为/system 作为文件系统类型 ext4

所有挂载点都应存在于此文件中，并且此信息的正确性至关重要，否则可能会发生非常糟糕的事情，例如 recovery flash 写入错误的位置。

	注意：

	文件系统类型datamedia可用于内部sdcards以及将块设备设置为 /dev/null。

#### 5.6 vendorsetup.sh

在运行setupenv.sh时调用vendorsetup.sh。它用于在lunch menu 中添加非标准 lunch combos。

要将您的设备添加到 lunch menu：

	add_lunch_combo cm_<codename>-userdebug


### 6. 编译一个测试的 recovery image

要仅构建 recovery，请按照常规构建设置lunch，然后输入命令 make recoveryimage

如果发生错误（肯定会发生错误），请查看这些处理构建[错误的提示]()。

	提示:

	如果您有fastboot，则可以尝试将recovery.img安装到recovery分区。
	还有其他方法可以安装recovery，例如使用来自root系统的dd 将其刷新到其分区。

这里不需要说太多，但在继续让CyanogenMod工作之前确保recovery 正常工作。在开始测试实验性Android版本之前，绝对需要100％工作且可靠的recovery。

#### 6.1 如有必要适配 recovery_ui.cpp

您可能会发现虽然 recovery 运行，但通常用于滚动选项的某些硬件按钮（如音量按钮或电源按钮）不起作用。

您可能需要调整GPIO值才能识别按钮。同样，您可能希望包含/排除选项或修改其他UI元素。

为此，您可能希望创建和编辑/device/[vendor]/[codename]/recovery/recovery_ui.cpp。您可以找到此文件的大量示例，构建它的关联recovery/Android.mk文件以及如何使用它。

	提示:

	您可以在内核源代码中找到设备的GPIO值。

### 7. 上传device 文件夹到github, 并使用本地的 localmanifes 通过 repo sync 自动同步

启动设备文件夹后，创建自己的GitHub帐户并将文件夹设置为公共GitHub存储库。这是了解git的绝佳机会，而且您可以与可以与您协作的其他人访问您的仓库。

命名存储库时，请使用android_device_VENDOR_CODENAME格式，其中VENDOR和CODENAME使用新设备的值。因此，假设您的GitHub帐户名称为`fat-fire`，而您的设备代号为`encore`，由Barnes and Noble制造。你应该调用你的存储库android_device_bn_encore。可以通过 https://github.com/fat-tire/android_device_bn_encore 访问它。同样，内核存储库将被称为android_kernel_bn_encore。它可以通过 https://github.com/fat-tire/android_kernel_bn_encore 访问。

最后要做的是为其他人创建一个本地清单，用于自动下载并随时了解您的更改。这是一个使用上面的场景的例子：

```
<？xml version =“1.0”encoding =“UTF-8”？>
<manifest>
  <project name =“fat-tire / android_device_bn_encore”path =“device / bn / encore”remote =“github”revision =“cm-10.1”/>
  <project name =“fat-tire / android_kernel_bn_encore”path =“kernel / bn / encore”remote =“github”revision =“cm-10.1”/>
</manifest>
```

	注意：

	revision属性是可选的。如果省略，则repo sync将使用默认清单中<default ... /> tag 指定的修订。

一旦您验证了本地清单文件的工作流程，您就可以将其分享给其他人，然后他们可以验证您的工作成果。此时，您可以继续将更改推送到GitHub，甚至可以给其他用户开通访问权限，以便你们可以一起移植此设备。

	提示 -- 使用其他存储库

	如果您发现由于某种原因需要替换或补充CyanogenMod提供的其他存储库，则可以使用本地清单添加其他存储库。一旦你完成所有工作，你就可以使用Gerrit将这些存储库中找到的东西提交回上游CyanogenMod。

### 8. 添加 blobs 到 vendor 文件夹

一旦你有一个可正常工作的recovery，现在是时候让CyanogenMod建立和工作了。

首先要做的是将所有 proprietary, 二进制blob, 放入vendor/ 文件夹，以及将在最终版本中包含它们的.mk文件。

这需要三个步骤：

	1. 创建extract-files.sh和setup-makefiles.sh脚本，使用adb从设备中提取这些blob文件，并将它们放在正确的/vendor/目录中。其他设备有很多可用的示例。
	2. 创建一个.mk Makefile，在构建过程中将这些文件复制到$OUT文件夹，并将它们放在正确的位置。再次，使用其他设备作为此Makefile应该是什么样的指南。示例文件名可能是BoardConfigVendor.mk
	3. 确保您刚刚创建的Makefile包含在主BoardConfig.mk中，通过命令如-include vendor/[vendor]/[codename]/BoardConfigVendor.mk。同样，现有设备可以说明这是如何完成的。


### 9. 重新修改校正device/ 目录

由于您的recovery 可正常工作，请返回并开始修改devices/ 文件夹中的文件。与往常一样，使用其他类似的设备作为参考。

您现在可以轻松地进行备份和测试构建。 因此，开始调整设备文件夹本身，看看你是否可以启动它... 从那里开始就是一个接一个构建和支持各种部件和外围设备.

### 10. 从制造厂/第三方厂商 获取帮助

许多制造设备使用的底层平台的OEM（原始设备制造商）经常提供维基，文档和示例代码，可以帮助您完成移植。 您会发现一些公司对开发社区比其他公司更友好。 以下是一些更常见的OEM和供应商，以及可能有用的网站和存储库。

（此列表不完整。请帮忙添加）


| OEM | Platform | Repositories/Resources |
|--|--|--|
|Google	|various	|Google's Git Repository , Nexus binary blobs|
|HTC	|various	|Dev Center|
|HP	|various	|HP Open Source|
|Lenovo	|various	|Lenovo Smartphones (Search your device)|
|LG	|various	|LG Open Source Code Distribution|
|Motorola	|various	|Motorola Open Source Center|
|Nvidia	|Tegra	|Tegra's GitWeb|
|Qualcomm	|MSM/QSD	|Code Aurora Forum|
|Samsung	|various	|Samsung Open Source Release Center|
|Texas Instruments	|OMAP	|www.omapzoom.com , Omappedia|

有时如果有你问题， 可以通过email或者论坛向开发者寻求帮助

### 11. 添加 xml 叠加层

它很可能出现在你的device_[codename].mk文件中，有一行看起来像这样：

	DEVICE_PACKAGE_OVERLAYS：= \
	    device/[vendor]/[codename]/overlay

这样做是设置 overlay/ 文件夹，以允许您覆盖Android框架或应用程序使用的任何XML文件，仅适用于此设备。为此，请创建一个目录结构，该结构相对于源码根目录，映射于xml文件的一个镜像。然后替换要叠加的文件。

示例：假设您要覆盖某些标准的Android设置。查看frameworks/base/core/res/res/values/config.xml中的文件。然后将其复制到设备/[vendor]/[codename]/overlay/frameworks/base/core/res/res/values/config.xml。现在你的版本将被用来代替另一个版本。您只需要包含您希望覆盖的设置 -- 而不是所有设置，这样您就可以将文件削减为默认情况下更改的那些设置。

您可以覆盖任何XML文件，影响布局，设置，首选项，翻译等。

### 12. 编译 kernel 源码及内核模块

如果您以前使用过预构建的内核，那么您可能希望从头开始构建内核。

请参阅有关如何更改BoardConfig.mk文件的指令来构建CyanogenMod [build the kernel and any required kernel modules automatically]()。

### 13. 最后

不可能只用一个维基页面告诉您从头到尾执行移植所需的所有信息。但是，希望您现在了解如何去的配置以及您需要采取的步骤。你总是在[论坛]()或[IRC]()上寻求帮助。拥有相同设备的其他人也可以参与其中。

希望你会发现这个过程有益而且具有教育意义。它也会让你获得一些街头信誉。

当你完成所有的工作，你的移植ROM比现有的系统更好...当它稳定，闪闪发光，奇妙而美妙......

您可能希望在上游贡献您的工作。以下是[如何做到这一点]()的说明。

祝好运！

### 14. 参考文献

[Android-Porting](https://groups.google.com/forum/?fromgroups#!forum/android-porting)  -- 关于此主题的官方Google群组
[General CyanogenMod Porting Discussion](https://forum.cyanogenmod.org/topic/15492-general-cyanogenmod-porting-discussion/) -- 关于移植的论坛帖子
