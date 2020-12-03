---
title: 抖音逆向分析
date: 2020-12-03 14:00:01
tags: 
- SRE
categories:
- SRE
description: 分析抖音API签名验证算法， X-gorgon
---

### 目标

分析api接口验证规则， 达到模拟请求api的功能。 

抖音版本: v13.7.0

Fiddler4抓包, 查看https header 
```txt
GET https://api5-normal-c-lf.amemv.com/aweme/v1/im/user/active/update/?action=heartbeat&manifest_version_code=130701&_rticket=1606973618429&app_type=normal&iid=2145888160713079&channel=aweGW&device_type=ONEPLUS+A6010&language=zh&cpu_support64=true&host_abi=armeabi-v7a&resolution=1080*2218&openudid=40f8b5a434634c74&update_version_code=13709900&cdid=a50bd51f-04e0-44b1-9926-672c354ffb32&appTheme=dark&os_api=29&dpi=420&oaid=4EDAA33B702F2976635BABC5F2C7A47E89732275A8798E1DA3F8A4BDA609FDF6&ac=wifi&device_id=3394925657863287&os_version=10&version_code=130700&app_name=aweme&version_name=13.7.0&device_brand=OnePlus&ssmix=a&device_platform=android&aid=1128&ts=1606973616 HTTP/1.1
Host: api5-normal-c-lf.amemv.com
Connection: keep-alive
Cookie: uid_tt=5858dbf435c6fd71e34a6a0848d74551; uid_tt_ss=5858dbf435c6fd71e34a6a0848d74551; sid_guard=8a04613ffcb0326982fc7ea70b012e49%7C1605671003%7C4612913%7CSun%2C+10-Jan-2021+13%3A05%3A16+GMT; sid_tt=8a04613ffcb0326982fc7ea70b012e49; sessionid=8a04613ffcb0326982fc7ea70b012e49; sessionid_ss=8a04613ffcb0326982fc7ea70b012e49; odin_tt=3a0d2086e7cf147177332d9e487f97a0117e610bdb44c48480dad37836bdd3821f7343a1be453e0c2ad7810f9d2d5412e98641a96fedb2aaf835abd9e0b2f469; install_id=2145888160713079; ttreq=1$27838938561a4612672f212a3d3d0f86cd27443d
sdk-version: 2
X-Tt-Token: 008a04613ffcb0326982fc7ea70b012e490547103b05b49134f39b9529dba7467f9750024b97afb8c031c677e83b0ccd89b9809593a994a4f7361ee91dfd43c36d789c00a7272e2bcbbe7c6ca57e27ac775a6-1.0.0
passport-sdk-version: 18
X-SS-REQ-TICKET: 1606973618434
X-SS-DP: 1128
x-tt-trace-id: 00-27177a830dc0faab9e034773a83b0468-27177a830dc0faab-01
User-Agent: com.ss.android.ugc.aweme/130701 (Linux; U; Android 10; zh_CN; ONEPLUS A6010; Build/QKQ1.190716.003; Cronet/TTNetVersion:58eeeb7f 2020-11-03 QuicVersion:47946d2a 2020-10-14)
Accept-Encoding: gzip, deflate, br
X-Khronos: 1606973618
X-Gorgon: 040480120001a15e534c472cfb792c713a6c7d761cad9e6eed68
```
其中自定义的字段:

X-Tt-Token,	X-SS-REQ-TICKET,  X-SS-DP, x-tt-trace-id, X-Khronos, X-gorgon,

在jadx中反编译apk, 然后逐个搜索，根据代码推测/猜测作用
X-Tt-Token,
x-SS-REQ-TICKET, 时间戳
X-SS-DP, 一直没有变，此版本java层已经搜索不到， 应该在so库里  
x-tt-trace-id, 从服务器响应中拿到的, 
X-Khronos, 时间戳， 此版本java层已经搜索不到， 应该在so库里
X-gorgon, 校验算法签名， 此版本java层已经搜索不到， 应该在so库里

有了cookie，就可以模拟请求了， 不带这些自定义的参数也没事？ 那这些自定义的参数只在关键的接口中起作用？ 

哪些是关键的接口呢？

逆向还是得有目的去搞。 
