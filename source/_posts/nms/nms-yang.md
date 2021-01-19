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
yang 是数据建模语言， 主要还是承载数据信息的。

为什么
yang model 为程序提供了一致的操作数据的接口， 解决了配置读写困难的问题。
使用yang模型建模, 可以利用yang模型完成数据合法性的检查，保证风格一致性，不需要应用程序直接操作文件。

### 标识符

### 语法

### 总结

### 资料文档
[yang rfc6020](https://tools.ietf.org/html/rfc6020#page-169)
[yang rfc6020 中文机翻](https://blog.csdn.net/ohohoohoho/article/details/52129076)
[yang 1.1 数据建模语言 翻译](https://www.bookstack.cn/read/rfc7950-zh/README.md)
