---
title: 小米5X刷机验证报告
uuid: 261
status: publish
date: 2019-03-09 17:22:00
tags: 刷机
categories: ROM, Android
description: rom 移植最怕的就是启动不了， 拿不到启动日志，只能从各个可能的环节去分析， init.rc 是内核启动init加载的脚本，控制了系统启动过程中加载的服务。 
---
## 小米5X刷机验证报告

1. 结论:
    邝锦良大神的完美拆机下, 已成功通过短接激活 9008 端口进入 download 模式, 刷入系统和root包, 激活xposed框架

2. 过程:

    - 进入download模式
        按照网上的教程比较顺利的激活9008端口进入了download模式, 使用小米官方线刷工具MiFlash 刷入了官方的rom包, 继而进入下一步, 找带第三方recovery或已root的线刷包, 但是在网上只有卡刷包, 并没符合要求的线刷包, 而卡刷又必须先有第三方recovery, 按以往的经验, 刷第三方recovery都是通过fastboot工具在bootloader模式下刷入, bootloader又需要官方解锁. 因此,尝试另一个突破点: 制作线刷包rom

    - 定制线刷包rom
        * 定制线刷rom包, 并不是一个容易的事情, 网上大多都是修改卡刷包的教程, 没找到线刷包的教程, 按照修改卡刷包的思路, 去修改已有的线程刷, 涉及到的知识比较多, 需要对 system.img, boot.img, userdata.img 等 拆包再打包, 这主要涉及几个难点: 
            > 首先拆包再打包的工具, 都是在国外, 大多数是linux下的工具, 好歹找到一个可以成功unpack, pack的工具, 再打包后, 替换的image刷入后并不能用.
            > 其次, 拆包后对哪些文件做修改, 卡刷主要是通过脚本, 线刷image解包后, 并没找到相关脚本, 简单的将su放入xbin下,刷入后一样不能启动, 猜测可能能还要修改分区写入, 修改boot.img, 这需要对linux取得root权限的原理有清晰的了解, 一时间也没找到相关资料, 按照自己的推测修改了几个线刷包后, 刷入都不能启动
            > 再有, 编译aosp源码得到的只有3个image文件: system.img, boot.img, userdata.img, 而小米的线刷包里还多了 md5, crc校验, mbn文件, xml配置, dat文件等, 要搞明白这些文件的作用和修改方法, 也不是一天两天的事
            > 至此, 定制rom陷入了困境
       * 在查找资料的过程中, 也发现了现成的rom助手和rom制作工具, 经使用发现也不能满需求, 这些工具主要是删减预安装的apk, 而且就算精简完成了, 刷入小米5X, 也是一样不能使用
       * 学习定制线刷rom, 涉及的内容挺多, 是件长期积累的事
       * 至此, 已知路径都尝试了, 吃饭的时候, 偶然间灵感闪现, 发现还有一个点值得试, 定制线刷recovery

    - 定制线刷 recovery
        * 之前的 recovery 都是通过fastboot 在bootloader下刷入, 这里有bl锁卡住. 在recovery下可以刷系统, 在系统里也可以写recovery, 所以recovery是和 system 同一级别的, 9008端口既然可以线刷system, 那也应该可以直接线刷 recovery
        * 经过一番查找, 在小米国外论坛和xda论坛上发现了蛛丝马迹, 最后寻得一个红米3的reovery.img线刷包, 直接刷入小米5X, 刷不进去, 于是乎, 对着reovery下的文件, 将官方的线刷包对应的文件内容复制进去, 对比着不同之处, 修改一些参数, 定制了一个reovery线刷包
        * 激活9008 成功刷入到小米5X中, 可进入第三文recovery模式, 有了第三方的recovery, 后面就可以为所欲为, 激活xposed框架就顺理成章
    
3. 心得:
    在此次刷机过程中, 深深感受到了android作为开源系统的魅力所在: 任何环节, 都可自己动手, 丰衣足食, 在此途中, 有前辈在布道, 有同道中人在探索,  感动那无私热情的分享, 惊叹那各种想法之美妙, 为技术狂欢, 为信念传承. 
    刷机教程和相关工具包, 后续整理共享.

