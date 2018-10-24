
## 说明
1. leetcode 也刷了55道, 除掉easy 也还有20道
2. 刷了终究是有用的, 后面再捡起来, 还是会接着以前的战绩 
3. 有时间就刷吧, 现在先从medium开始刷, 以兔派方式刷

## Container with most water
1. 这个算法, 今天一下子就搞明白了, 按水的流动来理解
2. 加深了暴力枚举的作用的认识

## 3sum
1. 跟container with most water 有类似的思想, 枚举是过不了关的
2. 还未通关, 去除重复有点麻烦

## power(x, n)
1. 递归与循环是可以互换的
2. 位运算
3. for循环是搞不定的

## remove k digits
1. 

## design circular queue
1. 

## cheapest flight within k stops
1. Dijkstra 
- 思路:
    1. 必须有一个起点, 初始化起点到各个城市的花费
    2. 将此城市可到达的城市都放在一个队列里待搜索
    3. 以队列中的城市为起点, 再次编历整个数组, 更新可到达城市的最小花费, 然后将可到达城市再次加入队列
    4. 临界条件, stops == K站的时候, 只比较可到达目的地的站点, 更新目的地的值, 此临界已经不会再向队列中加入城市, 所以是最后一次搜索
        * 问题: 在K站以内, 理论上直达要比多站买票便宜, 直达票在第一次比较中就已经初淘汰了, 怎么办
        * 直达票每有被淘汰, 而是优化更新在了目的地中, 等到中转到目的地, 再比较, 所以不会丢掉值 

- 贪心算法
- 图
    * 图有什么性质
- BFS, DFS, BF
    * Broad First Search
    * Deep First Search
    * Binary Find
- Dijkstra 是复用了广度优先搜索, 优化版本是在缓冲 queue上, 有queue, priorityQueue, Fibonacci heap
2. Bellman
- 
