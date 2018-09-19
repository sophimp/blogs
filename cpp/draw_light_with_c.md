
## C语言 图形学基础知识学习
    学习 Milo Yip 在知乎专栏发表教程

##　画直线
1. Bresenham (布雷森汉姆: 发音就按这个来吧)
- 优化 bresenham

2. sampling 
- capsule 碰撞检测
- super sampling, 每个像素取5x5像素半透明模糊

3. sdf
- signed distance field

4. AABB
- axis-aligned bounding box
- 轴对称图形
- 优化的效果很明显, 此种方案速度最快
- 定向选取外切矩形来计算

5. OBB
- oriented bounding box
- 多算一步, 但是可按最小外切矩形来算
- 更精细一些

6. stitch heart
-   

## 画光
1. 蒙特卡罗积分
- 用来随机性采样, 算光的亮度值

2. 均匀采样, 分层采样, 抖动采样

3. 光线追踪步进算法
- 所谓光最终是要算出当前点的颜色值  
- 每个点按照均等方向步进, 能碰到发光体, 即算是贡献一份当前方向上的亮度
- 算法, 确实有魅力

4. 几何关系
- 并集 union
- 交集 intersection
- 相对补集 relative complement (set difference)

5. SDF表示形状
- 向量的计算, 公式的推导, 都有些力不从心, 看不明白了
- CSG: constructive solid geometry, 以形状 点集的布尔操作来表示模型