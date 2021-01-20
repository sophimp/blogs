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


### 总结

libyang 库暂时没有必要移植到c#端，根据yang model, 人工写出xml结构，然后在c#端实现 xml to object 的serial 与 deserial 的操作即可。

看了rfc6020 相关的资料文档，暂时了解到model statement就够实例化出 xml了。
由于是公司的临时项目，纯当开开眼界参与一下，不继续深入了。

### 资料文档
[yang rfc6020](https://tools.ietf.org/html/rfc6020#page-169)
[yang rfc6020 中文机翻](https://blog.csdn.net/ohohoohoho/article/details/52129076)
[yang 1.1 数据建模语言 翻译](https://www.bookstack.cn/read/rfc7950-zh/README.md)
[xml to c# class serial and deserial](https://www.cnblogs.com/guogangj/p/7489218.html)
