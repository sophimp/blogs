---
title: init.rc 语法解析
date: 2019-06-19 18:42:00
tags: 
- initrc
- rom
categories: 
- Android
description: rom 移植最怕的就是启动不了， 拿不到启动日志，只能从各个可能的环节去分析， init.rc 是内核启动init加载的脚本，控制了系统启动过程中加载的服务。 
---

## init.rc

    文档在       system/core/init/readme.txt 

    init.rc 位于 system/core/rootdir/init.rc 
              和 bootable/recovery/init.rc
              由 system/core/init/init.cpp 加载

## 语法

	Actions, Commands, Services, Options, 
	以行为单位, 各种记号以空格来隔开
	反斜杠可用于记号间插入空格, 字符串格式也可以防止被分割成多个记号
	行末的反斜杠用于分行, 注释以#号开头, 允许空格

	Actions 和 Services 声明一个新的Section

Actions
------

定义一些命令, 由事件触发器或属性触发器来执行

```
on trigger && [<trigger>]
    <command>
    <command>
    <command>
    ...
```

Services
------

Services是一个程序, 由init进程启动, 一般运行于init进程的子进程, 启动时会通过fork 方式生成子进程. 启动之前会判断文件是否存在

```
service <name> <path-name> [argument]
    option
    option
    ...
```

Options
------

决定如何以及何时去运行service

    critical
        device-critical 超过4次, 设备会重启进入recovery

    disabled                
        不会自动启动, 需要显示通过名称启动

    setenv <name> <value>   
        在launched 进程设置环境变量

    socket <name> <type> <perm> [<user> [<group [<seclabel]]]
        在launched 进程通过 fd 创建一个domain socket 名为 /dev/socket/<name> 
        <type> 必须为dgram, stream, seqpacket 其中一个

    user <username>
        在执行当前服务前, 改变username

    group <groupname> [<groupname>]* 
        在执行当前服务前, 改变groupname, * 在这里是什么意思呢? 

    seclabel <seclabel>
        在执行当前服务前, 改变seclabel

    oneshot 
        服务已存在, 不重启

    class <name> 
        为当前服务指定一个类

    onrestart
        在一个服务重启时, 执行下面的命令

    writepid <file...>
        写child pid 到 forks 时的files


Triggers
----- 

一个Action 只能有一个事件trigger, 可以有多个属性trigger

    boot                    
        init.rc 装载后触发

    device-added-<path>     
        指定设备被添加时触发

    device-removed-<path>   
        指定设备被移除时触发

    service-exited-<name>  
        在特定服务退出时触发

    erly-init               
        初始化之前触发

    late-init               
        初始化之前触发

    init                    
        初始化时触发(在/init.conf 被装载之后)

Commands
------

    bootchart_init

    chmod <octal-mode> <path>

    chown <owner> <group> <path>

    class_start <serviceclass>

    class_stop <serviceclass>

    class_reset <serviceclass>

    copy <src> <dst>

    domainname <name>

    enbale <servicename>

    exec [ <seclabel> [ <user> [ <group>  ]* ] ] -- <command> [ <argument> ]*

    export <name> <value> 

    hostname <name> 
        设置hostname

    ifup <interface> 
        上线 interface 网络

    insmod <path> 
        安装module 到 path

    load_all_props

    load_persist_props

    loglevel <level> 

    mkdir <path> [mode] [owner] [group]

    mount_all <fstab> [ <path>  ]* [--<option>]

    mount <type> <device> <dir> [ <flag>  ]* [<options>]

    powerctl

    restart <service>

    restorecon <path> [ <path>  ]*

    restorecon_recursive <path> [ <path> ]*

    rm <path>

    rmdir <path> 

    setprop <name> <value>

    setrlimit <resource> <cur> <max> 

    start <service>

    stop <service>

    swapon_all <fstab>

    symlink <target> <path>

    sysclktz <mins_wset_of_gmt>

    trigger <event>

    unmount <path>

    verity_load_state

    verity_update_state <mount_point>

    wait <path> [ <timeout> ]

    write <path> <content>

Imports
------

    import <path> 


Properties
------

    init.svc.<name>


Bootcharting
------

Systrace
------

Debugging Init
------

默认加载init的时候不存日志, 都定向到了dev/null

service akmd /system/bin/logwrapper /sbin/akmd
可以重定向到android logcat


