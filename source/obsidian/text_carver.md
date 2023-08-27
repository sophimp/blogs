---
title: 雕梦(TextCarver) - 富文本编辑器：设计思路
date: 
uuid: 
status: draft
tags: 编辑器
categories: 
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

2023-08-25 17:17
当前 工程已经能跑通了, 好像不是特别卡, 但是在有 selection 的情况下, Android 上滑动会卡
基本的开发套路已经知道的差不多了, 框架怎么搭呢? 
先采用我最熟悉和便利的方式
做事情, 优先级最高的是先做出来, 其次是效率优化. 
还没有做, 卡在效率上太长的时间了. 
这样打字好不好? 所以, 还是换一个无声的键盘更好一些. 

# 需要解决的痛点

所见即所得的效率问题

图片
音频
视频
只能使用html了

表格实现

移动端键盘适配问题

## 任务拆解

任务拆解后的痛点：

	文本形式不好跟踪, 先使用搜索用着

	任务太多，一段中断后，再次恢复, 短时间难以读档

		这个没办法，工具只是辅助，最终还是要靠大脑进行调度
		所以，工具的能力需要提升，大脑的能力也需要锻炼
	

环境配置

	android
		compose-bom 能否应用到 desktop上？应该是不行的，包名都不一样
	desktop
		有没有compose-bom 之类的迁移, android 与 desktop 的 compose 版本是否可以不一致？
		common 的依赖应该还是 compose-jb 的版本

	版本控制是一麻烦事, 如何更好地解决

结合obsidian 与 pure write 的特性，开始仿照自己的编辑器



Compose Text 源码研究

	所谓的黑科技，不过是源码看得多一些，但是根本的渲染逻辑还是没有到那一层啊, 至少目前从文章上来看，还是处于应用层, 至于是否影响到效率，没有写出来

看源码之前, 先用起来， 遇到问题再深入源码，更方便一些

	现有的源码是基于 jetbrains-markdown, 我更倾向于 commonmark


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

BaseTextField2 
	基于BasicText 开发的，暂时也用不上

# 疑问
最主要的还是state的变化

创建了那么多的 text copy, 在内存里会不会存在多份呢？ 这样的话，打开大文件，也是个笑话
如果能满足5万字内的文章的话, 日常使用倒是也够，性能不存在问题的话，倒也可基于此做一个优秀的编辑器。
但是如果用其来做编辑器，那就不一定好使了。
所以，使用compose来做一款高性能的编辑器，有难度啊, 纯文本编辑器，那还是不一样的。

为什么他们做软件，都想将用户限制在软件里, 不提供导出通用格式的方式呢？ 
赚不来钱吗？ 
软年封闭了，就没了生命力了。

