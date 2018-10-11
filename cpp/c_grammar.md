
## realloc
- C的标准库, 要怎么系统的学习呢?
- 写3sum算法的时候, 只会 malloc, 所以, 动态分配与释放的时候, 搞不转了, 有了这个函数, 就容易得多
- calloc, malloc, realloc

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