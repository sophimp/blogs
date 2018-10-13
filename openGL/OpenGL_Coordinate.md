
1. tranformation
- 原理也不是特别难, 计算按规则来也不是很难, 运用到程序也不是很难
- 难在哪里, 求一般的变换矩阵
- 先会用吧, 后续再深入研究

2. Coordinate System
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

3. frustum
- GL_PROJECTION
    eye coordinate -> clip coordinate -> NDC
    * eye coordinate, 跟world coordinate 有何区别
    * clip coordinate, 屏蔽坐标系的齐次表示, 实际是二维的？
        是三维的齐次坐标表示， NDC也是三维的, Normalize Device Coordinate
    * integrate both clipping(frustum culling) and NDC transformations

- Homogeneous Coordinate
    * Euclidean space, Cartesian space, projective space
    * infinity, meaningless
    * 奇次坐标特性：
        > 1. 使用 N+1 维表示 N 维, 反之将到 N 维， 只需除以 w
        > 2. w 等0， 代表无穷远点
        > 3. scale invariant
        > 4. 经过矩阵乘法后， w 值是会变的

- world space --- translate, rotate ---> eye space
    * eye space --- projection matrix ---> clip space
        > projection matrix 是如何求得?
            1. In OpenGL, a 3D point in eye space is projected onto the near plane
            2. using ratio of similar triangles, 可以得到 x,y可以用z表示， 且是除以Z关系, 这与齐次坐标定义吻合
        > 投影矩阵是将3D的点投影到近平面上， 使用三角形近似法， 三维降到二维， 计算出来的坐标当然是齐次坐标
        > 近平面是与z轴正交， 与xy平面平行的(在 eye space中)， 这样的近似法并不会改变z的值， 所以保留下来的z， 可以作为depth的依据
    * clip space ---> divide w ---> NDC
        为何除以w 就可以了， 这个w 是怎么选的, w不是选的， 最开始 object space 时是1， 经过一系列transformation， 矩阵乘法是会改变其值
        将其降到三维， 同样是除以 W
        > 参考上一步， 映射到NDC是一个 (-1,1)的立方体空间, 这个立方体空间本就是人为规定的， 转换成标准的更容易算, 是frustum的中心线为坐标轴
        > 并不是所有的坐标除以w 都在 (-1, 1)范围内， 但是由于是相似法求得映射坐标， 所以可以确定， 在frustum内的点， 除以w都是在（-1，1）内的
        > 不在(-1, 1)范围内的， 都不在frustum里， 所以要剪裁掉， 这正是在 perspective divide前的坐标叫作 clip space的原因
            取中心轴线构成坐标轴， 容易理解 x,y 的范围在(-1, 1)， z的范围为何也是(-1,1) 呢？ 
            这里就有 OpenGL 与 D3D的区别， OpenGL 的范围是(-1, 1), 是取frumtum 的中心为坐标原点？ D3D 的 z 范围是 (0,1) 是以近平面中心为坐标原点
            而以近平面之外选原点， 除以z的值只会更小， 总之是小于1的
        > z 的坐标只是因为保留了 depth信息， 所以， 最终转换成 NDC 的空间，不管是(-1, 1), (0,1), 或是比1更小,  肯定是填不满的，但是不影响depth信息的有效性, 所以为了统一， 规定NDC为单位立方体空间， 这样更容易图解表示出来， 但是也隐藏了NDC形成的过程(或者说是我太孤陋寡闻了, 这已是学术界约定成俗的规定？)
        > (-w, w) 范围内的都剪裁掉， 是不作透视除法的说法， 这样更加高效，在剪裁空间， 直接按(-w, w)来剪裁， 少了范围外点的除法的步骤
            最后显示在屏幕上， 形状是按 x,y来确定， z是用来确定遮挡的
    * NDC ---> divide z ---> screen space, 又降一维, 确实很奇妙
        在相似三角形的计算坐标过程中， 分别以 xy, yz(或xz, 最终结果应该是一样的，与z的比例是一样的) 来计算， 透视投影到近平面上， 所以， 这个投影坐标已经是一个平面坐标的齐次坐标了

- 矩阵为何能代表那些变换?
    * 从二维点, 向量的旋转, 平移缩放， 可能找到结果是x' = ax + c, y' = by + d, 
    * 矩阵就是将这些系数抽出来， 按照统一的方式， 一起计算
    * 行/列矩阵的 每一行/列 都代表对应的轴和平移系数, 最后再与 x,y,z 向量一乘， 就能组合成一个方程组
    * 所以，矩阵只是一个解方程组的工具, 一种数学工具, 这个工具的思想就是将解方程的过程抽象化
    * 而行列式， 也是计算方程组的一个工具， 矩阵计算过程中的一些技巧和特性， 可能是在抽象出来后发现完善的
    * 矩阵定义是用来表示一个线性方程(所谓线性方程都是一次的)中点的变化的过程
    * 行列式是用来解出线性方程的解
    * 行列式与矩阵是两个不同的定义， 行列式可表示线性变换中对空间面积或体积的影响, 矩阵来左右线性变换， 行列式分别表示变换前后的面积或体积, 因此比值可以用来衡量矩阵？
    