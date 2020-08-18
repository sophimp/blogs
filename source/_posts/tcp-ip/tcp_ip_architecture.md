---
title: TCP/IP - 第一章 架构，历史，标准和趋势
date: 2018-08-01 10:50:57
tags: 
- tcp-ip
categories: 
- TCP-IP
description: TCP/IP 第八版, 第一章 架构，历史，标准和趋势，读书笔记。
---

## task:
1. 概述
2. Ping 程序
3. traceroute 

## process:
1. 概述:
    - TCP/IP 是整个协议族中的两个协议代表
    - 链路层,                   网络层,         传输层,   应用层
      ARP/RARP/驱动及接口卡,    IP/ICMP/IGMP,   TCP/UDP,  Telnet/FTP/e-mail 
    - 将网络连接起来: 路由器在传输层, 网桥是在链路层
        TCP/IP 更倾向于使用路由而不是网桥来连接网络
        应用层不关心也不能关心 一台主机是在以太网上, 还是在令牌环网上
        路由还是主机, 在不同场合有不同叫法
    - 以太网, 令牌环网    
    - TCP使用了不可靠的IP服务, 但是提供了可靠的运输层服务 
        UDP 的使用需要在应用层保证可靠
    - 互联网地址, host, ip, DNS(domain name system)
    - internet: 用一个共同的协议族把多个网络连接在一起
        Internet: 指世界范围内通过TCP/IP互相通信的所有主机集合
        Internet 是一个 internet
    - ARP/RARP
    - 单工/双工: 单通道, 双通道
    - BSD: Berkeley Software Distribution 伯克利软件分布系统

2. Ping 程序
    - ICMP 报文, 一种协议, 32字节, ttl, 
    - 可以判断两台机器是否可到达, 还有没有其他的功能
    - ipv4, ipv6 协议又是干什么的?
    - 192.168.1.99 怎么样才能和 192.168.0.156 ping 得通?
    - 线路SLIP链接
    - 串口, USB, linux window port,  这些都属于网络可及, 可操作的
    - gateway的路由选路能力 要比主机强, 不用开始伺服选路程序
    - ping 程序就是用来进行连通性测试的基本工具, 使用 ICMP 回显报文请求和回显应答报文
        属于内核程序, 不通过传输层, LAN, WAN, SLIP, 局域网,  广域网, SLIP 线程
        ip记录路由选项, 时间戳与路由对应, 更高级的点工具是 traceroute
        上面的问题, 只是这一章显然不能解决

3. traceroute
    - TTL 来回的一个值, 最大值设为255, 每经过一个路由器, 减1, 意味着, 最多不会经过255个路由? 所以会有个生命周期, 不能一直在网际中漫游
    - 跳站计数器又是做什么的
    - RTT 时延? 还是往返时间
    - 可指定严格选路, 也可宽松选路, rtt的计算

4. 英文版:
    - 先看下历史, 概括, 很有必要, 然后再根据已了解的, 挑感兴趣的逐步了解
    - 进度慢, 那也得慢慢磕, 网络, 操作系统, 算法, 这三样, 必须要磕过去
        算法可以在搞网络和操作系统的时候带着学
        图形学, 相对来说还是独立的

*************************************
1. Architecture, history, standards and trends
    - groups of network:
        Backbones: 主干网
        Regional netoworks connecting: 区域网络连接 
        Commercial networks:    商业网络
        Local networks: 局域网络
    - System Network Architecture: SNA, 系统网络架构
    - Open System Interconnection: OSI, 开放系统连接
    - Layers: a package of functions
        Application
        Transport
        Internetwork
        Network Interface and Hardware
    - Tcp/ip applications
        待看

2. 改变记录方式, 以目标为文件单元, 计划明确, 提高效率

## the root of the internet
1. 这节是介绍历史的?
    - yes
    - 网络当然有更多的实现, 只不过历史原因, tcp/ip 当时期突出一些, 用得人多了就成了标准
    - 

2. 重要性
    - ARPANET
        已成为历史, 被tcp/ip替代, 转而搞 packet switching technology with the CCITTX.25
Standard, 成为了标准
    - DARPA 
        pioneering of packet-switching over radio networks and satellite channels
    - NSFNET (the National Science Foundation) 国家科研基地
        * a three-level internetwork in the United State consisting of.
        * backbone
            跨跃欧洲ip backbone network, 连接 mid-level 和 NSF-funded 超级计算机
        * Mid-level networks
            科研, 财团, 区域网络
        * Campus networks
            校园网络, 商业网络, 连接到 mid-level 
            网络也是出于校园研究, 所以那些有名的大学, 当然也在这些网络里有一席之地
            民用网络, 应该划分到财团, 商业网络里
        这些网络, 就是根据本土实际需求来建的,  通用性也是一步步演进的
        NSFNET 是现代网络的核心, 国家级的嘛, 但是为何现在没听说过了, 应该主流也是那个时代的, 果然, 看到 Internet2, NSFNET 就开始congested了
    - Internet2
        * 这些网络的历史, 要怎么看待呢? 
            抓住每一时期网络的特点, 根据需求演进的
            网络的发展太快, 来不及预测了
        * research community
            研究人员的力量不可忽略, 那么他们的需求当然也是重中之重
            这本就是一群没有就创造出来的角色
        * mission
            -> 几个重大的任务, 解决时代的问题
            -> 政府, 研究人员, 科学, 校园, 商业, 肯定还有未提及的军用
            -> 商业即民用级

3. Open Systems Interconnection
    - interconnection 意思与 connection 一样, 前者在计算机领域更专业性
    - 开放系统连接
    - OSI Reference Model
        Application <-> Presentation <-> Session <->
         Transport <-> Network <-> DataLink <-> Physical
        
4. TCP/IP Standards
    - 这个标准该怎么定, 从哪几个方面, 对这节会讲什么, 我怎么一无所知
        * 开始讲了标准的要求和申请流程
        * IESG (Internet Engineering Steering Group) 互联网审核标准的组织
    - 这个标准之所以这么流行: 1> 与生个俱来的开放性 2> 不断的更新 
    - 开放是把双刃剑, 如果没有能力控制, 带来的肯定是伤害
    - Internet Standards Process 网络标准程序
        * Technical excellence
            技术优秀
        * Prior implementation and testing
            先实现, 后测试
        * Clear, concise, and easily understood documentation
            简洁, 明了的文档
        * Openness and fairness
            开放和公平
            后缀ness当名词, 后续less 当否定
        * Timeliness
            合适宜的(按需解决问题)
    - 几个重要的 Internet Standards
        * STD1 

5. RFCs 
    - 这个貌似也很重要, 连续的提到, 是后续的网络标准么, 还只是一个网络名字缩写
    - Request for Comments 是一个标准文件的综合记录
        申请记录, 这个是通过才会有记录, 
        the mechanism of RFC, 是一种机制, 所有关于Internet的正式标准都以RFC文档出版
        协议的状态:
        Standard, Draft Standard, Proposed standard, Experimental
        informational, Historic, Required, Recommended, Elective, Limited Use
