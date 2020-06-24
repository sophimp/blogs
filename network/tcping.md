
### tcping 

使用tcping 验证目标手机是否可连通. 

	确实可以测试, 但是在linux 上, 只有手机连接wifi时, 才可以ping 得通, 移动网络ping不通. 
	有线连接与移动连接是单向连接的? 

如何确定wifi与手机是单向连接? 

	现在蜂窝网可以ping通 wifi网络, 但是wifi网ping不通蜂窝网. 

tcping 工具

	linux下还没有一个好用的工具 
	[支持ipv6的](https://github.com/MushrooM93/tcping), 只能探测端口是否开放. 
	[可以模仿ping 结果的](https://github.com/jlyo/tcping), 不支持ipv6, 因此, 只能将这两个工具结合成一个了? 
	这两个工具, 都有一定的历史, 也说明网络这一块的知识确实变化得比较慢. 

	windows 平台的 [tcping](https://elifulkerson.com/projects/tcping.php)

	着手这三个平台的源码, 写一个linux下方便使用的tcping 工具. 

	如果上层的应用可以拿到出错的信息, 也没必要再去深入到更底层去定制. 

	连raw socket 都没有使用, 只是使用socket connect 来判断结果.
	
### ipv6

wifi, 移动, ipv6 
	
	[ipv6维基百科](https://zh.wikipedia.org/zh/IPv6)

	兼容ipv4, 但同样不可以共用. 协议也有所不一样.


网络隔离, 核心网

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

先试一试wifi网络下的功能:

	端口关闭, 无网络连接, 功能都正常, errorno 分别是111, 113
	打开一个ipv6的端口, 如果确实可以连接, 那么说明功能确实是正常的, 至少可以满足ping的功能. 
	必须是基于tcp的服务监听的端口, 才可以连接吧. 而一个端口的打开, 也必须有一个服务监听, 不然毫无意义. 
	
直接使用java 的 socket 接口来验证:
	可以大概验证是否可达， 但是具体信息比较模糊。 

移植到Android平台, 验证移动网络下的功能:

