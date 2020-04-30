
## 努比亚 z20 移植, 和k30 pro移植


### android 10.0.0_r33代码同步出了问题

一直同步不下来，不知道是源的原因还是墙的原因。

aosp.tuna.tsinghua.edu.cn 一直没同步下来

然后翻墙， android.googlesource.com 好几次也没同步下来，多试几次最后成功了

可能不是墙的问题吧， 就是网络的问题， 中间出现好几次下载到一半， early EOF 了


### android 9.0, 10.0

9.0 还没有真正意义上支持android.bp, 至少在mokee中的device, vendor中配置中没有支持

10.0 倒是支持bp了， 但是 PATH_OVERRIDE_SOONG, KERNEL_MAKE_FLAGS 这些变量都没有配置对， 是我的device中要配置？ 这也不应该，可能需要下载一个完好的10.0的机型来搞， 但是这时间又不够了。 

bp 与 mk 互换， 已经有工具可以将 mk 转成 bp, 但是还没有见到将bp转成mk的

