---
title:  Android 架构分析
date: 2019-05-29 17:37:24
tags:
- 架构
- Android
categories:
- Android
description: 实践了Nubia Z18mini 的移植, 知道了Mokee, Lineage, 对于aosp了解更深了一些，然而移植到Redmi K30 pro 又卡住了，ROM 移植没有那么简单，因此系统分析Android框架是接下来很有价值的事情，在此占个坑， 后续再补上。 
---

## Project Treble

统一了 vendor implementation, 不用每一次更新版本, 都要再实现一遍

一致的接口的重要性, CDD(Compatibility Definition Document), 统一的接口测试 cts

Soc (System on a Chip), 

在8.0以后开始使用

## Android 架构
1. HAL 类型

    提供了关于绑定式 HAL、直通 HAL、Same-Process (SP) HAL 和旧版 HAL 的说明。

2. HIDL（一般信息）

    包含与 HAL 和其用户之间的接口有关的一般信息。

3. HIDL (C++)

    包含关于为 HIDL 接口创建 C++ 实现的详情。

4. HIDL (Java)

    包含关于 HIDL 接口的 Java 前端的详情。

5. ConfigStore HAL

    提供了关于可供访问用于配置 Android 框架的只读配置项的 API 的说明。

6. 设备树叠加层

    提供了关于在 Android 中使用设备树叠加层 (DTO) 的详情。

7. 供应商原生开发套件 (VNDK)

    提供了关于一组可供实现供应商 HAL 的供应商专用库的说明。

8. 供应商接口对象 (VINTF)

    提供了关于收集设备的相关信息并通过可查询 API 提供这些信息的对象的说明。

9. SELinux for Android 8.0

    提供了关于 SELinux 变更和自定义的详情。

## 自定义构建嵌入式android 系统

将自己的修改添加到aosp 中

根文件布局系统

自定义的init

android 框加是如何启动的

hidl, binder, aidl 是如何通信

