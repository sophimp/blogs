
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

- Android.mk 语法, Makefile语法

    就以`product_config.sh` 和 aosp 的 make文件为例, 开始学习 makefile

- repo 工具

- 定制一款机型

除了对文件夹的差异, 还有哪些地方可以学习一个aosp的源码编译呢?

上面的工作做完了, 对定制一款机型有思路吗? 现在来说, 除了去查找内核驱动(还不清楚是不是这么叫), 也就不清楚其他的了

想进行开发工作如何开展呢?

6. makefile 语法, mk 语法

7. 

