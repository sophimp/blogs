
## 软件架构

软件架构与设计模式有何区别?

    软件架构是从整个项目的角色抽象
    设计模式是对业务的抽象

mvc, mvp, mvvm 该如何选择, 都是为了解决哪些问题呢?

    mvc 是最开始提出的一种架构思想, 将应用角色分层, model, view, controller
    mvp 是在mvc的基础上演进而来, 为了解耦 view, controller, 再抽象一个契约层, 可使业务更加明显
    mvvm 是在mvp 上继续发展而来, 为了解决随着业务的增加, mvp view层的接口越来越大的问题, 但是mvvm 在出了问题的时候, 不好定位

### mvc 

view 可与 model 交互

### mvp

view 与 model 解耦

### mvvm
