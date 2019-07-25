
## 努比亚 z18mini 移植过程

	主要是内核， vendor,  device 数据的获取

	vendor 数据，可以在 /vendor, /system/vendor 下获取到
	kernel 的源码应该也不是问题，剩下的就是devices下的工作

	为了确保文件的完整性，将现有系统下的所有可能的文件都copy 下来，但是有些bin 文件没有权限, 己经是root用户了


