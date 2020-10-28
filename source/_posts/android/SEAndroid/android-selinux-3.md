---
title: Android SELinux 系列(三) RawSocket权限提升实战
date: 2020-10-13 11:37:24
tags:
- SELinux
- Android
categories:
- Android
description:
---

## raw socket ipv6 的demo示便

### 基本思路
	
	SEAndroid框架是AVC(Android Vector Cache)

	使用SEAndroid修改权限， 主要就是查看调用api不成功系统的avc的日志， 定位相关的te文件， 或者添加新的te文件， 编译。
	如果编译不通过， 再接着看编译的日志，定位到相应的文件，删除或屏蔽报错对应的代码即可。

### 错误解决

> type=1400 audit(0.0:1237): avc: denied { create } for scontext=u:r:untrusted_app_25:s0:c512,c768 tcontext=u:r:untrusted_app_25:s0:c512,c768 tclass=packet_socket permissive=1

在system/sepolicy 下搜索 untrusted_app_25.te， 然后添加
```te
allow untrusted_app_25 untrusted_app_25:packet_socket { create };
```

编译会出现以下问题

> bsepol.report_failure: neverallow on line 72 of system/sepolicy/private/app_neverallows.te (or line 22629 of policy.conf) violated by allow untrusted_app_25 untrusted_app_25:packet_socket { create };
libsepol.check_assertions: 1 neverallow failures occurred
Error while expanding policy

在 system/sepolicy/private/app_neverallows.te 文件的72行，去掉packet_socket的限制
这样的错误， 根据报错的日志来修改， 好像问题也不大


