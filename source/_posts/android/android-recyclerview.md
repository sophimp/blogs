---
title: RecyclerView分析
date: 2021-03-24 10:01:19
tags:
- RecyclerView
- Android
categories:
- Android
description: 搞定RecyclerView, 基本上就算是搞定了自定义View
---

## RecyclerView

> A flexible view for providing a limited window into a large data set.
一个灵活的view, 用于在有限的窗口空间中展示大量的数据集。

RecyclerView 用来设计于在有限的窗口空间加载大量的数据，屏幕本身就是有限的窗口，从这个角度看，Android的应用开发，绝大部分场景都可以使用RecyclerView来搞定。
RcyclverView 是后续添加进来的控件，是官方团队给出的基于View体系自定义控件优秀案例, 不仅仅是RecyclerView, 以前的TextView, EditView, ImageView, 各种Layout,都是自定义控件的优秀案例，倒是我自己有些后知后觉了。 
意味着搞定RecyclverView的实现原理, 基本上就算是搞定了自定义View

术语

	Adapter, 用来将数据集中的每个item数据展示到view中
	Position, 用来标识数据集中的位置
	Index, 用来标识Adapter中已使用的子view的位置索引。
	Binding, 绑定数据集与子view
	Recycle, 回收(复用)子view, 可以大大提高性能，主要是减少 layout inflate 或 constructor初使化的次数。layout inflate比较耗时
	Scrap, 在布局过程中处于临时 detached 状态的
	Dirty, 标识子view的状态, 在显示此view之前，必须要重新rebound

ReyclerView中的位置
> RecyclerView introduces an additional level of abstraction between RecyclerView.Adapter and RecyclerView.LayoutManager to be able to detect data set changes in batches during a layout calculation.
RecyclerView在RecyclerView.Adapter 和 RecyclerView.LayoutManager之间引入了另一种抽象级别, 以便能够在布局计算期间可以批量地检测数据集的变化。
这里也是性能点，可以避免LayoutManager从Adapter跟踪变化来计算动画的时间, 同时，view binding的时机放在同一时间，可以避免不必要的binding。
基于这个原因，在RcyclerView中提供了两个方法分别获取两种类型的position.
* layout position, 在最新一次的layout计算的子view的position, 这是LayoutManager视角的position, 相当于已使用(用户可见的)子view位置的索引。
* adapter position, 在 adapter 中的position, 从adapter视角。与数据源中的index相对应, 用来处理点击事件拿到点击view的数据。
	
注意:
	RecyclerView.ViewHolder.getAbsoluteAdapterPosition()
							getBindingAdapterPosition()
	findViewHolderFroAdapterPosition()
	这些方法可能会拿不到位置，因为会出现RecyclerView.Adapter.notifyDataSetChanged调用后，LayoutManager还没有计算完的情况，所以要处理返回NO_POSITION或null 的情况。

DiffUtil
	可以计算出哪里不同，继而局部更新
	Eugene Myers 差分算法，动态规划

List mutation with SortedList
	使用SotedList来处理增量更新。可以定义如何排序子view, 这个时候可以自动触发RecyclerView可以使用的更新信号.
	如果仅需要处理插入或删除事件可以使用SortedList, 好处是只需要在内存中具有list的单个副本即可。
	SortedList.replaceAll(Object[]), 会计算不同, 但是此方法比上面的DiffUitl的差分算法有更多限制。

Paging library
	Paging library 扩展了Myer's 的差分算法用来支持分页加载(paging loading). 
	提供了PagedList类， 可以像自动加载列表(self-loading list)的操作。提供了像database或网络分页加载的API支持, 以及开箱即用的方便的列表差异(list diffing)支持，类似于ListAdapter和AsyncListDiffer 
	Paging库是属于Jetpack组件库的一员。

## 架构与实现

如何算是学会了RecyclerView呢？
1. 初步使用
	使用LinearLayoutManager, GridLayoutManager, StaggerGridLayoutManager实现常见的布局。
2. RecyclerView, LayoutManger, Adapter, ViewHolder之间的关系及作用。
3. LayoutManger 抽象出来是如何layout的
4. 为什么要抽象出来Adapter, ViewHolder
	结合现实视角
5. 动画的实现
6. 滑动手势的实现
7. RecyclerView从初始化到与界面交互的流程，各角色的参与时机。
8. 缓存以及回收机制的实现
9. 性能瓶颈
	单个View的大小 
	自定义控件直接继承View与组合SDK提供的控件相比，就性能而言，是否有提升，又提升多少呢?

10. 自定义View的套路
11. View体系系统
	View是如何绘制到OpenGL中的
	View与直接使用OpenGL，性能差别在哪里
	View体系统的演进
	View, ViewGroup, Window, Surface, Layer

UI的展示, 不外乎处理测量布局，滑动手势的处理, RecyclerView的效率在于回收机制，灵活可扩展性。基于这几个方面来学习RecyclerView的实现。

根据RecyclerView的使用画出时序图。

1. 测量布局
2. 滑动手势
3. 回收复用
4. 灵活扩展

RecyclerView, ViewHolder, RecyclerView.Adapter, LayoutManager, ItemTouchHelper, SelectionTracker, 

## 流程图

