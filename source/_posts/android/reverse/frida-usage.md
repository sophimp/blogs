---
title: frida使用
date: 2020-11-12 17:21:16
tags:
- Frida
- SRE
categories:
- SRE
description: firda很强大, 使用起来的脚本语言
---

### 安装
1. 预安装二进制包
```sh
pip install frida-tools # CLI tools
pip install frida       # Python bindings
npm install frida       # Node.js bindings
```
2. frida-server 与 frida-client
[官方Android示例](https://frida.re/docs/android/)
先下载最新的[frida-server](https://github.com/frida/frida/releases) 并解压, 然后将解压后的frida-server放在Android中/data/local/中运行
```sh
unzx frida-server.xz
```

3. 使用
```
# 使用这条命令经常会让程序重启挂死
frida -U -f <process_name> -l <script>

# 使用这条命令就很安全
frida -U -F -l <script>
```

frida命令须带脚本执行，去掉-l, 所有的app都会黑屏。

### 框架

源码地址 https://github.com/frida

frida 核心还是 typescript, python脚本可以套一个壳子将 上述的命令操作代替了脚本

CMoudle 是javascript壳子里面套 C代码

所以直接看JavaScript的API即可。 

frida知道框架是咋回事了， 看看api提供了哪些能力， 也能对逆向的整体知识有个概念

### JavaScript API
0. Runtime information

Frida.version, Frida.heapSize, Script.runtime

1. Process, Thread, Module and Memory

Thread

Process

	注入进程对象，

Module

	lib库对象

ModuleMap

	new ModuleMap([filter]); 将当前hook的模块内存快照保存起来，封装了一些访问更新的方法。如可以查看指定进程的Module, 可以快速定位某个地址是否属于某个Module。

Memory

	对内存操作的封装, 

MemoryAccessMonitor
	看名知义，内存访问监视器

CModule
	JavaScript框加上去解析c代码，直接将C代码编译成机器码放到内存中。
	对热回调(Hot Callback)很有用？ 什么是Hot Callback
	
ApiResolver

	允许根据名字快速查找函数， 前提是此globs允许

DebugSymbol

	一个库的可调试符号表查询, 有些会查询不到。
	address, name, moduleName, fileName, lineNumber

Kernel

	内核api操作封装,  暂时没遇到使用场景, 用到时候再看

2. Data Types, Function and Callback

Int64, UInt64, NativePointer,  ArrayBuffer

NativeFunction, SystemFunction

NativeCallback

3. Network

Socket通信提供了。
	Socket, SocketListener, SocketConnection

4. File and Stream

文件I/O操作也提供了
	File, IOStream, InputStream, OutputStream, UnixInputStream, UnixOutputStream, Win32InputStream, Win32OutputStream

5. Database

数据库操作也提供了
	SqliteDatabase, SqliteStatement

6. Instrument

提供了工具链

Interceptor

	函数插桩，可以监听函数调用前，调用后, 替换当前函数实现等能力
	Interceptor.attach(target, callbacks[, data]), target 是一个NativePointer, 指向被attach的函数
	Interceptor.detachAll()
	Interceptor.replace(target, replacement[, data]), replacement 是实现NativeCallback的对象
	Interceptor.revert(target)
	Interceptor.flush()

Stalker

	用于线程跟踪，可以达到指令级的执行跟踪效果。
	这个工具很强大啊， 可以达到动态调试效果

WeakRef

	WeakRef.bind(value, fn) 当value被回收时， 触发回调fn, 返回一个id
	WeakRef.unbind(id), 停止监听值的生命周期
	这在绑定一种语言时很有帮助，绑定本地资源会占用本地资源， 如果绑定语言的脚本执行完毕， 需要释放本地资源, 可以使用WeakRef来引用。

ObjC
	IOS平台，暂不关注

Java
	与Interceptor一起是Android应用层的主场。
	Java.perform(fn), 将当前线程附着于VM, 并调用此函数(在Java的回调中, fn不是必须的)。在应用的classloader不可用时，会延迟回调。如果不使用该应用的类, 可以使用Java.performNow(fn)
	Java.avaiable, 标识当前进程是否有Java VM加载
	Java.androidVersion, 标识Android当前运行版本
	Java.enumerateLoadedClasses(callbacks), 马上枚举所有加载的class, 回调返回class对象
	Java.enumerateLoadedClassesSync(), 同步反回所有加载的类名，以数组保存
	Java.enumerateMethods(query), 枚举满足query的所有方法，query的形式:"class!method", with globs permitted. (globs are patterns you type, 这里是指query也支持部分正则的规则)。query的后缀还可以跟一个或多个修饰符(i: 大小写敏感, s: 包括方法签名, u:用户自定义的类, 不包括系统类)
	Java.scheduleOnMainThread(fn), 在主线程中运行 fn 方法
	Java.use(className), 动态获得一个javascript包装className的对象, 可以通过`$new()`调用className的构造函数创建一个实例, `$dispose()`显示回收此对象。或者等Javascript自动回收，或卸截加载人脚本, 都会回收掉对象。静态和非静态方法都可以调用，甚至可以替换方法的实现，从内部抛出一个异常。默认使用应用的类加载器， 也可以指一个不同的类加载器实例给Java.classFactory.loader。注意，所有的方法封装提供clone(options)方法去创建一个NativeFunction类型的方法封装。
	Java.openClassFile(filePath), 打开filePath下的.dex文件, 返回一个对象，提供load(), getClassNames()方法。
	Java.choose(className, callbacks), 在jvm的堆中查找可用的className实例，callbacks回调包括onMatch(instance), onComplete(), 在onMatch中调用Java.cast() 会提前结束遍历，并返回一个字符串。
	Java.retain(obj), 复制javascript封装的对象, 以提供后续替换对象中的方法外部使用。
	Java.cast(handle, klass), 从Java.use()返回给定类klass的句柄下的现有实便的javascript的封装对象。这个javascript封装的对象有一个class属性去得到被包装的类，`$className` 属性来获得类名。
	Java.array(type, elements), 创建一个type类型的java数组，并将javascript数组中的elements转成type类型并添加到java数组中。返回的java数组类似于JS数组，但是可以传引用到Java API以改变其中的内容。
	Java.isMainThread(), 判断调用者是否在主线程。
	Java.registerClass(spec), 创建一个新的Java类，返回JS包装器，其中spec对象包含：
		name(类名), 
		superClass(继随自java.lang.Object的父类), 
		implements(可选，实现的接口类数组), 
		fields(可选，指明每个字段类型和名称可暴露的对象),
		methods(可选, 指明需实现的方法的对象)。
	Java.deoptimizeEverything(), 强制使用VM使用其解释器执行所有操作。在某些情况下，有必要防止优化绕过方法的hook, 并允许ART的Instrumentation API用于跟踪运行时。
	Java.vm, 一个JS对象， 包含下列方法:
		perfom(fn), 等同于 Java.perform(fn)
		getEnv(), 得到当前线程的JNIEnv包装器，如果当前线程未附加到VM, 则抛出异常。
		tryGetEnv(), 尝试去获取 JNIEnv包装器，
		JNIEnv, 如果当前线程未附着于VM, 返回null.
	Java.classFactory, 用于实现默认的classLoader， 如，Java.use() 使用应用的主类加载器。
	Java.ClassFactory, 首字母大写了， 包含了以下属性:
		get(classCloader), 获得一个给定的类加载器的class factory实例, 幕后使用的默认的class factory 仅与应用程序的主类加载器交互。其他的类加载器可以通近Java.enumerateClassLoaders() 来发现，然后与此api来交互。
		loader, 只读的当前类加载的类加载器包装器，对于默认的工厂类, 只在首次执行Java.perform时被赋值。
		cacheDir, 当前使用的cacheDir路径， 对于默认的工石类，只在首次执行Java.perform时被赋值。
		tempFileNaming, 指定临时文件命名规则的对象如```{prefix: 'frida', suffix,'dat'}```
		use(className), 类似于Java.use(),但是此方法用于指定的类加载器
		openClassFile(filePath), 类似于Java.openClassFile(),但是此方法用于指定的类加载器
		choose(className, callbacks), 类似于Java.choose(),但是此方法用于指定的类加载器
		retain(obj), 类似于Java.retain(),但是此方法用于指定的类加载器
		cast(handle, klass), 类似于Java.cast(),但是此方法用于指定的类加载器
		array(type, elements),类似于Java.array(),但是此方法用于指定的类加载器 
		registerClass(spec), 类似于Java.registerClass(),但是此方法用于指定的类加载器 

7. CPU Instruction
对CPU指令级操作的工具, 直接操作寄存器, 栈，缓存, 这一块暂时也不用太关注， 不管是应用还是研究,都还没到这个层次， 后面有需求或者技术追求的时候再回过头看吧。目前支持4个平台

Instruction
	指令操作方法提供
	Instruction.parse(target) 将一个NativePointer所代表的内存地址解析成一个对象， 包括address, next, size, mnemonic, opStr, operands, regsRead, regsWritten, groups, toString()

X86Writer/X86Relocator/X86 enum types
	x86架构

ArmWriter/ ArmRelocator/ Arm enum types
	arm架构

ThumbWriter/ThumbRelocator
	Thumb架构还是第一次听说

MipsWriter/MipsRelocator /Mips enum types
	Mips架构

8. Other

Console

	日志打印, console.log(line), console.warn(line), console.error(line)

Hexdump

	可以dump内存中模块的函数， 传入首地址
	hexdump(target[,options])

Shorthand
	类型new操作的简化函数
	int64(v)  <--> new Int64(v)
	uint64(v) <--> new UInt64(v)
	ptr(s)    <--> new NativePointer(s)
	NULL	  <--> ptr("0")

frida 本机进程与注入的目标进程通信

	recv([type, ]callback), 只会回调一次

	send(message[, data]) 发送JSON可序列化的 java对象消息,

		send函数并不高效， 建议将多个信息打包作一起发送一次，如果想快速看到输出的话

	rpc.exports

		python脚本中嵌入js就是这种方式， 还是以使用Node.js的框架

时间事件
	setTimeout(func, delay[, ...parameters]), 超时回调, 返回一个id
	clearTimeout(id)
	setInterval(func, delay[, ...parameters]), 定时回调, 返回一个id
	clearInterval(id)
	setImmediate(func[, ...parameters]) 尽可能快地在Frida Javascript线程调用func, 返回一个id
	clearImmediate(id)

垃圾回收
	gc() 强制进行垃圾回收

### 扩展工具

[objection官方](https://pypi.org/project/objection/)
[objection使用教程](https://www.anquanke.com/post/id/197657)
