## 编译完后的rom 文件

    system.img, ramdisk.img, userdata.img, boot.img, recovery.img

## 刷机

    [刷机原理，引用自知乎](https://zhuanlan.zhihu.com/p/19635679)

## 替换launcher

[修改system.img](https://blog.csdn.net/u010164190/article/details/70432642)

生成oat文件 

> dex2oat --runtime-arg -Xms64m --runtime-arg -Xmx512m --dex-file=/data/local/tmp/Launcher3.dex --dex-location=~/aosp/aosp_build/Launcher3.apk --oat-file=~/aosp/aosp_build/Launcher3.odex --android-root=/system --instruction-set=armv8a --instruction-set-variant=armv8a --instruction-set-features=default --include-patch-information --runtime-arg -Xnorelocate --no-generate-debug-info --abort-on-hard-verifier-error

还是没有成功
    launcher 需要系统签名，系统可设置安装的时候动态编译oat
    明天下载一个小米的img, 搞到Launcher试一试

## 遇到问题
1. fastboot device

no permissions (user in plugdev group; are your udev rules wrong?); see [http://developer.android.com/tools/device.html]	fastboot

[解决办法](https://cxuef.github.io/android/Nexus-5X-%E5%88%B7%E5%85%A5Android-N-Preview%E5%8A%A8%E6%89%8B%E5%AE%9E%E8%B7%B5/)
修改.rules文件
 
## 参考资源

[源码编译, 模块编译，sdk 编译](https://www.jianshu.com/p/9605f895d153)
[rom刷机](https://www.jianshu.com/p/afc3f1e3515b)
[android 9.0 刷机](https://www.intellectsoft.net/blog/build-and-run-android-from-aosp-source-code-to-a-nexus-7/)
