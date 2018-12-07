
## openage编译
1. Age of empires 源码
- We do what we must because we can.
- SFT Technologies, 学生气息很足, 很有个性， 是一个不错的学习项目， 涉及的东西很多
- 这是一个engine, 可以专门做此系列的
- 他们也是用来学习c++的，当然还加上感兴趣
- 项目使用开源原生的技术, 且基本上保持最新 c++17, vulkan
- 编译这个项目并不容易，至少对于我现在的水平， 可以学习很多
- 过程有记录的价值, 故此记录之
- 如何消化之后， 写一个逻辑完备（有完整逻辑线）的教程

2. 编译
- gcc >=7 or clang >= 4 
    apt install 
- python >= 3.4
    apt install
- cython >= 0.25
    pip install
- cmake >= 3.1.0
    源码安装, cmake使用起来很爽, 感觉除了使用正版的visual studio, 以后主力的开发平台就放在linux上了
- python image library(PIL)
    pip3 install
- opengl >= 3.3
    卡在这里， 貌似只能通过显卡驱动来升级
    OpenGL的环境一直是个痛点， 不过现在不再那么害怕， 正好学一点linux知识
    如何查看当前的显卡， 集成显卡和独立显卡如何切换
    怎么升级显卡驱动
    VGA 与 Display controller 各是什么
- numpy
    scientific computing library, 使用C写的供python调用库， 使用pip安装
- libepoxy
    源码安装, 整体思路就是从github上找库， 然后看readme
    meson 通过pip3 安装
- libpng
    源码安装，
    ./configure 
    make 
    make install 

- dejavu font
    ubuntu 16.04 自带

- eigen >= 3
    这个artsy 库， 还真难搞， 初步判断是搞素材的工具

- freetype2
- fontconfig
- harfbuzz >= 1.0.0
- nyan
    他们自己的开源工具
- ncurses
- jinja2
- sdl2
- sdl2_image
- opusfile
- opus
- ogg
- pycodestyle
- pygments
- pylint
- qt5 >= 5.9
- vulkan

## OpenGL 如何升级
0. 只能从驱动升级吗？
    * 从ubuntu update, upgrade 方式升级在本机上行不通， 这种方式的思想也是更新显卡驱动，可能是教程中的机器显卡都比较高级， 直接更新了较高的驱动吧？
    * 在window上是可以支持OpenGL4.0的， 所以在linux上应该也行
    * 可不可以像window一样， 只下载几个动态库就行了？

1. 如何查看GPU 型号
    lspci -vnn | grep -i VGA

2. compatible controller, display controller, 3d controller
    * compatible controller 是CPU(还是主板？应该是CPU本身有一些基本的处理图形的能力) 带的集成显卡
    * 后两者是独立显卡, 3d的要更好一些
    *
3. 运行已有的项目
    MESA_GL_VERSION_OVERRIDE=4.5 MESA_GLSL_VERSION_OVERRIDE=450 ./gldemo
    加这一行命令就可以正常运行了， 如何默认使用 4.5呢
    在linux上跑的效果跟window上还有些不一样, linux上更加细腻一些， 且箱子渲染空了
    默认的方法可以使用图形启动设置launch options， 代码的话，暂时先这样， 继续下一步
    如果不使用mesa 管理， 可控性更高一些？

