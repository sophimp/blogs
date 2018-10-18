
## realloc
- C的标准库, 要怎么系统的学习呢?
- 写3sum算法的时候, 只会 malloc, 所以, 动态分配与释放的时候, 搞不转了, 有了这个函数, 就容易得多
- calloc, malloc, realloc
    * 堆上配置的struct数组指针, 指向 函数内的struct对象, 会在函数执行完出栈的时候弹出吗?
    * 需要不需要每个struct指针所指对象也要在堆上分配一下?

## ++, --, while
- c 与 java 的编译规则不一样, 在3sum算法中试验出来的
- 看c reference 上描述的, 是一样的, 但是在 3sum上实践出来的并不一样
- while(nums[i] == nums[++i]); 这样实验出来的并不OK
    需要替换成:
    while(nums[i] == nums[i+1]){
        ++i;
    }
    ++i;
- 很迷惑人

## for 循环
- 双层for循环, 变量初始化的问题
- ++, -- 虽然对有些编译器表现不一样, 但是大致功能还是一样的
- 二维数组与 int** 这个还是有些区别, 如何将二维数组传入 int** 有待解决

## typedef
- type
    * 取一个别名
- struct
    * 在C++中当类处理, 与 typedef一起跟C的作用一样, struct <qualifier> 一起作为一个类型
- function
    * typedef <return type> <(*funcName)>(<argument...>)
- arry
    typdef baseType newType[arraySize] 
- pointer
    typedef int *Ptr;   
    Ptr p; <==>  int* p;

## 二级指针如何赋值
1. int**p 与 int*pt
- *p = &pt;

2. Design Circular Queue
- 面向对象的思想太局限性了, 非得将struct看成一个类, 当成每个数据结点
- C 是可以实现面向对象的， 结构体只装指针， 实体数据存储， 要么是简单的基本数据类型， 堆上的数据， 也只是保存指针
- 由此可以理解 jni的数据通信
- 函数指针， 更是灵活的一批, 可以作回调， 还可以作为返回值, 作为返回值的应用场景

3. 