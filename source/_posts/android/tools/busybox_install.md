---
title: Busybox 安装
date: 2019-10-30 18:10:05
tags:
- busybox
- Android
categories:
- 工具
description: android 上安装busybox, 丰富命令行命令
---


## 下载busybox

[busybox下载](https://www.busybox.net/downloads/)

## 安装

root 系统

将busybox push 到 /system/xbin 下, 执行 ` busybox --install . `

## 背景

由于刷机努比亚z18 mini, 导致相机启动不起来, 同样的mokee rom 在另一台手机上可以. 

mokee rom 刷机不更新 vendor分区, 那么出问题的也只能是vendor分区. 印中有一次格式化过vendor分区, 虽然再使用官方的安装包安装, 但是官方的rom 也不能打开camera了

那么将vendor分区的文件都替换一下试试. 

需要将vendor分区挂载为 rw, `mount -o remount,rw /vendor`

在android 里没有找到 etc/fstab, initramfs 是放到 boot.img 或 system.img中了. 

重新挂载完 /vendor 分区果然可以复制了, 但是出现了部分text file is busy. 

搜索可知, fuser 可以查看是哪个进程占用, 因此需要安装busybox. 

如上, 安装完busybox, 果然可以查看到哪里占用了. 于是根据日志中报 Waited one second for android.hardware.camera.provider@2.4, 这个so库是放在 vendor/bin/hw中的, 在复制vendor的时候, 这个文件也有占用. 

使用fuser 查找哪个线程占用, kill -9 之, 发现camera 还真可以用了, 至此看到了希望, 连短信的功能也好了. 

于是赶紧重启一下, 问题还是没有得到解决, 这个时候猜测, 问题应该出现在整个vendor环境, 在初始化过程中, 哪个环节出问题了. 

那么就整体替换 vendor 分区的文件吧. 将功能完好的手机中的vendor 全部dump下来, 先复制到手机中, 再通过adb pull 文件, 竟然pull不下来. 

接下来第一条路就是 使用zip, 这里又要另一台手机安装busybox, 在recovery 下安装, 又出现了cross device link 错误, zip 还是不可以用. 
搜索解决cross device link, 在csdn 上看了一个不行, 暂不想直接解决此问题

那么重启到系统中试试呢? 
重启到系统中可以安装成功, 想想也是, recvoery 也相当于一个小系统, 所以在recvoery下挂载的其实是recovery 的system.img 
recovery 下已经有部分busybox 所以安装会有冲突, 

在system rom 下不能dump /vendor分区, 没有权限, 即使得新挂载 rw 也没有权限, 这个是因为在initramfs 中挂载的时候限定了分组. 但是在recvoery 下重新挂载vendor是可以copy的, 这样可以推测, 在system rom下, 再次将 vendor 的block 挂载到另一个文件夹下, 也可以copy了. 

真不行, 再搜索一下 adb pull 是不是就不可以拉文件夹? 
adb pull 接文件, 不带其他参数, 拉不下来子文件夹或symbol links, 所以还是用tar 打包, tar 可以打包symbol links, zip 得带参数. 

最终解决了nubia z18mini camera 有问题的这一台手机, 将 /persist, /dsp, /bt_firmware, /firmware 都完全copy过来了, 然后就ok了. 
这也可以证明, 在recovery模式下, 是可以做任何事的. 只要可以完全操控磁盘, 那么理论上跟改二进制一样, 可以修改磁盘上任意字节, 就可以重塑一个系统环境出来. 

