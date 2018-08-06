
## 基于tcp/ip 有哪些应用及主要功能
1. Telnet
   - For interactive terminal access to remote internet hosts.

2. File Transfer Protocol (FTP)
    - For high-speed disk-to-disk file transfers

3. Simple Mail Transfer Protocol (SMTP)
    - internet mailing system

## tcp ip的关系
- tcp 是传输层的协议, ip 是网络层的协议
    tcp 是基于ip层的
- 之所以叫 tcp/ip 协议, 是因为tcp/ip 是现在网络的主流
- ip 层是对链路层的进一步封装, 不保证数据的可靠性(重传), 有序性(数据包流化), 
- tcp 是对ip层的封装, 增加的功能, 保证连接的稳定(4次握手), 丢包重传机制 保证数据可靠, 并不是这样就不会丢包
- 功能多了, 必然速率相对要慢一些, 那也是跟同等级别的UDP, 或者IP来比
    要是跟人比处理速度, 那就不是一个数量级上的
- error recovery, flow control, congestion control
- client/server model
- connection-oriented
    三次/四次握手

## end-to-end
- 什么是端到端
    不经过service, 直接client client 通信么?
    经网络查询, 神经网络的paper or blog 经常出现, 指不做过多的中间处理, 直接由输入得到输出, 也可引申高效的模型
    现在看的也是网络模型, 先将其将成一个术语, 不严谨的术语, 具体的还要看详情描述
- 

## 灵感激发
1. 术语
- 陌生的术语, 重要的一般书中都有解释, 就算没有, 现在网络这么发达, 也很容易就可获取到
- 所以看一本书, 可能不是对新手不友好, 而是自己懂得太少了,  压根就不是给新手看的书

2. 

## 知识扩展
1. tcp 封装的更多, udp更开放, 但是对于 error recovery, flow control, stream congestion 需要自己处理

2. bridges, routers and gateways
    - bridge
        不感知ip, 分程传递mac, 也可以提供 MAC 层协议会话
        只是一个桥接作用, 不改变啥, 扩展mac
    - router
        最基本的功能就是实现基于ip层的tcp/ip协议栈
        也称其他的名称 IP roter, IP gateway, Internet gateway, gateway
        但是现在 gateway 用来称呼更高层的应
        router 感知ip, it sends the datagram to the router so that it cant forward it  to the target host.
    - gateway
        address mapping from one network to another
        provide transformation of the data between the environments to support end-to-end application connectivity. 端到端的应用 数据传输
        对ip 也是不透明的, mapping 功能可以用来 filter
        对此更近意思的术语 firewall, 目标更明确的 gateway?


