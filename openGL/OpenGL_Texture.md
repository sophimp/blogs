
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
    glGenTexBuffer
5. 应用纹理
    glActiveTexture
6. 纹理单元
    自行插值

7. GL_ARRAY_BUFFER, GL_VERTEX_BUFFER
- 有区别
- glBind* 更新状态, 开始使用, glActive

8. 纹理是如何映射到模型上的?
- 单位坐标 

9. 纹理是如何插值的？
- 有些纹理不够的地方， 怎么重复的

10. index attribute of vertex