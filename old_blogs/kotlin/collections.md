
## Collection 

    学习一门新语言, 大致看一下与已的语言的差异, 然后根据需求来学习, 涉及到的陌生语法, 即时查找, 然后复盘总结所需的语法知识.

    学习kotlin太轻敌了, 拖了那么长时间, 竟然不知道该如何学习

## 需求
0. 学习MaterialDialog的使用
    - 看源码学习才是最高效的

1. array 的使用

2. List的使用

3. Map的使用

4. Stack 的使用

5. Heap 的使用

6. 实现排序算法

## 陌生语法
1. init
    - inline class 不能有init{}块
    - 相当于java中的静态初始化块

2. setter, getter
    - kotlin会为属性自动生成 setter/getter, 前提是可以自动推断出默认初始化器(定义时赋值), val 定义的属性在声明时未赋值, 后面只能在Constructor中赋值
    - 访问属性是通过setter/getter, 所以, 在setter中直接访问属性名赋值会形成无限递归调用,引发StackOverflow
    - 避免此问题, kotlin的实现是在getter/setter 中自动添加一个backing field - field, field 只存在getter/setter中
    - 扩展的属性需要手动实现getter/setter, 因为, kotlin对于扩展属性没有一个好的方法去添加backing field
    - 那么原有属性是如何将field关联的呢?

3. Backing Fields
    - 只存在于accessors 中
    - 如果backing field 不能实现需求, 可以使用私有变量来实现, 编译器会将其优化为直接访问属性

4. var, val
    - var 声明可变属性/变量, val 声明只读属性/变量
    - 变量的作用域与其第一次声明的位置有关
    - [properties文档](http://www.liying-cn.net/kotlin/docs/reference/properties.html)

5. 编译期常数值
    - const 修饰, 
    - 必须是顶级属性, 或 object , companion object 修饰
    - 值被初始化为String类型, 或基本类型
    - 不存在自定义取值方法 

6. 对象表达式object, companion object
    - 可以声明一个匿名对象, 如果object 没有超类, 则是Any, 不能访问匿名对象中的属性
    - 使用object实现的匿名对象不需要像java 添加final 修饰
    - companion object 的访问形式类似于静态成员, 但是companion object是一个对象, 可以实现接口, 加上@JvmStatic 可以真正实现静态成员
    - 将一个类名直接赋值给变量, 默认赋值访问的是companion object
