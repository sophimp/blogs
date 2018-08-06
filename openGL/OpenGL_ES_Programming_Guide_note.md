
1. task:
    * Introduction to EGL
    * Vertex Attributes, Vertext Arrays and Buffer Objects
    * computer graphics
    * 从代码入手
    * 
            
2.Introduction to EGL
    - 半小时能看多少?
        - 前5分钟跑了神, 想到了写书, 孩子的教育, 我自己的准备
            可见跑神的状态, 是思维的状态高峰, 短短几分钟, 可以想好多事情
            而将这些字敲下来,也不过2分钟, 所以, 如果注意力集中, 效率高了, 还是可以做很多事
        - 看书心态:
            避免只看一遍的思想, 头一遍不懂的先过, 然后回过头来再细看一遍
            pipeline 的概念熟悉不也是耗了多少遍精力才熟悉了
        - EGL 简介, 还记不住几个

    - 再来两小时能看多少
        - 前15分钟, 放松身体
        - 看了20分钟, 没进入状态, 跑神, 无精神
        - 做了几分钟运动, 渐进状态
        - EGL: 
            配置, 初始化, 负责创建一个 Surface 与本地 window 交互, 出现创建不成功的可能 EGLError
            除了 on-screen, 还有 off-screen 
        - off-screen:
            pbuffer, Framebuffer Objects, 后者更高效, 但是前者可以当 texture 被其他api使用, 并且可以渲染到 off-screen 上
            创建 pbuffer: EGL_BUFFER_TYPE 包含 EGL_PBUFFER_BIT
        - the entire process starting with the initialization of the EGL through binding an EGLContext to an EGLRenderSurface
            绑定EGLContext 到 EGLRenderSurface 完整的初始化处理过程

3. Vertex Attributes, Vertext Arrays and Buffer Objects
    - 先将书上的代码移到as中, 再转成 java代码
    - 没看到java提供的api 中对 GLES20 的初始化相关工作
    - 书上带的代码已经有了java版本, 先看看这些代码的效果, 然后再研习
    - 

4. computer graphics:
    - about film and image
    - refer to vast area, medical, visualation except text or sound
    - handle image, 2d, 3d
    - methodology depends heavily on the underlying science of geometry,optics,physics

5. 从代码入手:
    - ByteBuffer -> FloatBuffer
        ByteBuffer.allocate 速度快, 由于没有原因, FloatBuffer 没有 allocate
        FloatBuffer 共享 ByteBuffer 内存
        ByteBuffer 和 其他NIO 类 在本地代码中有加速优化
        NIO: java new I/O
    - 分析了 HelloTriangle 的代码, 感觉还是不错的, 是一个突破口, 能翻墙了, 美滋滋
    - 翻墙了, 用谷歌搜索, 就是有一种依赖的感觉, 心里那点担忧都没有了, 
    根本还是可以看英文
    - 其实之前还是心理原因, 要是能一直沉下来搞, 早就没其他问题了
    - 

6. 
