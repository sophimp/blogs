
## jni 框架

	为解决一个so 库不可以在子线程中创建的问题， 系统学习一下jni

### 目的

	jni 框架， 实现原理，调用原则, 解决如上问题。

### Introduction

	JNI, java native  programming interface, 允许java 虚拟机中的java 代码调用其他语言写的代码，如(c/c++, assembly汇编)

使用场景
	* java se 库不包括平台依赖的特性
	* 使用已有的其他语言的库， 不必重复造轮子。 
	* 你想使用汇编实现一个高效的有严格时间限制的代码

使用jni可以做的事
	* create, inspect, and update java对象(strings, arrays);
	* 调用java代码
	* 捕获或抛异常
	* 加载类并获得类信息
	* 执行运行时检查
	* 使用invocation API 嵌入任一native程序到java VM, 

JRI
	* Java Runtime Interface


### Design Overview

[官方文档](https://docs.oracle.com/javase/8/docs/technotes/guides/jni/spec/intro.html)

### JNI Types and Data Structures

### JNI Functions

### The Invocation API

### 问题解决

问题描述:
java中开启子线程， 调用jni方法， 会发生闪退， 在主线程中就可以. 
jni方法的参数比较多， 且包含二维数组，大小为 9*16384

解决过程:
由此问题想系统地再学习一遍 jni 框架， 然后看了第一章就看不下去了， 后面再慢慢看吧。 

查询大量blog, 在子线程中访问不到env, 是在jni中通过pthread_create创建的线程访问不到， 这个时候要通过jvm, 缓存全局对象。

现在我遇到的问题是在java中开启子线程，调用jni方法， 这种调用并不会影响 env 的访问, 
jni与java线程是分开的， 但是jni调用的env 是与线程绑定的。 所以在java的子线程里调用jni, 拿到的env是可以直接用的。 
为何通过env 找不到二维数组呢？ 猜测是因为在java中， 二维数组过大， 或二维数组本身就在堆内存中存放， 所以， 是以引用与主线程MainActivity绑定的。
jni代码写的也有问题， 二维数组过大， 9*16384, 且有4个， 以栈的形式存储， 闪退应该是直接爆了。 

阅读了代码发现， 并不用在栈上再开辟一个二维数组，通过 env->GetDoubleArrayElements 得到一个指针， 直接可以访问到， 且代码逻辑里也是直接按一维数组来使用的。 所以，全部都改了了一维数组， 且不必再声明局部变量或在堆上另开辟内存。

这里也想到， C语言的二维数组内存排放也是线性的， 所以按一维数组来读也是没有错的。

为什么在主线程就没有问题了， 猜测主线程栈的大小是比较大的吧, 且二维数组的对象本来就是与MainActivity绑定的， 所以可以访问到。 

暂时先解决了问题， jni框架， 后续再找时间学习吧。

