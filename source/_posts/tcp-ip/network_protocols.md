---
title: TCP/IP - 第三章 网络协议
date: 2018-08-06 11:53:17
tags: 
- TCP-IP
- 网络协议
categories: 
- TCP-IP
description: tcp/ip第八版，第三章,互联网络协议， 读书笔记
---

## Networking protocols

> 总体介绍互联网传输的的protocols
> IP 协议与 IP module 有所区别, IP 协议只是 IP module 中协议的一种, tcp/ip 指的是只是module, 代表当前最通用的传输协议实现方案
> 

1. IP
- ip addressing
    * 五类IP地址, IP编址, 不能满足全世界的人, 采用子网掩码功能(Subnet)
    * 网络地址 主机地址
    * 那么多的主机, 都通过一个端口, 能处理的过来吗? 
        对于外网的ip 是给服务器用的, 虽然ip是共用, 但是能力还是服务器的, 所以处理能力跟服务器有关, 但是同一时间同时访问, 确是对应一条网络, 如果有大量的数据请求, 就是dos攻击的形式了, 所以上限还是线缆的传输容量
    * NAT, Network Address Translation, 网络地址转换技术, 子网掩码是理论, NAT是实现
- ip subnet
    * 知道了子网的掩码的作用, 关键是需要实际操作
    * 子网掩码是为了解决互联网爆炸似的成长, ip不够用的情况
    * To avoid having to request additional IP network address, 
    * 其实对于子网掩码还是疑惑着呢? 
        > 子网掩码到底能不能解决 ip 不够的问题呢?
        > 看了半天, 子网掩码, 貌似只是将网络本来的ip分得更细了,  A, B, C, D 类网络的 ip总地址并没有增加
        > 解决ip枯竭的思想是多台主机共用一个ip, 这个主要也是靠 NAT 程序?
        > 再看了一遍, 更不明白了,  subnet 只是与 remote net 保持同样的形式, 可以根据 local net 的规模来确定 net 与 host 的长度, 但是 net 的长度没有用, 主要是用host的长度, 这样再配合NAT程序, 也能达到扩展网络ip的功能, The entire network still appears as one IP network to the outside world.
    * multihomed hosts, network adapter
        A multihomed host has different IP address associated with each network adapter. 
        Each adapter connects to a different subnet or network.
- IP routing
    * gateway: a system that performs the duties of router.
    * direct, indirect: ascribe physical network
    * A router is needed to forward traffic between subnets.
        so, if I want the outnet device to access the subnet device, also work by the router.
    * ip routing table 
        + The ditermination of direct routes is derived from the list of local interfaces. eg. hosts 
        + Each host keeps the set of mappings between in following:
            > Destination ip network addresses
            > routes to next gateway 
        + Three types of mappings are in this table
            > The direct routes discribing locally attached networks
            > The indirect routes describing networks reachable through one or more gateways.
            > The default route that contains (direct or indirect) route used when the destination ip network is not found in the mappings of the previous typs of type 1 or 2
    * ip routing algorithm
        + a unique algorithm 
        + to differentiate between subnets
        + not difficult for algorithm, difficult to read English
- methods of delivery: unicast, broadcast, multicast, anycast
    * refer name to know sense
    * A connectionless protocol can send unicast, broadcast, multicast, or anycast messages.
    * Brocast addcresses are never valid as a source address. They must specify the destination address.
        BOOTP can use broadcast addresses to allow a diskless workstation to contact a boot server.
    * It is not only way to the netbar,  the more senarios is talked in the next chapters.
- the ip address exhaustion problem
    * The number of networks on the internet has been approximately doubling annually for a number of years.
    * I don`t understand how to solve this problem yet.
    * Class A,B,C,D network, only has 255*255*255*255 ip, these are less than 6 billion people, so there the subnet tecnology share one ip.
        every class network has limit subnets, this also is not the permanant solution.
        这样的话, A类网络会不会将线路爆
        ipv4 and ipv6
- Intranets: private ip address
    * Another approach to conserve the IP address space.
- network address translation (NAT)
    * read finished, but has no information, just know some terms, IPSec, NAPT
    * translate the ip and port, also to resolve the ip exhaustive 
    * NAT limit
- Classes Inter-Domain Routing (CIDR)
    * also have no information, just reading once over
    * TRD, transit routing domains
- IP diagram
    * The unit of transfer in an IP network is called an IP datagram
    * fragmentation
    * the protocol details interpretation

2. ICMP
- Internet Control Message Protocol
    * Path MTU Discovery is a draft standard protocol with a status of elective.
    * ICMP Router Discovery is a proposed standard protocol with a status of elective.
- ICMP can be characterized as follows:
    * ICMP uses IP as though ICMP were a high-level protocol. However ICMP is an integral part of IP and must be characterized by every IP modules.
    * ICMP is used to report errors, not to make IP reliable.
    * ICMP cannot be used to report errors with ICMP messages. This avoids infinite repetitions.
- ICMP Messages
    * ICMP messages are sent in IP datagrams.
    * transmit status message 
- ICMP Applications
    * ping
        > Packet InterNet Groper, 网络包探索者 
        > Ping is the simplest of all TCP/IP applications. 
        > Generally, the first test of reachability for a host is to attempt to ping it.
    * traceroute
        > Traceroute is based on ICMP and UDP
        > The Traceroute program is used to determine the route IP datagrams follow through the network.

3. IGMP
- Internet Group Management Protocol
- IGMP is also an integral part of IP.
- It allows host to participate in multicast.

4. ARP
- Address Resolution Protocol
    * is a network-specific standard protocol
    * is responsible for converting the higher-level protocol address(IP address) to physical network address. 
    * A model(ARP) is provided that will translate the IP address to the physical address of the destination host.
- ARP request, is a broadcast 
    * use personal computer to do server host. To do work in the place that make personal computer can be accessed by the out network
    * Proxy-ARP, modified ARP on router
    * old IP protocol, subnet IP protocol

5. RARP
- Reverse Address Resolution Protocol 
- RARP requires one or more server hosts in the network to maintain a database of mappings between physical addresses and protocol addresses so that they will be able to reply to requests form client hosts.

6. BOOTP
- bootstrap protocol
- The BOOTP protocol was originally developed as a mechanism to enable diskless host to be remotely booted over a network as workstations, routers, terminal connectors, and so on.
- 

7. DHCP

## 问题
- 写完上面的几个协议, 就解决了之前的疑问, IP 是属于网络层的
    这几个主要协议, 构成了网络层, 从名字, 也可知 网络层的功能
- 看前面 Network Interface 是有些枯燥, 到了这里, 可能才更有意思一些
    包括后面的 routing protocol, transprot layer protocol 都主要是了解这些协议的功能构成, 以及查看这些协议的工具, 有何用途, 能做何用
- 为何要看TCP/IP
    想弄明白网络中的那些事, 除了架个服务器, 让自己的电脑能被外网访问, 还能干些什么事? 为何会有这些协议,  路由器还有哪些高级的玩法, 如果管理自己的网络, 如何管理分布式网络, 如何配置自己的局域网络, 如何用网络, 将自己的生活圈子组建起来?
    了解一下SMTP, FTP, HTTP等协议, 
- tcp/ip 看完, 能否对 lantern 有所改动, 可以少点会员费, 还能使用优质网络?

## 思维重组
- 想从tcp/ip中了解一什么?
- 数据是如何从一台设备到另一台设备中? 
    按协议来, 二进制对应着高低电平, 高低电平的意义用布尔逻辑来解释
- 其中的实现细节, 我需要了解到哪些? 
    这些不清楚, 所以只能先通读, 有所也解后, 再按点突破
- 在linux能用到哪些?
    * 服务器编程  
        翻墙
        邮件服务分发器
        局域网络
        路由的操作 
        游戏服务器
        操作系统中的端口, 是真得有端口, 还所有数据从一个物理入口进入, 程序按端口来分发消息?
    * 整个网络 基本上是就是数据的存储与搬运, 数据如此重要, 必然要考虑安全问题
        怎么去保证数据互通
        怎么拦截数据, 有哪些部分可以获取到数据 
        跟数据相关的安全和攻击有哪些
        数据的加密, 有没有必要了解一番
    * 黑客
        攻
        防
- 从哪里入手
    * 书籍, 就是再枯燥, 也得通读一遍, 至少各个环节能自圆其说
    * 读的过程中, 尽量再发散, 以英文作笔记, 抛开中文都写不好文章的恐惧, 重新学习写作, 从语言开始, 是一个好机会
- 效率
    * 最快得效率, 还是要保持一定的套路, 思维套路来分析, 不然很容易就陷入迷茫, 不知在看些什么的窘境中
    * 看一本书, 先从目录分析, 一本书太广, 就按目标计划来分析, 或一章章的分析
    * 每章每小节, 按标题分析, 分析不到的, 就从是什么, 能解决什么, 应用场景来泛读
    * 根据应用场景与兴趣, 再进一步精读是怎么做到的
    
## review

再次设置网络还是有些迷, 子网掩码如何设置? 两台电脑是如何通信的? 路由是如何转发数据的? 这些还是不明白. 

设置一个路由, 使两个设备能通信, 还是现实中很重要的一个场影, 一旦可以找到目的电脑, 那么应用就可以用了. 

两台主机直连, 点对点通信, 即在同一个IP局域网内或令牌环网内. 这个时候可以直接被本机的路由列表感知到? 

现在主要是攻破, 不在同一个局域网内的通信, 路由如何选路, 数据如何到达目的地的. 

	首先不要网线的转输能力不用置疑, 在一个子网下肯定可以满足. 

	不管是主机还是路由都有路由表

网络层, 是对通信过程的抽象. 每一个路由理论上是对每一层协议都要感知的. 每一层管每一层的事, 每一层大都不只一个协议实现. 
这样想, 一下子就明了了, 关键还是要理解业务. 

