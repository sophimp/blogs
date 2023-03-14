---
title: TCPing 工具
uuid: 329
status: publish
date: 2020-06-20 16:03:33
tags: TCPing
categories: Network
description: 传统的ping是基于ICMP来实现的，而有些路由会禁掉icmp协议，因此用tcp 来实现ping 或者检查某些端口是否开放，是一种可行的方式。通过测试发现，在手机上，有些运营商会连tcp也给禁了，因此需要尝试使用raw socket, 简单的root并不能调用raw socket的API，接下来的方向还要是研究SEAndroid, 定制ROM。
---

### tcping 

- 使用tcping 验证目标手机是否可连通. 

确实可以测试, 但是在linux 上, 只有手机连接wifi时, 才可以ping 得通, 移动网络ping不通. 
有线连接与移动连接是单向连接的? 

- 如何确定wifi与手机是单向连接? 

现在蜂窝网可以ping通 wifi网络, 但是wifi网ping不通蜂窝网. 

- tcping 工具

linux下还没有一个好用的工具 
[支持ipv6的](https://github.com/MushrooM93/tcping), 只能探测端口是否开放. 
[可以模仿ping 结果的](https://github.com/jlyo/tcping), 不支持ipv6, 因此, 只能将这两个工具结合成一个了? 
这两个工具, 都有一定的历史, 也说明网络这一块的知识确实变化得比较慢. 

windows 平台的 [tcping](https://elifulkerson.com/projects/tcping.php)

着手这三个平台的源码, 写一个linux下方便使用的tcping 工具. 

如果上层的应用可以拿到出错的信息, 也没必要再去深入到更底层去定制. 

连raw socket 都没有使用, 只是使用socket connect 来判断结果.
	
### ipv6

- wifi, 移动, ipv6 
	
[ipv6维基百科](https://zh.wikipedia.org/zh/IPv6)

兼容ipv4, 但同样不可以共用. 协议也有所不一样.


- 网络隔离, 核心网

推测: 
蜂窝网, 是通过基站, 最终要经过核心网, 转发一次, 到目标服务器. 
wifi 则是通过路由, 直到目标服务器. 
所以, 不能通过PC的wifi网络 直接ping通 移动数据的蜂窝网络下的ip? 
	
### 端口

手机有哪些端口是打开的? 可以tcp测试的. 

	端口不打开, 确实可以收到RST 包么?  

如何使用ipv6的程序来监听端口

测试端口没有打开是否可以获取信令呢? 


### 实现

目前找到的tcping 代码, 都是使用 socket connect 的出错信息来判断是否ping得通. windows 下的socket2 出错信息更加详细, 实现者的功能也更多一些.  但是linux下也有raw socket 控制.

端口打开, 端口关闭, 无网络连接, 

- 先试一试wifi网络下的功能:

端口关闭, 无网络连接, 功能都正常, errorno 分别是111, 113
打开一个ipv6的端口, 如果确实可以连接, 那么说明功能确实是正常的, 至少可以满足ping的功能. 
必须是基于tcp的服务监听的端口, 才可以连接吧. 而一个端口的打开, 也必须有一个服务监听, 不然毫无意义. 
	
- 直接使用java 的 socket 接口来验证:

可以大概验证是否可达， 但是具体信息比较模糊。 
使用tcpdump 可以验证wifi 网络, tcp 的三次握手确实发生了。 

- 移植到Android平台, 验证移动网络下的功能:

LTE网络只能ping通LTE下的ipv6, 不能ping通wifi下的ipv6
在同时连接wifi和lte的情况下， 优先使用wifi网络， 也ping不通lte IPv6

- 抓包

wifi网络下，走得是网卡, 使用 tcpdump + wireshark 来抓包分析
lte 网络下， 走得是基带， 使用 QCSuper + wireshark 来抓包分析

pip3 安装，会因为镜像的缘故， 导致网速太差，下载不下来， 办法是加一个 --default-timeout=100， 然后多下载几次， 或者换成国内的镜像。 
	

[QCSuper 抓无线2G/3G/4G包](https://cloud.tencent.com/developer/article/1480752)

```sh
	# 强开usb diag 模式
	setprop sys.usb.config  diag,adb
```

	magisk adb_root模块， 可以使用 adb root

```sh
	./qcsuper.py --adb --pcap-dump # 还是不可以使用, 总是会出现adb bridge closed, 问题应该还是出在 adb_bridge
```


## Fri 03 Jul 2020 05:09:25 PM CST

还是要使用QXDM, 需要打开 diag 端口才可以抓数， 但是抓到了， 半天也分析不到？

QXDM 是否可以直接抓 tcpdump的包呢？ 

QCSuper 需要重新新编译， 也可以版本跟不上了， ioctl 应该是在读 /dev/diag 出错的

## Mon 06 Jul 2020 11:03:38 AM CST

使用同网络， 今天也都ping不通了。 看来需要搞明白 4G 网络到wifi网络的原理。 

- 中心网都干了些什么？ 

把A口上来的呼叫请求或数据请求，接续到不同的网络上。 

- 4G网络 与 wifi网络 到底有没有隔离？ 

4G网络可能与wifi网络也没有隔离，但是路由分配的wifi 下的IPv6 是fc00 开头的，只用来局域网通信， 所以不能ping通。 
[ipv6 wifi](https://zh.wikipedia.org/wiki/IPv6)

- 三大运营商都说全面支持了IPv6, 理论上IPv6 是不会屏蔽的啊， 为何又相互的ping不通呢？

上周还可以Ping的通， 但是这周不管哪个运营商， 都不能正常Ping通了， ip 已经被屏蔽了吗？ 也不应该， 手机直接访问test-ipv6 还是可以的。 

- teredo 服务器

ipv6/ipv4 兼容方案, 将ipv6 的包封装在UDPv4 包中, wifi上说teredo 服务器不需要太多的带宽， 不是经过这个服务器， 就意味着流量已经通过了么？ 
不需要太多带宽， 意味着， 只是首次包头解析与两端配对？ 
这里面又是一个深坑啊， 怎么才能将这次的工作搞得严谨， 也不是一周两周的事情， 需要很多时间.

- IPv6 会屏蔽端口，也会屏蔽ip吗？ 除了外网， 为何要屏蔽？ 

查资料看来， 还只是屏蔽了 80和443 端口， 1000以下的端口是发现一个，关闭一个， 但是又如何发现呢？ 

- IPv6 的地址会变，还会分配一些临时的IPv6, 那么在不变的IPv6的情况下， 为何也会Ping不通呢？ 

先不管ipv6的获取， 这个手段是不用我考虑的。 
ping不通是分卡和手机， 有的卡没有分配ipv6, 过旧的手机也不支持ipv6。 
正常情况下， TCPing 各运营商都可以正常检测，联通 - 电信 - 移动 可以互ping通。 移动看来是不支持IPv6的, 至少当前这个核心网还没有支持。 

移动测试了3张卡, 确实都ping不通， 但是ping 联通的是可以的, 也可能ping联通的信号是经过的联通的核心网？ 

接下来又回到了如何抓包确认， 确实是ping通了目标机。 

- IPv6 TCPing 影响因素:
	
手机系统不支持

手机卡不支持, 有的联通卡，经常就识别不出IPv6

运营商不支持， 目前发现移动运营商不支持。 
