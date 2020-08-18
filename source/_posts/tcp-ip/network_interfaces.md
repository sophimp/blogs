---
title: TCP/IP - 第二章 网终接口
date: 2018-08-03 11:48:13
tags: 
- tcp-ip
- 网络
categories: 
- TCP-IP
description: tcp/ip第八版，第二章, 网络接口, 读书笔记
---

## Network interfaces
    - 是系统地聊聊互联网的接口么?  还是聊Network layer 网络层
        * tcp/ip 应用的 protocols and interfaces
        * 主要讨论 data link layer and physical layer
    - 看到此标题, 包括看了前段, 还是没有多的想法, 能从第一段看出到底讲什么吗?
        * 本章总观一些协议和接口是如何让 tcp/ip 在各种各样的物理网络中流动
        * tcp/ip 可以操作大量的物理网络, 以太网是大量使用这些协议的代表
        * 本章主要讨论 OSI 模型中的 data link layer, 也会提及一些 physical layer的技术
        * 仔细一记录, 还是能晓得讲些什么的
    - 该抓哪些点, 来构造出一个框架呢?
        * 标题就是主要的框架, 仔细一读标题, 信息量很大, 可以作为框架的点

## 该章节的框架
    - Ethernet and IEEE 802 local area networks(LANs)
        以太网 和 局域网
    - Fiber distributed data interface (FDDI)
        光纤分布式数据接口
    - Serial line IP (SLIP)
        线性连接 ip
    - Point-to-Point protocol (PPP)
        点对点协议
    - X.25
        这是rfc中的一个standard?
    - Frame relay
        帧分程传递
    - PPP over SONET and SDH circuits
        点对点基于 SONET and SDH 循环
    - Multi-Path channel+ (MPC+)
        多路径通道
    - Asynchronous transfer mode (ATM)
        异步传输模式
    - Multiprotocol over ATM (MATM)
        基于异步传输模式的多协议
    - 此章在 RCFs 中的位置

## Ethernet and IEEE 802 local area networks(LANs)
    以太网 和 局域网
    - the Ethernet coaxial cable
        两种 frame formats 或 standars 可以使用同一种以太共轴电缆
        frame formats(or standards) 是协议的一帧数据形式(或标准)
        以太同轴电缆, 原来不同的数据还分不同的电缆? 一直以为电缆是通用的
    - Ethernet 和 IEEE 802.3
        两种协议标准, 在header, type, length, SDAP, SSAP, Ctrl 等标志上有差异
        802.2/802.3/802.5 在发展史上作了兼容, 但是没有对 LSAP的协议作兼容

    - 以太
        传统的物理思维, 假设光传播的媒介, 后来证明光速不变性, 在真空中传播速度是一样的, 因此科学界抛弃了以太, 但是以太还是对这个世界有影响, 以太网的命名就是一个例子

    - 同轴电缆
        * 同轴电缆有数据的传播上限,  按说不管是什么协议的数据, 在同一物理世界背景下, 都应该共用一种电缆呀?  但是如果所有的协议都走一种电缆, 也不是明智的选择, 数据的解析量就大了很多.  协议 datagram standard 并不一样, 可以共用一种电缆, 难不成不同的电缆传输不同的数据么? 不是所有的电缆都可以传输数据么, 为何要设计这样的同轴电缆呢?
        * 所以不同的电缆, 只用来传输几种协议的数据 , 这样对于不同的网络应用场景, 就需要分别部署不同的电缆, 如 IBM token-ring LAN, 令牌环网(可理解为, 所有的数据包共用一段帧头,即令牌)
        * 一根同轴电缆的带宽是有限的, 不同带宽可以规定不同的信号, 所以限制了一种线缆只能传输几种协议标准的数据
        * 同轴电缆的网状是用来屏蔽电磁干扰? 
            果然是的
        * 50欧 和 75欧, 有效传输距离 185米, 这意味着两台终端的距离不能超过185米, 所以适用于集中型的网络, 全球的网络当然不能用这种线缆
    - gigabit Ethernet
        现在的传输速率已经提升到 10Gb/s了, 基于 IEEE 802.3Z 但是还没有一种协议被采用成商业标准
    
##  Fiber distributed data interface (FDDI)
    光纤分布式数据接口
    - 100M 光纤, fiber optic
    - 32-bit internet address 映射 48-bit FDDI address
        光纤的传输位数是48位? 之前的同轴线是按频段来传输数据
    - ARP 是干嘛的, 动态发现程序
    - 广播地址
        不管是 32位的网络地址, 还是48位的FDDI地址, 广播地址都是各位为1
    - big endian 也是网络字节序

    - SLIP 不是一个网络标准,  是一个 de facto standard, 也被记录在 RFC上
        仅仅是一个 packet framing protocol, 提供如下能力
            > Addressing
            > Packet type identification
            > Error detection/correction
            > Compression
            > 

## 网络问题:
    - 真正想要知道解决了什么问题, 还是要先总结一下有什么问题
    - 数据是怎么在 caber 各 fiber optic 中传输的
        问题的核心是信号的采集, 只有采集到了信号, 才能对信号编码, 采集的元器件是传感器: 敏感元件, 转换元件, 信号调节转换电路, 辅助电源
        至于电路中, 传输的是电流和光子
        这一套流程, 按说在上学的时候就想明白了, 那时候迷惑的是软件部分
    - 为什么要定义不同位数的传输
        肯定是最大效率的去使用传输能力
    - 允许存在不同位数传输的 线缆通信, 这个程序要怎么处理, 要如何定义标准
        程序问题, 就相对容易一些了
    - 一条线缆, 肯定不只传输一种协议的数据, 针对不同协议, 要怎么处理, 有何标准
        协议头, 多种协议的兼容处理, 是要麻烦一些, 所以, 一般一条线路也就只针对两三种协议标准的波, 而且大部分还可以共用
    - 寻址协议, 只是SLIP在做?
    - 链路层, 如何具体分工的, 感觉很多协议大都是在层级, 与两个层级间连通
    - IP层
    - 网络层
    - distributed 的数据, 如何同步, 如何调度
    - Network Interface 与 Intenet Protocol 有什么不一样的地方
        前者, 跟RFCs关系密切, 大多是关于硬件接口的软件定义和处理(MTU, 全双工)
        后者, 是概括OSI网络层的几种协议(IP, ICMP, ARP, DHCP)

