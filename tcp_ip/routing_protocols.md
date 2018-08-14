
## Routing protocols
- 路由协议, 是路由器的协议? 肯定不是指路由器, 路由器可能也只是某一个功能, 这一章, 会不支更实用一些? 
- 学完这一章, 能干什么呢, 设置路由器, 搭服务器的时候, 会更清晰? 知道了socket 和 port 的概念, 服务器的搭建基本没问题了, 可能更高级一些的分布式服务器, 会用到?
- 路由协议, 应该也是安全高发区, 黑客的必备知识, 每个环节都有安全隐患, 这里能和黑客关联大吗?

## considering befor reading
- Autonomous systems
    * 自治系统 
- Types of IP routing and IP routing algorithims.
    * ip routing类型及算法 
- Routing Information Protocol (RIP)
- Routing Information Protocol version 2 (RIP-2)
    * 路由信息协议, datagram format
    * 2个版本
- RIPng for IPv6
    * 初步了解 IPv6
- Open Shortest Path First (OSPF)
    * 这个是干嘛的 
- Enhanced Interior Gateway Routing Protocol (EIGRP)
    * 加强的内网网关路由协议
- Exterior Gateway Protocol ( EGP )
    * 外网网关协议
- Border Gateway Protocol (BGP)
    * 边界网关协议
- Routing protocol selection
    * 路由协议选择
- Additional functions performed by the router
    * 路由的扩展功能  
- Routing processes in Unix-based systems
    * 在unix操作系统处理路由
- 还是还有部分是猜不到意思, 猜到意思的, 重复多遍, 将其纳入思维宫殿

## reading record
0. overview
- This type device attaches to two or more physical networks and forwards datagrams between the networks. 还真就是说的 路由器实物
- The configuration of the device can be extended to contain information detailing remote networks. This information provides a more complete view of the overall environment.
1. Autonomou systems
- is integral to understanding the function and scope of a routing protocol.
- The AS must present a consistent view of the internal destinations.

2. Types of IP routing and IP routing algorithms
- static routing
    * Static routing is manually performed by netword administrator.
    * Normally static routes are used only in simple topologies.
    * To manually define a default route.
    * To provide more secure network environment.
    * When complex routing policies are required.
    * To define a route that not automatically advertised within a network.

- distance vector routing
    * Distance vector algorithms are examples of dynamic routing protocols.
    * local IP routing table, distance vector table.
    * convergence time, routing loop, unstable packet forwarding, reduce capacity environments.
    * RIP is a popular example of distance vector routing protocol.

- link state routing
    * A link state is the description of an interface on a router (for example, IP address, subnet mask, type of network) and its relationship to neighboring routers. The colletion of these link state forms a link state database. 
    * Shortest Path First algorithm.
    * 所有的可达路由表都存在在每个路由器里, 那样的话, 计算就简单了, 而不用去试探

- path vector routing
    * The path vector routing algorithm is somewhat similar to the distance vector algorithm in the sense that each border router advertises the destination it can reach to its neighboring router.
    * advantages: 
        + flexibility; 
        + computational complexity is smaller than that of the link state protocol; 
        + have homogeneous policies for route selection; 
        + Only the domains whose routes are affected by the changes have to recompute;
        + Suppression of routing loops; 
        + Route computation precedes routing information dissemination.
        + Path vector routing has the ability to selectively hide information.
    * disadvantages:
        + the effect of a topology change can propagate farther than in traditional distance vector algorithms.
        + Unless the network topology is fully meshed or is able to appear so, routing loops can become an issue.
    * BGP is a popular example of a path vector routing protocol.

- hybrid routing
    * These protocols attempt to combine the positive attributes of both distance vector and link state protocols.

3. Routing Information Protocol
    * RIP packet types
    * RIP packet format
    * RIP Modes of operation
        + active mode, passive(silent) mode
    * Calculating distance vectors
        > The distance vector table entries:
        + the desination network (vector)
        + the associated cost (distance)
        + the IP address of the next-hop device
    * Convergence and counting to infinity

    * RIP limitations

4. Routing Information Protocol version 2
5. RIPng for IPv6
6. Openg Shortest Path First
7. Enhanced Interior Gateway Routing Protocol
8. Exterior Gateway Protocol
9. Border Gateway Protocol
10. Routing protocol selection
11. Addtional functions performed by the router
12. Routing process in UNIX-based systems

## considering after reading
- 看不下去, 进度这么慢, 主要还是因为看不懂, 一会就枯燥了, 想不到看到了什么, 想不到想看什么, 想不到可以看什么
- 一点点敖过去, 但是不对语言去总结归纳, 什么时候能有质的进步呢? 到目前质的进步就是能跟英语正面刚
- 可能还有潜在的语感, 肌肉记忆, 所以, 不坚持下去, 什么问题也说明不了
- 有时候, 就得面对这对无知的恐惧和期待, 才有可能顿悟
- 