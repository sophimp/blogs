---
title:  dex 反编译工具
date:  2019-09-17 17:59:46
tags:
- Android逆向
- Android
categories:
- Android
description: 工作中需要telephony 下隐藏的类，因此需要重新制作android.jar，现整理以前blog, 环境又发生了变化，这里仅仅是记录一上小技巧，然而接下来要全面学习Android 逆向的知识。留坑。
---

## linux dex2jar

经常要打包 telephony.internal 下的类, 从源码中编译出来的telephony-common.jar 解压出来的是 dex 文件
因此, 需要将其转其jar

linux 下的 [dex2jar](https://github.com/pxb1988/dex2jar) 是开源的代码

自编译的dex2jar 全是java 代码, 需使用脚本, 也有发布的脚本, 将启动jar 的命令封装起来, 然后再添加一个软链接到PATH中, 就可以正常使用了.

## android 的vdex 

使用 [anestisb/vdexExtractor](https://github.com/anestisb/vdexExtractor), 先将 vdex 转成 dex, 再使用dex2jar 转成jar

享受开源的便利, 同时当然要回馈开源社区. 

