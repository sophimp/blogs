
## mokee 系统研究

1. 前情回顾

公司任务, 需要研究系统级诱发, aosp 的编译已经没有问题了,  在ubuntu环境下, 按照步骤, 基本上没有意外问题. 

编译mokee 系统就遇到了不少问题:
    - 首先同步源代码问题, 稀里糊涂过了, 这里对default.xml 存在疑问, 换代理的方式为何与aosp 的不太一样呢? 对repo 管理存在疑问, 切换分支, 查看分支, 都是按照指令来做, 但是不清楚还有没有其他的方法呢? 
    - 其次, 切换分支后, lunch 里的选择找不到 对应硬件驱动的 *.mk文件, 目前卡在这里
    - 选择已有的分支呢? 编译也会通不过, 编译出错的问题, 仍未解决. 
    - 没有的机型如何去定制驱动呢? nubia z17minis, one plus 6t 官方都没有支持, 靠我自己可行吗?

2. 接下来的方向

先选择谷歌官方的, 看是否可以编译过, 

然后再去查找驱动哪里找? 为何有选项而下载不到驱动呢? 是对非开发人员作了限制吗? 

没有的机型如何定适配制驱动呢? 主要就是双卡相关的功能.

直接将官方的驱动分解出来, 这也得要一定的时间, 首先要搞清楚整个工程架构, 至少与研究相关的模块. 那么多文件.  工作量是不小的.

手写驱动: 短时间内是难以搞定的了.

## 任务列表
1. 选择谷歌官方的, 看是否可以编译过, 

    切换到mko-mr1 分支, nexus 5x 可以编译过.

    中间切换过几次mko-mr1-dev, mkp 的版本, lunch过几次不同的平台, 编译废掉了, 然后删除掉所有的文件, 重新同步, 可正常通过

        repo init -u https://github.com/Mokee/android -b mko-mr1
        repo sync
        lunch bullhead
        mka bacon

2. 对比工程文件夹的异同

    具体比较移致 [Mokee与aosp工程分件夹的分析](mokee_aosp_directory_analysis.md)

    基本上了解了各个文件夹的作用, 但是对于定制适配 mokee 还是无从下手.

    `source build/envsetup.sh`
    lunch n595j-userdebug, 在 `build/core/product_config.mk` :238 行报错

    看来只能从 `envsetup.sh` 入手看看做了哪些事, lunch 又是从哪里来的 
    搞明白 `Android.mk` 语法, 看看238行为何报错
    搞明白 Makefile 语法, 看看整个工程从哪里开始编译, 哪里是入口

3. 下载了pixel3 sargo 的驱动

    `extract-google_devices-sargo.sh` 和 `extract-qcom-sargo.sh`

    [谷歌内核驱动脚本做了什么](extract_google_devices_qcom_sargo_analysis.md)

    `source build/envsetup.sh`

    [envsetup 又做了什么](envsetup_analysis.md)

    evesetup 主要是提供一些临时命令, 用于编译, 查看源码, 配置环境, 快速跳转
    所以接下来makefile 才是关键, shell 的学习, 暂时先放一放, 能看明白代码就行, 忘掉的语法再补上

- Android.mk 语法, Makefile语法

    就以`product_config.sh` 和 aosp 的 make文件为例, 开始学习 makefile

- 适配一款机型要做的工作

    参考资料:

    [shim和blob](https://toby.moe/android-shim/)
    [mokee适配一款机型我们做了什么](https://bbs.mokeedev.com/t/topic/1073/33)
    [How to port CyanogenMode/LineageOS android to your own device](https://fat-tire.github.io/porting-intro.html)
    [添加一款新的机型 官方教程](https://source.android.google.cn/setup/develop/new-device)
    [编译一款新机型记录](https://kotlintc.com/articles/4343?fr=sidebar)
    [为何msm8974不能运行Nougat](https://www.xda-developers.com/in-depth-capitulation-of-why-msm8974-devices-are-excluded-from-nougat/)
    [如何在没有源码的情况下让硬件工作](https://www.xda-developers.com/cameras-custom-roms-developers-make-hardware-work-without-source-code/)

    看出了点头绪, 在mokee上说的, 先就是下载内核, 然后就是编写device库, 然后编译, 烧写手机, 看日志修改

    根据编译流程的命令, 分析完envsetup, 看完lunch 函数, lunch 就是根据vendorsetup来添加combo, 然后准备好环境, 那么就进行下一步, mka bacon, 这一步调用的是 m() 函数, 而m()函数的入口就是 build/soong/`soong_ui.bash`
    soong 才是整个系统的编译框架, 因此浏览了一下整个build下的文件, kali, blueprint, soong, go, ninja, `roomservice.py`
    roomservice算是一个突破, 突然想起来了选择 combo 的时候,提示错误里就有roomservice 的错误, 这里<project>是github的仓库, 所以在Mokee的仓库下搜索一下, 发现是有msm8976的库, kernel, vendor, devices 都包括, 而且明确支持 z17 mini, z17 lite, z17minis的, 这样一来, 甜酸z17minis的难度一下子就小了很多, 接下来是如何指令下载呢? 要分析 `buildconfig.mk` 238 行了

    下载一个已有的, 先根据combo 名称来查找Mokee库下载devices库, 这一步如果手动下载呢? 然后解析devices库的依赖, 再下载kernel库, packages-resource库, vendor库

    `入口还是从lunch函数开始, combo添加不是必须的, 可以直接lunch combo, 然后会从本地device库中查找, 解析.dependencies 添加到./repo/local_manifests/roomservice.xml` 中, 然后自行下载

    所以, 下一步是要读懂, lunch函数是怎么解析本地的文件夹查找的.

    - 当一个aosp新版本发布时, 背后都发生了什么? 

        upstream update: 谷歌内部的更新, 只支持有限的机型, 接着OEM 设备商将开始一系列更新, 制造设备, 向芯片商购买SoC
        Chipset Makeer: BSP 包括驱动和HALs, 是保密的, BSP 包括必须的代码让OEMs为自己的设备编译Android和必要的驱动, OEM根据芯片商的能力, 再加上谷歌提供的接口, 就可以应用新的能力, 一旦更新后, 虽然是同一样接口, 但是控制的能力不同, 但是旧的芯片没有这个能力, 所以就出问题了. 

    `cm.mk, device_code.mk 都要手动编写吗? extract_files.sh, setup-makefiles.sh `这几个也是关键, 
    联系lunch 与机型的配置是 mk_product_device变量?
    recovery.fstab, 与/etc/fstab 的作用是一样的, 用于配置设备挂载的
    GPIO, 想得那么清晰的方法, 到自己实施又是另一番景象, 节点完全可以抽象成一个关键词, 然后再概括这个关键词

- repo 工具

    repo command options
    repo help
    repo help command

    repo 不仅仅是工具的使用, 还需研究一下.repo下的配置, git 的高级用法
    从github上下载库, 自动配置到 `local_manifests/roomservice.xml` 中应该也是在repo 下的配置里

- 如何将下载下来的msm8976 kernel, devices, vendor 与combo nx589j 联系起来

    [lunch 函数分析](./lunch_function_analysis.md)

    api.github.com/search, 学习一下github 的RESTful search 接口调用, 那们上传之后, 还要自行维护api 还是github 自动生成

    lunch 命令, 查找不到 combo 对应的库时, 就从roomservice.py 下载, roomservice.py 下载是使用github api 来实现的, 这里也可以修改下载的路径到自己的仓库. 

    roomservice.py 只负责下载相关的库, 这个过程也可以手动下载, 配置`.repo/local_manifests/roomservice.xml` 然后直接 repo sync, 这里有一个revision 不对应的问题, 还未搞明白, 应该是mk 文件中检查combo 与当前的版本适配问题吧. 

    然后直接可以lunch combo, 这里面如何衔接的流程, 还比较模糊. 编译完nx569j 仔细研究, 适配一套nx589j 练手

- 内核编译

    不同的手机厂商使用的内核是一样的吗? 
    内核是开源, 内核的驱动层要做哪些功能呢?


除了对文件夹的差异, 还有哪些地方可以学习一个aosp的源码编译呢?

上面的工作做完了, 对定制一款机型有思路吗? 现在来说, 除了去查找内核驱动(还不清楚是不是这么叫), 也就不清楚其他的了

想进行开发工作如何开展呢?

6. makefile 语法, mk 语法

7. 

