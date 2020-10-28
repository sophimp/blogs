---
title: Android SELinux 系列(二) TE语法
date: 2020-10-13 11:36:57
tags:
- SELinux
- Android
categories:
- Android
description:
---

### m4及其宏编译器

[m4语法文档](https://www.gnu.org/savannah-checkouts/gnu/m4/manual/m4-1.4.18/m4.html#Manual)

了解规则即可， 常用的
命令: type, allow, transit
权限: open, read, write, create 等 

注意，字符串使用的是 '`, 单引号的前半部分， 和反引号(键盘左上解与~一起的键)

为何会选m4语言
	通用性好

关键还是实战，m4相对于Android, 就看[SEAndroid的文档](https://source.android.com/security/selinux/customize)实战， 用到哪查到哪， 知道怎么一回事即可干活。
