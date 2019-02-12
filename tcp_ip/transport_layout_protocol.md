
##  Transport layout protocols
    看到这里, 对于网络的一些技术也大致有个了解, 这时反而还不清楚想要再学些什么了, 不知道下一步要学些什么, 就按书的编排, 逐步学习

## Consideration befor reading
1. 看到了熟悉的 socket, port, udp, tcp, 有些期待.
2. 本章就分了三节
- ports and sockets
    * port, 操作系统预留的用来标识每个服务, 方便通信交互, 是一个抽象的concept, 难不成, 还有对应的硬件结构么? 
    * socket, 也是对于个一通道的抽象concept, 描述服务端相互确认后通信的流程
- udp
    * 协议, 只管发, 不管发送结果, 是到达(堵塞, 乱序, 循环, 超时 )
- tcp
    * 针对发送的一些意外情况, 做了处理, 省了上层的事, 就更高级可靠一些, 也减小上层调用的门槛

## Reading Record
1. prots and sockets
- The concept of ports and sockets provide a way to uniformly and uniquely identify connections and the programs and hosts that are engaged in them, irrespective of specific process IDs.
- ports
    * The well-known ports are controlled and assgined by the Internet Assgined Number Authority (<b>IANA</b>) annd on most systems can only be used by system processes  or by programs executed by privileged users.
    * Ephemeral ports are not controlled by IANA and can be used by ordinary use-developed programs on most systems.
- sockets
    * A socket is a special type of file handle, which is used by a process to request network services from the operating system.
    * <protocol, local-address, local-port>
    * A conversation is the communication link between two processes.
    * two processes that comprise a connection <protocol, local-address, local-port, foreign-address, foreign-prot>
    * The half-association is also called a socket or a transport address.
    * The socket model provides a process with a full-duplex byte stream connection to another process.

2. udp (User Datagram Protocol)
> Its status is standard and almost every TCP/IP implementation intended for small units transfer or those which can afford to lose a litter amount of data will include UDP.
> extremely thin, consequently, efficent
- UDP datagram format
    * no need to concern until used it.
- UDP application progamming interface
    * Be aware that UDP and IP do not provide guaranteed delivery, flow-control, or error recovery, so these must be provided by the application.
    * Trivail File Transfer Protocol (TFTP)
    * Dynamic Domain Name System (DDNS)
    * Remote Procedure Call(RPC)
    * Simple Network Management Protocol (SNMP)
    * Lightweight Directory Access Protocol (LDAP)

3. tcp (Transmission Control Protocl)
> 从名字看, tcp 是基于udp, 准备说是基于 IP, 干得事比UDP多一些, 但不是包含关系
    connection-oriented Protocol
- tcp concept
    * Stream data transfer
    * Reliability
    * Flow Control
    * Multiplex
    * Logical connections
        + The combination of this status, including sockets, sequence numbers, and window size, is called logical connection.
    * Full duplex
    * window principle
- tcp appliction programming inteface
    * The TCP application programming interface is not fully defined. A great digree of freedom is left to the implementers 
    * Open, Send, Receive, Close, Status, Abort.
- tcp congestion control algorithm
    basic internet standards
    * Slow start 
    * Congestion Avoidance
    * Fast retransmit
    * Fast recoveryy
- 直接看英文书是值得的, 虽然进度很慢, 但是就这些知识, 看中文的进度一样很慢, 且更静不下心来, 因为还挂念着学英语, 特别是在看到陌生的concept时, 就会怀疑是不是翻译错了

## Summarize after reading
1. ports 确是用来标识 processes(server/client, local/remote) communication
2. 关于tcp/udp, 根面试的时候, 背的知识点大差不差, 粗略过了一遍, 见个脸熟, 这一遍的作用也主要就是这了
3. 所谓零基础, 真是的零基础, 没听说过, 见识也少, 怎么去凭空想象, 或看到名词都能想到工作原理, 光是弄计算机怎么工作这一回事, 就是曲折回环 
4. 得, 不要再不平衡了
5. 我是该将计算机的学习, 归结为习惯, 而不是强迫太用力, 不然确实不会长久, 这3周的周末, 基本上又是都浪费了, 可能也是对平时的一点放松, 但是, 我的时间确实很紧, 不能只找放松这个借口, 因为就算没有学习, 我还是不放松, 而且我知道那种不学习的状态, 看电影 看节目, 那种心态, 也只是呵呵一笑, 并没有形成自己的文字, 所以, 看完了, 依然很空虚
6. 也不尽然, 看了还是有一些收获, 思考问题的方向, 他们的生活局部, 他们的部分思想, 都很有意思, 从这些也能看到他们优秀的一面, 所以也算是长了见识, 到于将见识, 所想, 输出, 这又是另一个能力, 这个能力也一直没有得到锻炼, 所以痛苦也是必然的, 不能说, 还像年轻的时候, 不计成果, 按兴趣来, 要考虑的多, 必须得强迫自己一些
7. 靠兴趣支撑, 也不是说就不做了, 也得那么多时间去积累, 去踩坑, 只是在这个过程中, 心态更好, 效率更高, 思维更集中, 所以, 关键点是在思想状态, 怎么去将那种痛苦减轻, 而不是靠不做来减轻
8. 这些逻辑还是有些绕, 找到问题的关键点, 而不是给偷懒找借口, 需要放松, 人肯定需要放松, 但是放松, 不是以自己不喜欢的方式去放松, 我喜欢什么样的方式去放松呢? 
9. 要承受的代码太多了, 现在何止是12年, 15年的落后于人啦 
