
## Camera
1. 坐标系建立
- Cram Schmidt process
- 格拉姆--施密特正交化
- 内积

2. 位移向量为何和轴向量是正交的关系？
- 是我看错了， 求解 LookAt 矩阵, 需要矩阵相乘， 前一个是行矩阵， 后一个是单位列矩阵， 矩阵相乘， 本来就是要 行x列
    * scale, rotate, translate 矩阵 是根据矩阵运算的特性, 计算出来的特殊矩阵
    * world -> view 只需要经过 rotate 和 translate, 
        N = R*T ->(逆运算得到view 矩阵) N^-1 = (R*T)^-1 -> N^-1 = R^T * T^-1
    * 所以本来都是列矩阵, 但是组合在一起就是 R的转置 * T的列矩阵
    * OpenGL 是列列矩阵, D3D是行矩阵
    * 两个矩阵的组合变化可以放在一个增广矩阵中? 并不是, 增广矩阵是加上一个常数列, 跟 
    * rotate 矩阵怎么求?
        使用 Cram-Schmidt正交化求出来的View正交坐标系的基, (一个坐标系转换到另一坐标系, 直接乘以另一个坐标系的基向量? 然后再施以平移?)
        使用向量分解法可求得, 目标坐标系在原坐标系的坐标 * 目标后的坐标
        原坐标在新坐标上的投影
    * 平移向量又怎么求? 原码上是 -Dot(s,p), -Dot(v,p), -Dot(f,p), 这是为何? 不应该是相减么?
    * 格拉姆-施密特正交化, 没看明白, 太多新名词
    * 矩阵要像现在这样规定的计算?

- 如何求解 LookAt矩阵？
    * scale -> rotate -> translate
    * model 矩阵就是将 view sapce 按上述步骤 变换到 world space
    * ModelView 矩阵结合起来就是 LookAt矩阵

3. glut 的循环渲染
- 时间回调
    * glutTimeFunc, 这里面的函数是一个计时器, 不用担心递归栈满
    * 或者说是我等待的时间太短? 有递归满的那一刻
- 时间回调可以解决暂时的动画系统
    * 键盘控制camera不够精细

4. 欧拉角
- 如何求得方向变量
    * pitch, yaw, roll 与 direction 
- 万向锁    
- 改变 cameraPos 与 perspective fov 
    都会改变 frustum 大小

5. quaternion
- 

6. Camera 类封装
- 