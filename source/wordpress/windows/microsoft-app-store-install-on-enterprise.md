---
title: 在window企业版本安装应用商店 microsoft app store
uuid: 384
status: publish
date: 2020-03-16 15:16:00
tags: windows
categories: Windows
description: 记一次在企业版的windows 10 上安装应用商店的过程及感悟。
---

### 需求背景

想装wsl, 而wsl的下载需要通过应用商店来安装。 
windows 10 ltsc(企业版) 是纯净版本, 没有装应用商店。
且通过应用商店下载的应用相对来说纯净些，因此需要安装应用商店。

在网上搜索相关方法，跟我遇到的问题还不太一样，故记录此过程。

### 过程

网上搜索安装应用商店的方法, 筛选比较靠谱的方法如下：
1. 从[github kkkgo/LTSC-Add-MicrosoftStore](https://github.com/kkkgo/LTSC-Add-MicrosoftStore)下载 [LTSC-Add-MicrosoftStore-2019.zip](https://codeload.github.com/kkkgo/LTSC-Add-MicrosoftStore/zip/2019)
2. 解压LTSC-Add-MicrosoftStore-2019.zip
3. 管理员运行Add-Store.cmd
4. 重启

我在第三步的运行脚本的过程中 Get-AppxPackage 这个命令一直出错。说是无法启动服务
![](https://filestore.community.support.microsoft.com/api/images/6486a9fe-fe31-4a92-8edb-e5943eab63a5?upload=true)
解决这个问题费了老大功夫，最终找到一个[答案需翻墙](https://superuser.com/questions/1456837/powershell-get-appxpackage-not-working#), 记录如下:
```cmd
1. press win + R
2. write regedit
3. press enter
4. goto Computer\HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\AppXSvc
5. on the right hand double click on start
6. put it to 2
7. press ok
8. restart your computer.
```
测试有效, 解决了Get-AppxPackage 命令的问题，再回到 Add-store.cmd命令的执行，就可以安装应用商店了。

### 复盘

解决的方法最终很简单，但是这中间的过程很耗时。
主要还是对于Powershell 的命令知之甚少。 
Powershell 也很强大，命令的出错信息很详细，看日志信息是个很有效的技能, 当然不仅仅是crtl+c, 打开google, crtl+v，还得根据日志信息有所思考。

对于windows 注册表，我要知道如何去修改呢？ 暂无他法，只能根据搜索，按专业人士提供的方法尝试。

根据已有的经验，很多问题确实是改注册表能解决的, 如安装google chrome，点击无反应的时候，也是删除注册表。

windows 的注册表会保存系统应用的配置信息, 状态信息，有些应用的逻辑是通过注册表中的值来执行的。

相当于linux下/etc下的配置信息的角色。
