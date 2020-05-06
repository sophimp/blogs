
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

### lineage 

为何好多人都是先移植lineage OS 呢？ 

Lineage OS 相对于 Mokee 更加纯粹一些, 为了技术和便利。 Mokee 就涉及到利益了， 且是依托于LineageOS的。


### red mi k30

Q: biso, flex path tool is not allowed to be used

A: export TEMPRORARY_DISABLE_PATH_RESTRICTIONS=true

进展比较顺利, soong编译链工具的问题， 竟然都给了链接, 虽然没有细看具体是为什么， 但是不妨碍解决了问题

