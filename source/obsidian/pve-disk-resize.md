---
title: pve disk resize
date: 2022-09-20 01:38 
tags:
- PVE
categories: 
- PVE
description: PVE 磁盘扩容
---

1. 相关命令

```sh

# blk -> block
lsblk

pvdisplay
vgdisplay --units B
lvdisplay
pvcreate /dev/sdb1
vgextend ububtu-vg /dev/sdb1

lvresize -L [size] [vg name]
resize2fs [vg name] 



```

## 资源

1. [PVE虚拟机 – 如何扩容虚拟机磁盘空间？](https://yuerblog.cc/2020/02/09/)

