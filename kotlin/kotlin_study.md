
## kotlin
1. 初步使用体验
    - 是时候学习一下kotlin了，不难理解， 但是真正动手写起来的时候， 也完全无从下手
    - 对象不会创建， 集合对象不会创建， 大部分的api 还可以按java的来按图索骥
    - 数组也不会创建， 先将一个能跑通的程序写出来， 可以使用数组，集合， 其他的特性， 后续再学习
    - 类型放在后面的方式也并没有多么不适应， 当初Objective C 不也是这样么
    - 有点偏脚本语言语法, 总体感觉还是进步的， 之所以感觉要记得多， 主要还是对语言的本质未把握住

2. 学习目的
    - 刚好可以检验， 印证一下csapp的学习
    - csapp 的服务器， 客户端也等这个项目搞完了，再继续
    - csapp 辅助jvm 的学习， 实践在kotlin的学习过程中

3. 优点

    说得很牛逼， 与java相比， 代码量能减30%, 方法减少10%, lambda, coroutine 效率也更高，
    与java 100%兼容, 可以编译成各平台的native 执行文件
    web, android 开发的lib 都已经开发好了

## 2. 基本语法
    - 变量

        基本类型怎么都不一样了, 是对象的类型不一样了而已
    - 类与对象
    - 函数扩展

3. 高级使用
    - coroutine
    - 委托
    - 集合使用

    api的使用还是要查文档， 熟能生巧，先不想直接上手anko, 感觉anko 将布局写在activity中， 代码反而不好拆分, 先使用原有的android开发技术， 语言换成kotlin

4. 语法糖
    - 还是得踏实点来， 语法糖有些多， 但是也得了解为何有那么些语法糖， 这本也是学习的一部分

5. 关键字(相较于java 新增)

hard keywords
    * 不可以被用作变量名， 只能被解释成关键字
    * as, as?
        - 安全的强制转换，相当于 if(.. instanceof ..) {=}
    * in, !in
        - for 循环, range, when, 用来限定范型范围(与out相对，相当于 ? extends T, ? super T)
    * is
        - 检查一个类型是否是一个确定的类型a
        - 用在when 表达式中是同样的目的
    * typealias
        - declares a type alias
    * val
        - 声明一个只读或局部变量
    * var
        - 声明一个可读写的变量或局部变量
    * when
        - switch的升级版， case 可带表达式
    * break, class, continue, do, else, false, for, if, interface, null, object, package, super, this, throw, true, try, while, 功能同java

soft keywords
    * 在特定上下文中作为关键字， 在其他上下文 中可以作为标识符
    * by, 理解的语法规则， 使用场景呢？ 一般一个代理是为了添加一些控制逻辑, 作为框架来说， 面向接口代理， 是可以这样做， 也更方便, kotlin 本地支持了代理， 而且方法零模板， 程序自动生成， 一看关键字， 确实语法糖多
        - 接口的实现类的代理, 代理以组合形式拥有被代理对象， 代理可重写被代理类的方法， 但是不能访问被代理类的字段
        - accessor property 的代理
    * constructor 构造函数声明
    * dynamic 引用一个动态变量(kotlin/JS Code)
    * delegate 被用于明确注解 use-site 目标(is used as an annotation use-site target, 不是很明白)
    * file 同上
    * set, get 同上 
    * param 同上
    * property 同上
    * receiver 同上
    * setparam 同上
    * init 开始于初始化块, 相当于java 中的函数外静态代码块
    * where 详指泛型约束, 跟is的作用类似， 但是只用于泛型中？
    * catch, field, finally, import

modifier keywords
    * 在list声明中作为关键字， 可以在其他上下文环境中作为标识符
    * actual 在多平台工程中指名是哪一个平台实现， 平台指示说明
    * companion 内部类声明, 类名可省，只能有一个companion类， 可以像静态类一样直接调用方法， 但是会生成一个实例
        配合@JavaStatic 可以声明成静态类
    * const 标记属性编译期常量
    * crossinline 禁止lambda表达式中非局部变量返回的inline返回
    * data 指示编译器生成标准的类成员, 按照构造函数中的所有参数生成equals()/hashCode(), toString(), copy(), componentN() functions
        有几点要求: 构造函数至少有一个参数且只能为val或var, 不能被abstract, open, sealed, inner
    * expect 也是平台指示, 标记声明为平台说明， 期望某个平台模块的实现
    * external 标记非kotlin的外部实现(JNI 或 JavaScript), 那就是没有native了
    * infix 允许以中缀标记调用函数, 中缀函数必须只有一个参数, 必须为成员函数功扩展函数, 函数参数必须没有默认值
    * inline 内联函数， 拥有更高的效率
    * inner 允计从内部类中访问一个外部的类实例, 相当于java 内部内多了一个关键字，那companion就不是简单的内部类了，为何要存在呢
    * internal 标记一个变量有作用载在此模块(package作用域), 相当于java的默认作用域
    * lateinit 延时初始化, 可放在构造函数外部初始化
    * noinline 关闭lambda表达式访问inline函数
    * open 可以继承或重载函数
    * operator 操作符重载
    * out 标记类型下限, 还是有些不明所以， 生产者， 消费者， 角色不一样， 定义不一样， 只能读的叫作生产者， 只能写的叫作消费者，这是从使用者的角度来说的，这里面还有什么协变性， 逆变性， 都有些不明所以
    * reified 标记内联函数中的参数类型在runtime可访问
    * sealed 封装的类， 构造函数默认是私有的, 所有继承sealed类的子类必须放在同一个文件中， 有点枚举功能
    * suspend 协程中使用， 标记函数或lambda表达式为suspending状态
    * tailrec 标记函数为尾递归， 允许编译器替换成迭代实现
    * vararg 允许一个参数传入可变数量参数
    * abstract, annotation, enum, final, override, private, portected, public 功能同java

special identifiers
    * field 用属性访问器来引用幕后字段, 只能在属性的访问器内, field 此时相当于it
    * it 用在lambda表达式内部来隐式引用其参数, 单个参数的隐式名称

operators and special symbols
    * ===, !== 引用相等操作符, 
    * ==, != 调用equals()方法
    * [,] 索引访问符， 调用get, set
    * !! 断言不为空
    * ?. 非空调用
    * :: 创建一个成员引用 或 类引用
    * .. 创建一个范围(range)
    * : 变量名与类型名声明分隔符
    * ? 标记一个类型可以空
    * -> 
        - 可用于lambda表达式， 分隔参数与函数体
        - 可用于函数类型， 分隔参数与返回值
        - 可用于when 表达式， 分隔条件与执行体
    * @ 
        - 引入一个annotation
        - 引用一个引用或循环标签(loop label)
        - 引用一个引用或lambda label
        - 一个外部作用域的引用
        - 一个外部内的引用
    * $ 字符串中的变量引用表达式
    * _ 
        - lambda表达式中一个未使用的变量名替代 
        - destructureing 声明中未使用参数变量名的替代

    这样看来， 语法糖确实多， 但是多也是好处， 可以提供学习的方向， 为何要有这些语法糖， 继而更深层次地去理解语法, 编译原理

	* * 可以将Array(out String) 转换成 String ...

## 感悟

    得, 又一次高估了自己的能力, 只是记录上述的语法基础, (我)真得很难学会kotlin, 虽然有一定的基础, 但是那么多语法糖, 就出现了选择困难障碍

    陌生的语法, 陌生的api, 让一切都变得无所适从, 该如何学习呢? 首要的就是先要学会Collection的使用

    是的, 一开始就学错了, 只是将语法罗列在一起, 不经过练习, 记忆很难生效的, 根据实际的需求学习语言, 再作总结
