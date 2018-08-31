
## 继续刚 openGL 
    之前断断续续, 学习了一些openGL相关的知识, 但是一直没有入门, 开发环境, 自主写一个基于openGL的应用, 都不能达到, 接下来的精力, 集中突破openGL, 进入图形学的大门

## 计划
1. 搞环境
- c++开发环境
    clion, mingw
    * 这一步配置没啥难度, 确认, 下载

- openGL 开发环境
    * 一个opengl的环境就一直让我心有戚戚, glut, glew, opengl提供基于操作系统的窗口开发库, 所以, 抛开以前的那些畏惧, 现在是有头绪的 
    * 有必要先了解一下glew, glut库吗, 当然有必要, 了解一下干什么的, 这是前提, 不是细节
        + 核心库 opengl, 可以在任何OpenGL工作的平台上应用
        + 实用库 glu, 通过核心库的函数来实现一些复杂的操作, 轮子再封装, 应用于任何OpenGL工作的平台 
        + 辅助库 glut, aux作为前缀, 窗口管理, 输入输出控制, 跟平台系统绑定, 不是开源的, 可以用其他的库取代, freeglut, OpenGLUT, SFML, SDL, GFLW  
        + 扩展库 glew, 跨平台的c++扩展库, 能自动识别所在平台所支持的全部OpenGL高级扩展函数
    * 第三方库的配置
        + MinGW, 64位的系统, 默认下载的也是32的, 有些烦躁, 最后使用命令编译通过, 但是打不开
    cmake 
    * 编译, 链接的过程, 总是卡在 undefine reference function, 动态库没加载对, 放开手总体搜索下, 为何总是一点点的试
    * opengl的库只有32位的? 使用32位的mingw编译, 系统是64位的, 到底会加载哪一个库呢?
        + 测试出来了, 64位系统默认是加载 SysWOW64中的dll, 而opengl 找的都是32位的库, 还是应该将 32位的dll 放在SysWOW64的文件夹下
        + 这样, 编译也不用指名文件夹, 默认是从SysWOW64中找, 但是这样有一个隐患, 假如是使用到了system32中的其他的库, 编译的时候是否必须要指名文件夹呢?
        + 经过一番查找, 上面的理解还是出错了: system32 和 SysWOW64, 关键是这两个文件夹的迷惑性, SysWOW64只有在64位的系统中有, 用来存放 32位系统的库, 兼容32位程序, 在64位系统中, system32文件夹下装的才真正是64位的库, 当程序应用到了32位的库是, 会自动去SysWOW64的文件夹下找库
        + Program Files 与 Program Files(x86) 没有此问题 
    * 至此, openGL的开发环境是搞定了, 再次印证了那句感悟, 不能全部寄希望于网络, 网络上没有的时候, 根据查找的蛛丝蚂迹思考解决办法, 在这个问题的解决过程中, 初步确定为库加载问题后, 看到g++的带链接路径命令, 因此试验了一下, 编译通过, 且程序提出一堆新的警告, 就知道有戏, 再次打开exe, 却提示找不到 freeglut.dll, 然后再把dll放到SysWOW64文件夹下,就通过了, 因此猜测64位系统会默认加载SysWOW64文件夹下的库, 但是一经资料查找, 并不是这样, SysWOW64是为了兼容32位程序,存放的是32位的库, 只不过32位的程序加载会默认从 system32 文件夹下映射到 SysWOW64文件夹下, 这也可以解释为何 -L"C:\Windows\system32" 会有一堆警告, link to, 正是映射的日志

2. 明确宗旨
- new concept, 先通知大概, 不深究细节
- 深入是待能熟练开发openGL应用后再开始  

3. 找项目
- 渲染出一个三角形
    * 初始的api
    glBegin(GL_TRIANGLES);

- 渲染出一个正方形
    glBegin(GL_QUADS);

- 改变三角形颜色
    glColor3f(1.0f,0.0f, 0.0f);

- glPrimitives: 画点, 画线, strip, fan 
    GL_POINTS, GL_LINES, GL_LINE_LOOP, GL_LINE_STRIP, GL_TRIANGLES, GL_TRIANGLE_STRIP, GL_TRIANGLE_FAN, GL_QUADS, GL_QUAD_STRIP, GL_POLYGON

- 易经转轮
    * 并不需要多么高深的图形学知识, 使用上面的知识, 基本上就能解决了
    * 
- openGL cpp 开发框架搭建
    * c/cpp基本语法, 类的创建, 继承, 实现, 初始化
    * 抽出 glut 窗口工作, 专注于实现渲染代码, shader编写
    * 

- c语言画光
    * 学一下优秀代码
    * 

- craft 项目
    * window10 的环境变量设置完了, 还需要再重启一下, 才能加载? 
    * 也不清楚是下载下来的, 还是从git上同步下来的, 可是同步下来的, 为何又没有git跟踪呢? 
    * 可能加载dll的问题, 还真要重启一次

- dump memory for debugging

## 历程
1. opengl 表面上看, 只是图形渲染的api接口, 但是肯定不只是api接口, 背后是一整套图形学相关的知识, 所以, 不要再轻视, 以为学会了, 也只是调用api? 
2. 此文档, 记录环境配置, OpenGL概述这一章的学习笔记, 初始openGL, 有大量的新名词输入, 先记录之, 后续学习再拓展
3. opengl基础运行环境: glut, openGL32, mingw, glut适配各系统的窗创建, 键盘鼠标事件, 渲染模式, 不难, 无惧
4. 向量, 表示位置和方向, 在图形学中如何思考之? 向量的数学运算, 如何快速运算
5. opengl terminology, 作为手机app第一个功能, 将其存储之 