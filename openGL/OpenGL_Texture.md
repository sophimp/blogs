
## 纹理
0. 纹理坐标
- 0.0f ~ 1.0f
- 可以传递大量的数据
- 每个顶点增加细节, 从而创建有趣的图像

1. 纹理环绕方式
- repeat, mirror, clamp to edge, clamp to border
- glTexParameter*()

2. 纹理过滤
- 纹理坐标不依赖分辨率
- gl_nearest
- gl_linear
- glTexParameter
- 多级渐远纹理 (Mipmap)  
    * glGenerateMipmaps
    * gl_nearest_mipmap_nearest, gl_linear_mipmap_nearest, gl_nearest_mipmap_linear, gl_linear_mipmap_linear
    * 未测试

3. 加载与创建纹理
    * stbi_image 库
    * glTexture2D();  pixel_format, GL_RGB, GL_RGBA, PNG有 alpha通道
4. 生成纹理
5. 应用纹理
6. 纹理单元

7. GL_ARRAY_BUFFER, GL_VERTEX_BUFFER
- 有区别
- glBind* 更新状态, 开始使用, glActive
- 

8. tranformation
- 原理也不是特别难, 计算按规则来也不是很难, 运用到程序也不是很难
- 难在哪里, 求一般的变换矩阵
- 先会用吧, 后续再深入研究

9. Coordinate System
- 一个vertex 转换为 fragment之前， 要经历的几个状态
    -> Local Space -> World Space -> View  Space -> Clip Space -> Screen Space
- 平头截体 
    * 自带坐标空间？  或只是世界坐标的一个区间? 也叫 clip space, 确定是后者， 只是世界坐标范围的一个区间
    * 接下来的步骤是将这个区间转换成标准化设备坐标系, 需要乘以一个矩阵
    * 剪裁空间是一个平面还是一个立体？
- 透视除法
    * 将4D剪裁空间坐标转换为3D标准化设备坐标, 在每个顶点着色器运行后被自动执行
    * 
- 每一步都是一个固定的矩阵可以解决的， 如里有必要， 还可以将多个矩阵综合成一个矩阵来计算
- ZBuffer
    * glEnable(GL_DEPTH_TEST);
    * glClear(GL_DEPTH_BUFFER_BIT);

10. 