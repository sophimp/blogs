---
title: nms-yang model
date: 2021-01-06 10:03:57
tags:
- nms
- yang
categories:
- nms
description: yang mdoel 是一种建模语言, 为什么要使用yang, 相比于netconf的xml形式，yang有什么优缺点，怎么与netconf结合的, 对于c语言实现的libyang库又该如何使用呢？怎么移植到c sharp中来呢？ 
---

### libyang 概览

是什么
yang 是数据建模语言， 实际数据传输的承载形式还是使用xml。
libyang库可以解析yang model, 用来定义xml的结构，校验xml的合法性, 解析xml的说明文档，也可以用来动态生成xml。

为什么
yang model 为程序提供了一致的操作数据的接口， 解决了配置读写困难的问题。
使用yang模型建模, 可以利用yang模型完成数据合法性的检查，保证风格一致性，不需要应用程序直接操作文件。

### 标识符

 The module's Substatements

 +--------------+---------+-------------+
 | substatement | section | cardinality |
 +--------------+---------+-------------+
 | anyxml       | 7.10    | 0..n        |
 | augment      | 7.15    | 0..n        |
 | choice       | 7.9     | 0..n        |
 | contact      | 7.1.8   | 0..1        |
 | container    | 7.5     | 0..n        |
 | description  | 7.19.3  | 0..1        |
 | deviation    | 7.18.3  | 0..n        |
 | extension    | 7.17    | 0..n        |
 | feature      | 7.18.1  | 0..n        |
 | grouping     | 7.11    | 0..n        |
 | identity     | 7.16    | 0..n        |
 | import       | 7.1.5   | 0..n        |
 | include      | 7.1.6   | 0..n        |
 | leaf         | 7.6     | 0..n        |
 | leaf-list    | 7.7     | 0..n        |
 | list         | 7.8     | 0..n        |
 | namespace    | 7.1.3   | 1           |
 | notification | 7.14    | 0..n        |
 | organization | 7.1.7   | 0..1        |
 | prefix       | 7.1.4   | 1           |
 | reference    | 7.19.4  | 0..1        |
 | revision     | 7.1.9   | 0..n        |
 | rpc          | 7.13    | 0..n        |
 | typedef      | 7.3     | 0..n        |
 | uses         | 7.12    | 0..n        |
 | yang-version | 7.1.2   | 0..1        |
 +--------------+---------+-------------+

argument

notification
	属于netconf协议的，是单独放在一个xml的吗？
	如何去识别属于哪个接口呢？ 命名空间吗？ 

	当notification定义为顶层节点时，编码为 Notification Event Notification, 通知名称的xml标签在最外层。
	当notification定义为子节点时，notification 包含数据存储区中节点的节点层次结构。它必须包含从顶层到包含通知的列表或容器的所有容器和列表节点。最里面的容器或列表包含一个xml元素，名称为notification的名称

identity
	用于定义新的全局唯一，抽象和无类型的身份。 identity唯一目的是表示它的名字，语义和存在。

extension
	extension语句 允许定义语言中的新语句, 可被其他模块导入和使用
	参数是一个标识符, 是扩展名的新关键字，后面必须眼着一个包含详细扩展信息的子语句块。
	目的是定义一个关键字，使用可以被其他模块导入和使用

	可选的argument 语句将一个字符串作为参数，该字符串是关键字参数的名称。如果不存在 argument语句，则关键字在使用是不需要参数。
	这个参数在 YIN映射中使用， 取决于参数的 yin-element 语句，true 表示作为标签， false 表示作为属性。 默认为false

feature
	用于定义一个机制, 通过将schma的部分标记为条件, 能过 if-feature 来引用
	除非netconf-server支持给定的特征方式，否则将忽略使用 if-feature 标记的节点。
	if-feature 使其父语句有条件，参数是feature 名称的布尔表达式, 
	deviate, 定义了目标节点的服务器实现如何偏离其原始定义。参数是 not-supported, add, replace, delete之一。

config 
	config 参数为字符串"true" 或 "false", 为true, 代表配置，表示配置的数据节点是配置数据存储的一部分。 为false, 代表状态数据，表示状态数据不是配置数据存储的一部分。
	如果未指定config, 表示缺省值与父节点的config值相同， 如果父节点是一个case节点， 则该值与case节点的父节点选择节点相同。
	如果顶层节点没有config, 默认为true。 如果一个节点的 config 为true, 那么其了节点都不能将 config设置为true。

	status 声明，参数为字符串 "current", "deprecated", "obsolote" 之一。 默认为"current"
	when 声明， 参数是一个 XPath表达式。
	
rpc
	netconf的rpc定义, rpc, rpc-reply

action

choice
	choice 和 case 节点在xml中都不可见。 

when



### 语法

built-in type 内置类型
+---------------------+-------------------------------------+
| Name                | Description                         |
+---------------------+-------------------------------------+
| binary              | Any binary data                     |
| bits                | A set of bits or flags              |
| boolean             | "true" or "false"                   |
| decimal64           | 64-bit signed decimal number        |
| empty               | A leaf that does not have any value |
| enumeration         | Enumerated strings                  |
| identityref         | A reference to an abstract identity |
| instance-identifier | References a data tree node         |
| int8                | 8-bit signed integer                |
| int16               | 16-bit signed integer               |
| int32               | 32-bit signed integer               |
| int64               | 64-bit signed integer               |
| leafref             | A reference to a leaf instance      |
| string              | Human-readable string               |
| uint8               | 8-bit unsigned integer              |
| uint16              | 16-bit unsigned integer             |
| uint32              | 32-bit unsigned integer             |
| uint64              | 64-bit unsigned integer             |
| union               | Choice of member types              |
+---------------------+-------------------------------------+
typedef 定义结构体类型

- 引用

在不带引号的字符串中，每个字符都被保留



### 总结

libyang 库暂时没有必要移植到c#端，根据yang model, 人工写出xml结构，然后在c#端实现 xml to object 的serial 与 deserial 的操作即可。

看了rfc6020 相关的资料文档，暂时了解到model statement就够实例化出 xml了。
由于是公司的临时项目，纯当开开眼界参与一下，不继续深入了。

### 资料文档
[yang rfc6020](https://tools.ietf.org/html/rfc6020#page-169)
[yang rfc6020 中文机翻](https://blog.csdn.net/ohohoohoho/article/details/52129076)
[yang 1.1 数据建模语言 翻译](https://www.bookstack.cn/read/rfc7950-zh/README.md)
[xml to c# class serial and deserial](https://www.cnblogs.com/guogangj/p/7489218.html)
[netconf event notifications rfc5277](https://tools.ietf.org/html/rfc5277)
