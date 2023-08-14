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

为什么没有人将intellij-community 的editor拉出来，基于此做编辑器呢？
需要做一个word吗？ 没有必要，图片的拖动只需要在段落间实现即可，或者不实现也行。
我的竞争点在哪里？ 工具的整合，缝合？
首先是备份的问题，终身资产，需要普及一下备份的思路，解决备份过程中带来的麻烦, 少操作步骤, 时间多点也无所谓。
这一点也有可能比较难？ 操作系统会备份的又有多少呢？ 这个门槛可能高一些

再一个就是全面？ 将RSS, 书籍阅读， 写作合起来， 是不是一个工具流更加高效呢？ 这时候主要存在一个切换的问题
有的时候，分开反而是更高效的，但是可以将数据的形式统一起来。 
也可以参考操作系统级的后台应用切换，应用大而全的时候，使用快照技术, 提供一个后台快照的预览以供选择。
移动系统通过手势，唤出菜单，PC可以通过快捷键, PC上提供全局按钮相对也快速一些。

AI的结合： 肯定不能仅仅是一个套壳，将自己的数据结合起来

我的目标人群是什么？
优先于肯动手的，肯折腾的输出人员。

后续再考虑开箱即用，与折腾间，是否需要平衡。

# 需要解决的痛点

所见即所得的效率问题

图片
音频
视频
只能使用html了

表格实现

移动端键盘适配问题

# 看源码记录

- 我想搞懂什么？

layout布局的思想
行，段落的控制
(富)文本的渲染，不一定非得涉及各国的文字，各种编码上的坑，但是需要了解到主流的2种
效率的瓶颈, 加载大文本的临界点, 带有富文本，渲染字数的临界点
我的目标是想做到多大的富文本有效率呢？ 10万字，基本上满足大部分场景了吧
如何设计表格，插入音视频，附件呢？
我如何将我的想法写下来，就是一个问题，先写下来，不要有心智负担，然后再用gpt帮忙润色试一试。

TextFieldValue:  编辑state
	持有 selection, cursor, text, text composition

AnnotatedString: 
	toAttributedString
	toComposeString

input service: 
	负责TextFieldValue

TextRange

BasicTextField
	这个才是基本的Text input 控件
	为什么他们看源码就能那么快呢？是我太不用心了？ 

TextLayoutInput

TextLayoutResult

TextDelegate

	将 texts 画到 canvas 上
	为什么非得有一个delegate模式？有太多的角色，使用代理，方便扩展
	
	传入 AnnotatedString
	调用 layout 布局，分段
	调用 paint 画到canvas
	
Modifier 大有玄机

	并不只是用来包装尺寸样式， 构建LayoutNode tree, 绘制，都是由Modifier来调度的？ 
	尺寸与样式，这些是由 Modifier.Element 来承载, 装饰或者添加行为
	最后会合理地生成一系统 Modifier.Node

	具体是怎么测量的，需要测量多少遍, 是在mergeLayoutNode过程中测试的么？

	Modifier 相当于一个中间层，这里面总得有一个中间层来负责连接各方的抽象
	我想找的就是连接点在哪里

	SemanticModifier 
	
LayoutCoordinates

	rootCoordinates
	parentCoordinates
	windowCoorodinates

	knm 是 nativce代码反编译
	看compose代码还是需要在纯Android平台看，在跨平台项目，只会定位到 common expect 函数, 各平台具体的实现就不清楚了

	Offset, Size

Composer 

	提到渲染， 还是脱离不了Compose运行时
	为什么不学习跨端呢？ 跨端技术还是值得学习的
	

DrawerScope, LayoutNodeDrawScope

Canvas, NativeCanvas


Applier 最还是调用 root(LayoutNode)的能力


