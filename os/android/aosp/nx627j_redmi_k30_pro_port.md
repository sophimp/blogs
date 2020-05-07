
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


### red mi k30

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

### 操作系统

针对操作系统的理解

从每个模块开始分析， 由硬件到软件, 每个单元节点的划分以可理解的概念为止。 

这个设计是为了解决什么问题， 这个问题的除了当前的实现还有无其他的实现, 各个实现都有何优缺点。 

cpu, cpu 的工作很简单， 加载指令和操作数，执行. 

dma

内存

硬盘

总线

操作系统是软件， 如何与硬件一一对应理解

