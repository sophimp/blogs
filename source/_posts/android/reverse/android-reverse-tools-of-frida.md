---
title: Android逆向工具之 --- Frida
date: 2020-09-16 09:49:27
tags:
- Android逆向
- 逆向工程
- 逆向工具
categories:
- 逆向工程
description: Frida工具很强大，github上Frida项目每次发布能有那么多的包， 有必要系统学习一下Frida工具。
---

### Frida 架构

### 环境

以Andoroid平台为例

直接看[gituhb readme](https://github.com/frida/frida)

发布包的作用
| 名称 | 作用 | 
|:--:|:--:|
| frida-clr | <++> |
| frida-core-devkit | <++> |
| frida-gadget | 一个共享库，可以在不支持injected操作模式的情况下, 由要检测的程序加载 |
| frida-gum-devkit | <++> |
| frida-gumjs-devkit | <++> |
| frida-inject | <++> |
| frida-qml | <++> |
| frida-server | 放在被hook的平台上, 是一个可执行程序 |
| frida-swift | <++> |
| frida-electron | <++> |
| frida-node | <++> |
| frida-iphones | <++> |
| python3-frida | <++> |

自编译各平台的包

### 使用技巧

### 资料
[官方文档](https://frida.re/docs/home/)
