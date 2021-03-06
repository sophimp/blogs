
## OpenGL's Programmable Pipeline
// 先不刻意追求要记录出多么优秀的笔记, 先主要是学习, 记录一些知识点, 反应出思路, 最后再整理成可看的文章

1. vertext shading stage
2. tesselation shading stage
3. geometry shading stage
4. fragment shading stage
5. compute shading stage

6. 着色阶段之间的数据传输方式
    通过特殊的全局变量, 但是跟程序中的全局变量没关系 

## grammar
1. 数据类型 
- 透明
    float, double, int, uint, bool
- 不透明
    sampler, image, atomic counter

2. 向量与矩阵类型
- float -> vec2, vec3, vec4 -> mat2, mat3, mat4, mat2x2, mat2x3 ... mat4x4
- double -> dvec2, dvec3, dvec4 -> dmat2, 类比float
- int -> ivec2, ivec3, ivec4
- uint -> uvec2, uvce3, uvec4
- bool -> bvec2, bvec3, bvec4

3. 结构体
- 类C语言

4. 数组
- 类似脚本语言, dsl还是脚本语言? 
- length() 是编译时已知的常量

5. 存储限制符
- const, in, out, uniform, buffer, shared

6. 语句
- 算术操作符
- 操作重载
    * 矩阵,向量
- 流控制
- break, continue, return, discard
- discard 只适用于 fragment shader 中, 丢弃当前的fragment, 终止着色器的执行 

7. 函数
- 函数原型, c/c++是基本的概念, 但是真正理解, 还是在学java过程中, 多敲了代码, 理解了, 在λ表达式中实用性最高

8. 参数限制符
- in 默认形式
- const in 将只读数据拷贝到函数中
- out 从函数中获取数据
- inout 将数据拷贝到函数中, 并且返回函数中修饰的数据

9. 计算不变性
- float, double 在不同的硬件上, 表示会有细微的差异, 所以尽量不使用这两个类型的值来判断相等作为执行条件
    const float 在编译器阶段由宿主机计算出来, float 在着色器阶段, 由图形硬件算出来
- invariant
    调试过程中可能需要将着色器中的所有变量都设置了invariant
    #pragma STDGL invariant(all)
    只能影响在图形设备阶段, 保证同样的表达式, 同样的参数值, 出的结果肯定是一样的
- precise
    * 混合乘加运算 fused multiply-and-add, fma
     precise 告诉编译器, 使用同一种乘法命令来计算所有的乘法表达式, 避免不同乘法指令运算所带来的微小差异

## 预处理
1. 预处理命令
- #define, #undef
- #if, #ifdef, #ifndef, #else, #elif, #endif
- #error text 强制将text文字插入到着色器信息日志中, 可用作调试
- #pragma options
- #extension options
- # version number
- #line options 设置诊断行号

2. 宏定义
- 只可定义一些单一的值, 不支持字符串替换以及预编译连接符 
- __LINE__ 行号, 默认已处理的所有换行符的个数加一
- __FILE__ 当前处理的源字符串编号
- __VERSION__ 着色语言版本的整数表示形式

3. 编译器控制
- 默认所有的着色器都开启了优化选项
#pragma optimize(on)

- 额外诊断信息输出, 默认禁用
#pragma debug(off)

4. 扩展功能处理
- #extension extension_name : <diretive>
  #extension all : <directive>

- <directive> 选项
    * require
    * enable
    * warn
    * disable

##　数据块接口
- uniform 块, 类似于struct语法
    * uniform 变量的地址是在着色器链接的时候产生的, 且同时存在于着色器与应用程序中, 因此需要两边都更新
    * uniform 块必须在全局作用域声明
    * 访问一组uniform变量 glMapBuffer()
- uniform 布局控制 
    * shared 默认布局方式, 程序间共享
    * packed 占用最小内存, 但会禁止程序间共享
    * std140, std430, 标准方式设置 uniform, buffer
    * row_major 行主序
      layout(shared, row_major) uniform{...};
    * column_major 列主序

- buffer块
    * 类似于uniform 块, 比uniform块更强大
    * 着色器可写入buffer块
    * 在渲染之前决定其大小

- in/out块
    * 输入,输出的布局是匹配的

## 着色器编译
- 着色器的编译和链接是使用OpenGL API, 相当于内置编译器, 跟c/c++编译的流程同理
- 着色器的代码同样可以复用, 所以有链接过程
- 编写, 关联, 编译链接, 错误检查, 使用
- 链接成功, 新的着色程序才会替代旧的, 否则, 旧的依旧可用
- 得到着色器对象, 可以删除文件的关联, 直到下一次再编译
    * glDeleteShader
    * shader 和 program
    > shader 是与file关联的? program 是最终要使用的?
- 了程序设置
    * subroutine

## vertex shader, fragment shader, OpenGL中没有默认的, 必须写, geometry shader 也可以配置
1. vertext buffer
- 在 vertex shader处理过程中, 会将坐标转成标准化形式
- 坐标转成Uniform形式, 有没有明确的指令操作
- glGenVertex(), glBindVertex, glBufferData()

2. fragment shader
- 确定每个像素点最终的颜色值 attribute fragment, (全局光照, 阴影, 光的颜色)
- 

## OpenGL 与 shader 交互
1. shader 语法 
- shader 语法要记的东西也很多
- 看了毛星云的博客, 人家也是90后, 16年硕士毕业, 可能是91年的
- 我真的是落后太多, 而且智商也没那么突出, 主要是, 现在还有那么多让人分心的事, 自己也不能强迫进入高度集中心流之中
- 慢慢来, 但是其他的时间, 还真不能再无所事事了, 其实也就那么些东西, 我相信自己的智商还是能拿下的, 剩下的就是时间与坚持
- 努力, 坚持, 从某些角度来分析, 能分析出贬义, 但是从另一些角度, 也一样是积极的, 每种分析都有其片面性, 在特定场景下 
- 所以, 我得时刻注意, 说服不了自己的时候, 跳出来想一想, 调节在绝对与摇摆不定之间的度

- VertexArray 与 Buffer
    * 不要VertexArray, 直接生成Buffer绑定, 也是可以正确画出图形, 可能是生成默认的 VertexArray
    * vertex array 与 buffer 是对应的, vertex array 是 可编程OpenGL代码中的array, buffer 是OpenGL server 中的操作内存, vertex array 需要向buffer 中 transfer

2. OpenGL 状态机, 渲染流程 
- api一个个记, 300多个, 还有重复的 
- 重温了下渲染流程, 有所收获, 感觉还是看书爽一些
- OpenGL 是一个C/S 架构, 状态机的模式, 流程是按 pipeline 走, 中间的一些stage 提供可编程shader
- 有一些全局变量, 有一些预设变量, 所有的数据都放在buffer中, vertex array 也是必不可少的, 这些都是缓存数据的容器
    我总对这些有一些顾虑, 怕乱用报这些buffer, 这些考虑是正确的, 但是, 初学的时候, 先大可不必在意这些, 熟悉了编程的流程, 自然会想着优化
    这些代码, 肯定都是要抛弃的, 唯一的用处, 有一些典型的代码用来作为反而教材使用
- 先也不按网上的各种观点, 图形学的就业, 上限之类的, 至少在我现在看来, 这是基础, 学习这所练习的能力, 都是我感兴趣的, 这就足够了
能将各种艺术, 各个领域结合起来的技术, 我怕什么呢? 不要再因此种缘由耗费精力了
- 不要再因此种缘由耗费精力了, 这句话也说了好多遍, 说了好多年了, 总是会因为这中间的大大小小的问题, 动摇初衷, 浪费不必要的精力
- 主要也是, 每一个有点规模的计划, 都没能坚持下来, 达到可以说服自己的标准, 所以, 才会随时动摇

## 疑问
1. vertex 和 fragment 中分别可以做什么?
- 按照 pipeline的流程, vertex shader 中处理坐标变换, fragment shader中处理最终颜色值
- vertex 中可以得到法线, 颜色数据, 传给 fragment处理, 仅仅是传递作用
- 运算还是CPU擅长, GPU尽量少做运算, 所以, 有uniform 赋值一说
  
2. 