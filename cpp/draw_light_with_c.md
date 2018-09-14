
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

6. stitch

## 画光