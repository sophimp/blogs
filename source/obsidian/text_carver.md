---
title: 雕梦(TextCarver) - 富文本编辑器：设计思路
date: 
uuid: 
status: draft
tags: 创业
categories: 杂谈, 随笔
description: 
---
# 雕梦 TextCarver

富文本编辑器，支持 markdown 

logo 设计， 刻刀， 星辰大海

# road map

先实现一个纯纯写作
markdown 编辑, 渲染

先分开也无所谓，后续有能力了再写所见即所得的版本

工程搭建，有必要搞一个模板工程出来

# 需要解决的痛点

所见即所得的效率问题

图片
音频
视频
只能使用html了

表格实现

移动端键盘适配问题

# 看源码记录

TextFieldValue:  编辑state
	持有 selection, cursor, text, text composition

AnnotatedString: 
	toAttributedString
	toComposeString

input service: 
	负责TextFieldValue

TextRange

