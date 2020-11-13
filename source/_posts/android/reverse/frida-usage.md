---
title: frida使用
date: 2020-11-12 17:21:16
tags:
- Frida
- SRE
categories:
- SRE
description: firda很强大, 使用起来的脚本语言
---

### 安装
1. 预安装二进制包
```sh
pip install frida-tools # CLI tools
pip install frida       # Python bindings
npm install frida       # Node.js bindings
```
2. frida-server 与 frida-client
[官方Android示例](https://frida.re/docs/android/)
先下载最新的[frida-server](https://github.com/frida/frida/releases) 并解压, 然后将解压后的frida-server放在Android中/data/local/中运行
```sh
unzx frida-server.xz
```

3. 使用
```
# 使用这条命令经常会让程序重启挂死
frida -U -f <process_name> -l <script>

# 使用这条命令就很安全
frida -U -F -l <script>
```

frida命令须带脚本执行，去掉-l, 所有的app都会黑屏。

### 框架

源码地址 https://github.com/frida

frida 核心还是 typescript, python脚本可以套一个壳子将 上述的命令操作代替了脚本

CMoudle 是javascript壳子里面套 C代码

所以直接看JavaScript的API即可。 

frida知道框架是咋回事了， 看看api提供了哪些能力， 也能对逆向的整体知识有个概念

### JavaScript API
0. Runtime information

1. Process, Thread, Module and Memory

Process

Module

ModuleMap

Thread

hexdump

Memory

MemoryAccessMonitor

ApiResolver

DebugSymbol

Kernel

2. Data Types, Function and Callback

3. Network

4. File and Stream

5. Database

6. Instrument

7. CPU Instruction

8. Other
