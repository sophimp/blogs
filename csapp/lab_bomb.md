
## boomb lab
1. 题目

    有6步,  每一步需要输入一个字符串，如何输入期望的字符串， bomb解除，否则会引发bomb 
    尽可能多的拆除bomb

    [bomb lab获取]()

2. 解决步骤
    使用gdb
    反汇编，单步调试， 搞懂每一行汇编代码的意思, 推出每一步的字符串

    在触发bomb函数前设置断点, 是一个很好的课程强制学习debugger的使用

3. 提示:

    objdump -t 打印出符号表， 可查函数名
    objdump -d 反汇编
    info
    man gdb
    man ascii
    approps

4. 解题

    1. phase1

    2. phase2
    3. phase3
    4. phase4
    5. phase5
    6. phase6


## 基础知识

gdb 如何进入调试？

    `gdb <program executable>`

如何设置断点？

    b(reakpoint) <行号|函数名|指令地址>
    delete 断点号

如何反汇编？

    objdump -d program
    readelf

如何与源码对应？

    list 默认显示10行源码， 这里必须得加上调试信息才可以, 否则, 也不会对应源码

有了以上的工具， 基本上覆盖了提示的内容， 但是如何解题？

    先翻译部分函数的汇编代码，根据翻译结果尝试debug函数输入与输出

gdb 查看指定内存值
    `x/<n/f/u><addr>`
    examine 命令的简写是 x
    n, f, u 是可选参数, n 表示要显示内存单元的个数, f指以什么样的格式显示, u 是读取内存单位

设置启动参数
    set args [param]

[详细gdb使用教程](https://linuxtools-rst.readthedocs.io/zh_CN/latest/tool/gdb.html)

汇编代码

    1. 寄存器

        加上前缀 `r` 代表64位, `e` 代表32位, 后缀`x`代表16位, `l`代表低8位, `h`代表高8位
        %ax 一般用于返回值， 存储数据
        %bx 数据
        %cx 数据
        %dx 数据
        %si 源变址寄存器, 基于某个地址上偏移变化
        %di 目的地址寄存器，可存放数据
        %bp 存放函数对应的栈帧的栈底地址
        %sp 存放函数对应的栈帧的栈顶地址
        %r8 ~ %r15 存储数据

    2. 部分指令

        movzbl, 以零填充扩展, movsbl, 以最高符号位填充扩展

        lea 不同的指令集顺序不一致， csapp是与linux一致的， 是直接将左操作数通过地址计算放到右操作数
        lea 8(%eax, %eax, 3) %eax 解释为 %eax = 8 + %eax + 3*%eax;

        还是不熟练啊， 看到汇编， 想转成代码， 能力还欠缺
