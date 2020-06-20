
### tcping 

使用tcping 验证目标手机是否可连通. 

	确实可以测试, 但是在linux 上, 只有手机连接wifi时, 才可以ping 得通, 移动网络ping不通. 
	有线连接与移动连接还是有隔离的?

如何确定wifi与手机是否隔离? 

tcping 工具

	linux下还没有一个好用的工具 
	[支持ipv6的](https://github.com/MushrooM93/tcping), 只能探测端口是否开放. 
	[可以模仿ping 结果的](https://github.com/jlyo/tcping), 不支持ipv6, 因此, 只能将这两个工具结合成一个了? 
	这两个工具, 都有一定的历史, 也说明网络这一块的知识确实变化得比较慢. 
	
### ipv6

wifi 路由 ipv6

移动 ipv6

### 端口

手机有哪些端口是打开的? 可以tcp测试的. 

测试端口没有打开是否可以获取信令呢? 
