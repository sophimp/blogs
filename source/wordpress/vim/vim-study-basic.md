---
title: vim 学习系列之(2) -- vim 基础操作
uuid: 369
status: publish
date: 2020-08-20 16:16:18
tags: Vim
categories: Vim
description: vim 的基础操作是难度的开始，与大多数图形界面的编辑器都不一样，因此，首先习惯使用vim编辑日常文档， 是学习vim的第一步。
---

### 基本配置

网上的vim 配置教程大都只是配置一些插件，注释说明选项什么意思， 这样的教程就落了下乘，因为我按那些大神的vim配置用了这么多年，还是个半吊子水平， 当然，这跟我自己的学习态度也有关系。直接`:help` 看 vim文档，英文能力也有限，经常效率不高，看着看着就睡着了(提升英文能力很重要, 这是后话，另作他表)。 对于一个没有编程经验的小白来说，一个好的本土语言的教程，确实能帮助期少走很多变路。 

现在有了一些开发经验后，再学习vim, 就相对容易一些。 
一个系统(提供了插件扩展能力的应用都可以以称作一个系统)必然会提供一个上下文环境，上下文环境又是与生命周期概念， 所以，学习vim配置，最好还是从生命周期，上下文环境(运行时环境)，插件的加载层次这些信息来入手，更加能抓住主干核心， 对于学习新插件，自己开发插件， 也是必不可少的。 

基本配置的思路:

1. 默认变量
	设置默认变量的变量通过 set 命令, `=` 号两边不能有空格
	查看所有的默认变量通过 `:options`命令
	查看每个变量的详细介绍通过 `:help <variant>` 命令

2. 快捷键
	快捷键的本质思想是将常用的，较复杂(超过3次按键)的操作简化成键程更短, 双手配合更方便的两键,三键或四键。
	
	快捷键涉及到的命令字有: 

	|命令字|备注|
	|:--:|:--:|
	|map| 递归的映射|
	|unmap|删除某个映射|
	|mapclear| 清除映射 |
	|noremap|no recursive map, 非递归的|
	|inoremap| insert  模式下 |
	|nnoremap| normal  模式下 |
	|vnoremap| visual + 选择模式下 |
	|cnoremap| command 模式下 |
	|snoremap| 选择模式下 |
	|slient| <++> |
	|autocmd| 事件监听命令，一般格式为 <br/>:autocmd [group] {events} {file_pattern} [++nested] {command} |
	|<tab> | <++> |
	|<CR>  | <++> |
	
	选择模式: select mode , 类似于windows 的选择模式
	进入选择模式的几种方法:
		1. 使用鼠标选中一块区域，同时selectmode 包含 mouse
		2. 按下shift键的同时, 键入不可显示的光标移动命令, 同时 selectmode 选项包含key
		3. 键入v, V, 或 ctrl + v 命令， 同时selectmode 包含 cmd
		4. 在可视模式下键入 gh 或 gH, g_crtl-H
		5. 在可视模式下键入 ctrl + G

3. 函数

	这就涉及到更具体的开发技能了，脚本语言在nvim 更加开放。
	函数的编写先不必强求，可以看懂个大概, 先将别人的用起来， 待互联网搜索满足不了需求的时候，再思考着去定制。 
	vim 的插件也是定制函数的集合

折腾了一番， 最终还是觉得 skywind3000 的配置要牛逼得多， 不论是架构, 还是功能完善程度。

之前已经尝试过从解读源码来学习韦易笑大婶的配置，详情请点{% post_link cpp_env_setting %}, 当时能力有限，很多配置还是看不懂。经过这一番折腾感觉自己好像又能看懂源码了， 那么继续站在前辈的肩膀上继续学习vim吧。 

决定继续分析`skywind3000/vim`框架，定一个小目标: 在分析其源码的同时， 更新完善readme文件, 然后提PR。

更主要的是将学习vim, 分析的思路记录下来， 以便于抓住学习的本质， 帮助更多的初学者， 降低学习vim的门槛。

又发现了 skywind3000 又配置了一个[vim-init](https://github.com/skywind3000/vim-init)供新手学习， 这可是真得很友好了，韦易笑大婶真是非常良心了。
结合这个初学者的项目， 系统的学习一下vim。

### 如何看手册

记录手册中的一些规则，真正学起来，vim 也不是那么难了, 最主要的还是为什么要学的问题。解决不了为什么要学的问题，就很难静下心来，花一两个月的时间去系统的学习， 因此，在使用的过程中就完全受阻了。 

[vim 文档中文手册](https://github.com/yianwillis/vimcdoc)
将vim的手册换成中文版，哪个保留字不懂，便使用 :help 命令, 将大大提升vim 的学习效率。

在收集资料的过程中， 发现了那么多人为vim 学习与普及做了很多工作，为何使用vim的人还那么少呢？ 
这其实就与个人态度有关了。 大部分人的工作情况都是能用就行， 完成工作了， 不工作的时间就是自己的时间了, 因此，很多工作之外的工作，就与我无关了。然而， vim 能提升的工作效率，也是非常可观的， 我个人觉得， 工作与生活，没有必要刻意地完全的分开，也不可能完全割裂开, 工作本就是生活中的一部分。
我一贯主张的理念是条条大路通罗马，知识的理念是相通的，学习是一辈子的事情，所以，生命中做得每一件事，都是学习的途径，都值得去思考。
学习是消耗精力的，所以大脑在很多时候就会将学习趋向于习惯，因此会形成舒适区。
大脑将学习的过程趋向于习惯，这在一开始的时候的表现大多都是懒与拖延症，因为开始学习某项技能的时候，相关领域的未知知识是最多的，脑力的消耗也是最多的。接受这一事实， 在开始的时候，跳出舒适区相对来说就没有那么痛苦了，因为心中有底，相信过一段时间就会有所改善。 随着技能积累的多了，排列组合的可能就多了，因此创新的方向就多了。这是知识良性正循环。 

得， 又说了这么多的“闲话”, 继续回到 vim 手册查看的注意事项上来。
linux 下各种软件的手册，会有很多约定， 而这些约定不反应在手册里，因此会造成看手册的障碍，我这里就记录一下我所知的一些约定。 

1. 命令行中的约定

|符号| 说明|
|:-:|:--:|
| [ ] | 该参数是选填的，命令中不带[ ],[ ]中的单词是说明 |
| < > | 该参数是必填的，命令中不带< >,< >中的单词是说明 |
| my,your,home,file | 一般带有这些字样的, |
| <++> | <++> |
| <++> | <++> |
| <++> | <++> |

2. 函数介绍中的约定

3. 映射指令中的保留字

|保留字| 说明|
|:-:|:--:|
| <Bar> | 代表竖线符号`|`, 所有的符号，保留字都可以通地 :help 查看, 下同|
| <Plug> | 是键盘无法打出的特殊字符，<Plug> 脚本名 映射名, 专用用来映射内部脚本方法的，减少重复按键序列的概率 |
| <SID> | 与Plug类似，也是用来映射脚本函数，为此映射生成唯一id, 降低相同函数名的机率 |
| <cr> | 换行符 |
| <silent> | 不显示命令调用的日志信息 |

### 学习路线
2021/2/18 16:06:56 星期四

vim 的学习，我自己都没有找到很有效的学习方法, 折折腾腾也四五年了，连一个好用的开发环境都没有配置起来，如何去写好一个教程？
目前所有的blog都是记录式的流水账，确实没啥营养, 实在拿不出手去分享，不过，这总是我进步过程中的一个状态，暂且先保存下来。
随着学习的深入，对于vim越来越了解，对于vim系统的学习路线也越来越清晰，当然这个路线也是不断的演进的。

为何不能在学习的过程中就将blog写好呢？ 主要还是写作能力欠缺，学习的过程中，本来也可以记录一下思路的，奈何不管是写作水平，还是心态，都不能很好的完成一篇学习记录。总之是达不到自己的满意。现在复盘仔细一想，主要还是我自己的目标不够清晰。

学习过程的中记录，有两个目的， 优先于后续的查找, 二是记录下学习的思路，以便于复盘以及后续再整理提供第一手素材。所以，前期的记录水就水点，不能因为水，就排斥分享与记录，

一般开发环境的配置，真得是重中之中，需要学习的东西很多。配置开发环境的场景也很多，换电脑，换工作，换系统，开始一个新项目。所以，这一项硬技能，是真得很有必要。

后续我可以慢慢更新一个高效使用电脑系列。先捡我自己的经历来写，精力达不到的，还可以招稿嘛。这个系例还是很有必要的, 这也是组织能力了。 

这样的blog还是有记录的必要，能力的提升是需要一个过程的。我不能只想着展示好的一面，进步的一面也很有参考意义。

后续的学习得明确目标，不可能去事无巨细地去学习。
有几个原因，
1. 一个成熟的工具/项目，经过不断的演进，会多了很多小功能/细节，这些小功能/细节，并不是每个人都会用到
2. 人的精力有限，而往往学习一个新的工具并不是时间很充足，本身就有一些需求/目的，完成这个需求/目的，并不会用到所有的功能。可定制就是这一点比较好，我用不到的就不需要加载，打造一款完全符号自己的工具。
3. 事无巨细地去学习是在有更深层次的需求，如功能扩展，定制开发，对工具的喜爱等。
4. 一个工具/项目的手册/文档的书写思路是与作者的学习习惯相关的，一般文档的的制作是在后期，是站在上帝视角，所以，对于新手的学习可能并不友好。因此很容易失去学习的目标，就容易陷入细节中而不可自拔。
5. 事无巨细地，从前向后地学习是效率最低下的方式。学习是一个反复的过程，概览，有目标的选择性学习，再系统性的复盘，查缺补漏, 这才是学会知识的最根本的路径。
6. 有目的地去学习, 本质上是将思考的主动权放在自己的手上。以前老师总是强调，带着问题去学习，这真得是有效的学习方法。然而，老师忘记了去教如何去提出问题, 这一点我到现在才知道。想知道什么，不知道什么，已知道什么，距离想知道什么, 我需要做什么，有哪些途径去获取知识，一个知识的组成。

知识的习得标准:
1. 可以解决当下的问题
2. 知识的发展背景
3. 融会贯通, 举一反三
4. 组合创新, 发现新的知识