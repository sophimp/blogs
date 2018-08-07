
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
- UDP datagram format

- UDP application progamming interface

3. tcp (Transmission Control Protocl)
- 从名字看, tcp 是基于udp
- tcp concept

- tcp appliction programming inteface

- tcp congestion control algorithm

## Summarize after reading
1. ports 确是用来标识 processes(server/client, local/remote) communication
2. 