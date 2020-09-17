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

### Frida 简介

#### Frida 是什么

It’s Greasemonkey for native apps, or, put in more technical terms, it’s a dynamic code instrumentation toolkit. 
Frida 是用于原生apps 的Greasemonkey(是一个脚本框架)，或者换句话说， 它是一个动态代码检测工具包。它可以让你注入javascript代码片段或者定制的库代码到Windows, MacOS, GNU/Linux, Android 和 QNX 这些系统的应用中。 
Firda 也提供了一些基于Frida API 的简单工具。 这些工具这可按原样使用， 根据需要进行调整， 或者用于教学如何使用API。

#### 使用场景

* 有一个热门的IOS应用， 你想与其交互，但是它的网络协议都加密了，使用wireshark之类的抓包工具并不能搞定，这时候就可以使用Frida来进行API跟踪。

* 如果一个已经发布到外网的应用出了问题， 但是发布版本的log日志不够详细。这个时候你不必再重新构建一个新版本进行发布， 只需要使用Frida简单写几行Python 代码做一个工具，在任何你需要诊断的位置加上日志。这个工具可以工作在多个版本的应用上(只要hook的api没有变化的版本都可以使用)。

* 比如在steroids上构建一个Wireshark 用作加密网络嗅探，不必去搭一个测试实验环境，可以使用Frida 修改函数去伪造网络条件。

* 内部应用程序可以使用一些黑盒测试(Frida搭建), 这样能避免测试代码污染生产代码。

#### 为何使用Python API， 但是使用Javascript来写调试逻辑?

frida-core 使用C语言编写的, 并在目标进程中注入了 google v8引擎(用于解析javascript)，这样，在目标进程中, js代码就可以在进程中访问所有的内存空间，hook函数，甚至可以调用本地方法。 

使用python 和 js 可以使用无风险api进行快速开发。 Frida可以方便的捕捉到js的错误并提供异常信息而避免于应用崩溃。

当然，如果对python 不熟悉， 也可以直接使用C编写，基于 frida-core, 也同样绑定了Node.js, Python, Swift, .Net, Qml 等语言，同时也很容易绑定其他的语言和环境。 

#### Frida 是如何注入到进程的呢？ 

进程必须要有调试权限，否则不可被注入, 

### 环境搭建

* 安装

可参考[gituhb readme](https://github.com/frida/frida)
在archlinux 上
```sha
# 先要安装 python3, 和nodejs
yay -S python nodejs

# 再使用 pip 安装 frida frida-tool, 这里需要换下国内的代理或者翻墙， 下载比较慢，失败了就再来次
# frida-tool 是cli工具, frida 与python 绑定
pip install frida frida-tool

# 使用npm 安装 frida, 这一步是与 Node.js 绑定
npm install frida

# 再根据 frida --version 的版本 在github的release版本中下载对应的平台的frida-server
```

* 测试
可以在本机上进行测试, linux下平台可以注入 cat进程， windows平台可以注入 notepad++ 进程

以linux平台为例, 在一个终断，开启 cat 进程
```sh
cat 
```
将如下测试代码保存在一个example_frida.py中
```python
import frida

def on_message(message, data):
    print("[on_message] message:", message, "data:", data)

session = frida.attach("cat")

script = session.create_script("""
rpc.exports.enumerateModules = function () {
  return Process.enumerateModules();
};
""")
script.on("message", on_message)
script.load()

print([m["name"] for m in script.exports.enumerate_modules()])
```
另开一个终端
```sh
# 先使能进程的ptrace属性
sudo sysctl kernel.yama.ptrace_scope=0

# 再运行测试代码
python example_frida.py
```
看到类似如下输出即环境可用
```
[u'cat', …, u'ld-2.15.so']
```

各发布包的作用
| 名称 | 作用 | 
|:--:|:--:|
| frida-clr | .Net 绑定库 |
| frida-core-devkit | C语言编写的 frida 核心开发库, 支持Window, MacOS, Android, IOS, arm与x86平台 |
| frida-gadget | 一个共享库，可以在不支持injected操作模式的情况下, 由要检测的程序加载 |
| frida-gum-devkit | C语言编写的跨平台检测和自省库, frida-core依赖此库实现了JavaScript的绑定库 frida-GumJS|
| frida-gumjs-devkit | Javascript 绑定库 |
| frida-inject | <++> |
| frida-qml | qml 绑定库 |
| frida-server | 放在被hook的平台上, 是一个可执行程序, 通过TCP将frida-core的能力暴露给电脑端 |
| frida-swift | swift绑定库 |
| frida-electron | 使用electron 为frida提供的图形界面 |
| frida-node | Node.js 绑定库 |
| frida-iphones | <++> |
| python3-frida | python3 绑定库 |

自编译各平台的包

### 操作模式

* 注入(Injected)

将一个现有的程序附加到一个正在运行的程序中, 或者劫持一个正在生成的程序，在其中运行自己的检测逻辑，这种行为就是注入。
是通过frida-server运行在IOS或Android手机中，frida-server 本质上是一个伺服进程, 能过TCP 将 firda-core的能力暴露给客户端。

* 嵌入(Embedded)

嵌入模式是无法使用注入模式的情况下(如IOS无法越狱，Android无法root)检测程序的一种方式。 
这个时候，可以通过在需要检测的程序中嵌入 frida-gadget 共享库,  在加载这个共享库的时候，就可以通过Firda工具(如frida-trace)待检测程序远程交互。
frida-gadget 提供一种完全自主的方式在文件系统外运行脚本，而无需任何外部通信。 

* 预加载(Preloaded)

frida-gadget 同样也提供了从文件系统加载脚本来自动运行的能力，需要配置相关设置。

### Gadget

frida-gadget 是一个共享库，在注入模式不可用的时候，由需要检测的程序集成加载。

### Hacking

### Stalker

Stalker 是一个代码跟踪引擎。
更说细的介绍请查看 {% post_link android/reverse/android-reverse-tools-for-frida-stalker %}
### 资料
[官方文档](https://frida.re/docs/home/)
