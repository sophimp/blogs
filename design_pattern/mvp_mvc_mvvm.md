
## 软件架构

软件架构与设计模式有何区别?

    软件架构是从整个项目的角色抽象
    设计模式是对业务的抽象

mvc, mvp, mvvm 该如何选择, 都是为了解决哪些问题呢?

    mvc 是最开始提出的一种架构思想, 将应用角色分层, model, view, controller
    mvp 是在mvc的基础上演进而来, 为了解耦 view, controller, 再抽象一个契约层, 可使业务更加明显
    mvvm 是在mvp 上继续发展而来, 为了解决随着业务的增加, mvp view层的接口越来越大的问题, 但是mvvm 在出了问题的时候, 不好定位

    如何选择, 还是看自己的需求, 不管如何命名, 当业务过多的时候, 想着重构, 再考虑这些, 想必会更有感觉

[MVC, MVP, MVVM 到底该怎么选](https://juejin.im/post/5b3a3a44f265da630e27a7e6)

[ViewModel, LiveData, LifeCycle](https://juejin.im/post/5b07b00151882538987b4d28)

### mvc 

view 可与 model 交互

### mvp

view 与 model 解耦

### mvvm

谷歌官方的框架, 看得有些懵, 设计的思想是什么
    - 有activity, fragment 的生命周期
    - 无须担心内存泄露?ViewModel 尽量不引用view, activity的上下文, 防止ViewModel的生命周期比activity长, 造成内存泄露
    - 在知乎上看了一篇嘲讽谷歌开发的代码的文章, 就下意识觉得android的代码都是垃圾, 也不尽然, 再垃圾, 也是比我现在的水平要高一些, 总有些学习的价值, 而且知乎上的那个人也是从摄像头与bitmap 这一块来考虑的, 可能有些道理, 但是也不乏自身的局限性a
    - ViewModel 处理数据业务, 网络请求需要专门的组件来获取, 这样的分离只是将ViewModel 与 View 的动态展示绑定在一起, 真正的业务逻辑呢? 
    - 业务逻辑是放在ViewModel 还是Presenter中, 需要看UI的复杂度
    - 尽量保证fragment, activity 的代码精简, 因为, xml 绘制视图的效率就不高

ViewModel的思想, 尽量是将model 相关的数据业务逻辑都封装起来, 一个View 可以对应多个ViewModel, 来保证数据的业务, 这样思考的话, 倒也是一个不错的分包与模块划分思想, 也更加容易测试

整个应用的流程: 获取数据 -> 操作数据 -> 数据改变 -> 刷新UI -> UI事件 -> 操作数据 -> 刷新UI
