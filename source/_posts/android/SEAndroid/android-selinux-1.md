---
title: Android SELinux 系列(一) 背景，作用，原理
date: 2020-07-31 17:03:08
tags:
- SELinux
- Android
categories:
- Android
description: 在ROM移植过程中, 卡在启动流程里，是最难受的事， 没有串口调试，拿不到相关的日志，只能靠猜，SELinux 的配置，是否会导致启动不起来呢？ 最后的结果是，靠猜并没有解决启动问题，因为可能出问题的环节太多了，此次研究raw socket 调用同样也遇到SEAndroid 的问题, 但借此机会，系统的学习一上SEAndroid, SELinux 是有必要的。
---

## Android SELinux 

[android seolicy 官方文档](https://source.android.com/security/selinux/customize)

sepolicy.te 文件使用的是[M4语言](https://www.gnu.org/savannah-checkouts/gnu/m4/manual/m4-1.4.18/index.html)

[SELinux 简析与修改](https://www.cnblogs.com/blogs-of-lxl/p/7515023.html)

### 是什么

SELinux, 是为了加强系统安全
	强制控制访问(MAC), 强制使用管理员定义的安全策略，基于安全上下文或标签, 鉴权所有的进程，对象和操作。用来校验服务和应用的权限。

SEAndroid 
	SELinux for Android
	所有的进程，对象和操作，都得强制控制访问。 

### 为什么

所有的进程，对象，操作，如何统一强制控制访问的? 

	`user:role:type:level`, 定义此类标签，linux下一切皆文件操作

为何要编译成二进制文件? 
	省空间吗？ 字符串使用ascii编码不是一样吗？
	不仅仅是字符串，是可执行指令？ 使用m4宏解释器执行？ 

	二进制文件空间占用小， 解析速度快。主要是二进制文件必须得设计格式(协议)，然后只保留有用信息，然后直接按格式（协议)解析即可
	编译成二进制的过程类似于网络通信的协议， 将接口数据序列化成二进制流，反序列化就是再还原协议数据的过程。 

	R.java文件id格式`0XPPTTEEEE`, PP为package_id, 即ResTable_package数据结构中的id, TT为type_id, 即ResTable_typeSpec数据结构中的id, EEEE 为entry_id, 按先后顺序自动排列。

宏命令/方法在哪里找? 

	m4宏一般用作文本替换工具。 

	[GNU M4 官方文档](https://www.gnu.org/savannah-checkouts/gnu/m4/manual/m4-1.4.18/m4.html#Names)
	将宏编译成二进制文件也是与资源文件类似的思想, 省空间, 便于解析。 

### 怎么做

如何新增一个进程的权限访问

	根据avc报错日志，在对应的te文件中添加相应的规则

Android又是如何检测到api调用的
	
	修改了te文件, 再编译，如果系统对某些api做了限制，同样会有avc报错， 再根据日志去到相应的文件去掉限制即可。 

	所以无论是系统移植， 还是开发，日志很有用，耐下心看日志， 可以解决大部分的问题

### 术语
|术语| 描述| 
|:--:|:--:|
| Access Vector (AV) | 权限集字典(如 open, write, read) | 
| Access Vector Cache (AVC) | SELinux Security Server 创建的一个存储访问判定的组件, 后续由 Object Manager 使用, 此组件允许以前的决定可以重新恢复而不必重新计算, 在SELinux services 中有两种AVC: \
		1. 内核AVC缓存基于Security Server 由内核Object managers 创建的判定\
		2. 编译到libselinux的用户空间AVC 缓存由SELinux-aware 调用avc_open, avc_has_perm, avc_has_perm_noaudit 方法创建的判定 |
| Domain | 由一个或多个关联类型组件Security Context 的进程组成。Type Enforcement 规则声明domain 如何与对象交互(查看Object Class) |
| Linux Security Module (LSM) | 此框架提供了hook到内核组件(如disk, network services), 由安全模块用来执行访问控制检测。 现在只有一个LSM模块可被加载， 然而工作中需要入栈多个模块 |
| Mandatory Access Control | 系统加强的访问控制机制|
| Multi-Level Security (MLS) | 基于Bell-La & Padula(BLP)模型加强机密性。如一个运行在'机密'级的程序可以在其当前级别读/写，但只能读其更低层级别，可以写更高层级别(越低权限越大?) |
| Object Class | 描述一个资源, 如files，sockets, services. 每一个'class' 都有合适的权限去读、写、导出这些资源. 这可以强制通过Object Manager 访问它们的实例对象 |
| Object Manager | 用户空间和内核组件, 负责打标签，管理(如创建，访问，销毁)和强制控制class对象的访问|
| Policy | 决定访问权限的规则集合. 在SELinux中， 这些规则通常使用支持`m4`宏的内核策略语言或新的CIL语言编写。然后这些策略被编译成二进制格式加载到Security Server|
| Role Based Access Control | SELinux 用户关联着一个或多个角色, 每个角色又可能关联着一个或多个Domain类型 |
| Security Server | 一个Linux内核子系统, 代表SELinux-aware的应用和Object Managers 基于Policy制定访问决策和计算安全上下文, 安全中心不强制决策，它仅仅根据Policy标记一个操作是否被允许. 强制决策是SELinux-aware应用或Object Manager的责任。|
| Security Context | SELinux 安全上下文是一个变长的字符串，由以下命令组件组成: `user:role:type[:range]`, 其中range是可选的. 安全上下文一般简称上下文，有时也叫标签|
| Security Identifier(SID) | SID 是由内核安全中心和用户空间AVC映射的代表一个安全上下文的唯一不透明整数值|
| Type Enforcement | 安全策略配置文件, SELinux 利用一种特定风格的TE强制实施强制访问控制|
| DAC |	Discretionary Access Control, 自主访问控制 |
| <++>|<++>|

### 安全策略配置文件

file_context:	记载了不同目录初始化的SContext， 和object_r有关
seapp_context:	和应用程序打标签有关
property_contexts:	和属性服务(property_service)有关, 为不同的属性打标签 

编译流程是怎么样的，为何要打标签?

作用范围 

	文件操作，接口调用， 功能特性

### 文档

[Object Class 和 Permissions](http://selinuxproject.org/page/ObjectClassesPerms)

