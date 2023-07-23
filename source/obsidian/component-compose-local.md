
---
title: Composition Local
date: 2023-07-22 18:23
uuid: 
status: draft
tags: Compositionlocal
categories: Compose
description: 
---

# 简介

一般情况下， Composable 是以参数形式向下流戏整个界面树，传递给每个可组合函数。 
这会使可组合项的依赖项变为显式依赖项, 
对于广泛使用的常用数据（如颜色或类型样式），这可能会很麻烦。
同时也会使 Coposable 函数的形参数量膨胀。

CompositionLocal 是 用于在 Composable 函数之间传递和共享数据。

它的作用有以下几个方面：

1. 提供了一种在 Composable 函数之间传递和共享数据的方式。可以将数据存储在 CompositionLocal 中，然后在需要使用该数据的 Composable 函数中通过 CompositionLocal.current 来获取该数据。

2. 可以在不污染全局作用域的情况下，将数据传递给 Composable 函数。通过将数据存储在 CompositionLocal 中，可以避免使用全局变量或参数传递的方式来传递数据。

3. 提供了一种方便的方式来实现主题切换。可以将主题数据存储在 CompositionLocal 中，然后在整个应用程序中使用 CompositionLocal.current 来获取当前的主题数据。

4. 可以方便地实现本地化。可以将本地化数据存储在 CompositionLocal 中，然后在需要使用本地化数据的 Composable 函数中通过 CompositionLocal.current 来获取该数据。

# 一个典型的示例: MaterialTheme 换肤使用

MaterialTheme 对象提供了三个 CompositionLocal 实例，即 colors、typography 和 shapes。
您可以之后在组合的任何后代部分中检索这些实例。
具体来说，这些是可以通过 MaterialTheme colors、shapes 和 typography 属性访问的 LocalColors、LocalShapes 和 LocalTypography 属性。

```kotlin
@Composable
fun MyApp() {
	// Provides a Theme whose values are propagated down its `content`
    // 提供一个主题，其值会向下传播到其 "内容 "中
    MaterialTheme {
        // 这里就可以访问 colors, typography, and shapes

        // ... content here ...
    }
}

// 嵌套在 MaterialTheme content 中的 Composable 函数
@Composable
fun SomeTextLabel(labelText: String) {
    Text(
        text = labelText,
        // `primary` 由 MaterialTheme 提供
        // LocalColors CompositionLocal
        color = MaterialTheme.colors.primary
    )
}
```

提供一个Composable 函数作用域里共享数据的一种方式
在作用域里嵌套的 Composable 函数不用以传参的方式传递数据

CompositionLocal 实例的作用域限定为组合的一部分，因此您可以在`结构树`的不同级别提供不同的值。
CompositionLocal 的 current 值对应于该组合部分中的某个祖先提供的最接近的值

# 使用方式

使用 CompositionLocalProvider 及其 provides infix 函数，将 CompositionLocal 键与 value 相关联。
在访问 CompositionLocal 的 current 属性时，CompositionLocalProvider 的 content lambda 将获取提供的值。
提供新值后，Compose 会重组读取 CompositionLocal 的组合部分。

```kotlin
@Composable
fun CompositionLocalExample() {
    MaterialTheme { // MaterialTheme sets ContentAlpha.high as default
        Column {
            Text("这里的文本可以用 MaterialTheme 提供的 alpha")
            CompositionLocalProvider(LocalContentAlpha provides ContentAlpha.medium) {
                Text("这里的文本将 LocalContentAlpha 值改为 Medium")
                Text("这里的文本依旧使用 medium 值")
                CompositionLocalProvider(LocalContentAlpha provides ContentAlpha.disabled) {
                    DescendantExample()
                }
            }
        }
    }
}

@Composable
fun DescendantExample() {
    // CompositionLocalProviders also work across composable functions
	// CompositionLocalProviders 可跨 composable 函数使用
    Text("这里的文本现在可使用 disabled alpha 值")
}
```

CompositionLocal 是通过组合隐式向下传递数据的工具。

有两个 API 可用于创建 CompositionLocal：

- compositionLocalOf：在Composable作用域范围内提供数据共享。在重组期间更改提供的值只会使读取其 current 值的内容无效(重组), 不会使整个作用域发生重组。

- staticCompositionLocalOf：与 compositionLocalOf 不同，Compose 不会跟踪 staticCompositionLocalOf 的读取。更改该值会导致提供 CompositionLocal 的整个 content lambda 被重组，而不仅仅是在组合中读取 current 值的位置。
	
	一般用于共享不(频繁)更改的资源/数据

# CompositionLocal 的缺陷(不建议过度使用)

### CompositionLocal 使得可组合项的行为更难推断

在创建隐式依赖项时，使用这些依赖项的可组合项的调用方需要确保为每个 CompositionLocal 提供一个值。

此外，该依赖项可能没有明确的可信来源，因为它可能会在组合中的任何部分发生改变。因此，在出现问题时调试应用可能更具有挑战性因为需要向上查看组合，了解提供 current 值的位置。

> Android Studio 中的“Find usages”或 Compose 布局检查器等工具提供了足够的信息来缓解这个问题。
> 注意：CompositionLocal 非常适合基础架构，而且 Jetpack Compose 大量使用该工具。

## 如何决定是否使用 CompositionLocal

1. 在作用域内有合适的默认值(子作用域不会频繁改动值)。

如果没有默认值，使用者忘记赋值，程序就崩，
每个子作用域（Composbale) 都需要改变其值，这种情况并不适用

2. 其可能会被任何（而非少数几个）后代使用。

有些概念并非以树或子层次结构为作用域，请避免对这些概念使用 CompositionLocal。

一种错误的做法： 使用CompositionLocal 共享 viewModel。
因为并不是特定界面下所有的组合项都需要知道viewModel。
而且使用viewModel 作为参数传递，增加了耦合，降低了复用性

最佳做法是： 遵循 `状态向下传递而事件向上传递`, 只向可组合项传递所需信息。
这样做的好处是： Composable 的可重用性


# CompositionLocal 实现原理

是如何做到 作用域内数据共享的呢？

使用 SlotTable 来存储数据

# 其他替代 CompositionLocal的方式

1. 传递显示参数

> 建议：只传递所需可组合项

为了鼓励分离和重用可组合项，每个组合包含的信息应该尽可能少

```kotlin
@Composable
fun MyComposable(myViewModel: MyViewModel = viewModel()) {
    // ... 
    MyDescendant(myViewModel.data)
}

// 不要传递整个viewModel, 只需传所需数据
// 同样，也不可将viewModel 以 CompositionLocal 来隐式共享
@Composable
fun MyDescendant(myViewModel: MyViewModel) { ... }

// 只传递所需数据
@Composable
fun MyDescendant(data: DataToDisplay) {
    // Display data
}
```

2. 控制反转

不是由后代接受依赖项来执行某些逻辑，而是由父级接受依赖项来执行某些逻辑。

一般做法是: 子 Composable 提供 callback

# 总结

1. CompositionLocal 在数据不(频繁)改动的情况下，可以为子Composable提供数据共享，减少了参数传递。 需注意 Composable 的重组带来的性能影响。
2. 提供了 compositionLocalOf 和 staticCompositionLocalOf, 同样根据重组带来的性能影响来选择使用。
3. CompositionLocal 通过 CompositionLocalProvider 来关键CompositionLocal 与 (值)数据
4. 考虑到耦合与复用原则，不适合使用CompositionLocal的地方，可考虑使用显示传递参数，控制反转（子Composable提供callback)的方式来达到效果。
5. CompositionLocal 原理是 SlotTable 来存储数据。像Composable一样，

# 参考

[android developer: CompositionLocal](https://developer.android.com/jetpack/compose/compositionlocal)

