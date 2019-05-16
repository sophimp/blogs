
## 碎碎念

前期搭建基础的框架就费了2个多月， 效率低得没边, 到现在， 关于音视频的进展基本上没有

不过基础框架搭建也可以复盘，写一写总结, 虽然现在也还是没啥概念

## 需求


1. 描述

在 Android 平台使用 AudioRecord 和 AudioTrack API 完成音频 PCM 数据的采集和播放，并实现读写音频 wav 文件

2. 交付标准
    - AudioRecord 源码
    - AudioTrack 源码
    - PCM 数据 是什么
    - 搞明白音频采集的流程与思路
    - 搞明白音频播放的流程与思路
    - wav 文件的读写有何区别

## 需求细分

1. AudioRecord 

类注释概述

AudioRecord 负责管理音频资源， 从平台音频输入硬件采集音频数据, 通过read()三个方法轮询获取数据。
AudioRecord 在创建的时候，会初始自己的buffer, 用来装采集的数据， 通过构造函数传入 buffSize



使用方法
    查看博客, 根源都是从官方的demo, 或源码中学来的， 先看博客有个大概的概念， 后面再细看源码分析

查看其他api 

AudioRecord 的角色及使用流程

2. AudioTrack

类注释概述

使用方法

3. PCM数据是什么

4. 搞明白音频采集的流程与思路
5. 搞明白音频播放的流程与思路
6. wav 文件的读写有何区别

## 复盘


