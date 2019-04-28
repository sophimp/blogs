## 编译完后的rom 文件

    system.img, ramdisk.img, userdata.img, boot.img, recovery.img

## 刷机

[刷机原理，引用自知乎](https://zhuanlan.zhihu.com/p/19635679)

刷机的基础知识： 

        手机的软件大概分成几个部分：Radio（基带）,Bootloader（引导模式）,Recovery（恢复模式）,以及我们日常用的系统。刷机,可能只刷系统，也可能全部都刷。

        ADB/fastboot：Google 做的一套用来在电脑上通过 USB 线来调试手机的程序,用这个程序,我们可以（主要是在命令行界面敲 adb/fastboot 命令，也有一些人制作图形界面）调试、控制手机。「线刷」用的就是这个。

        Bootloader 模式（Fastboot 模式、引导模式）：关机状态下长按音量下+电源就可以进入，大概是图 1 的样子这个时候按音量键可以上下选择，Start - 正常开机、Recovery mode - 进入恢复模式、Restart bootloader - 重启引导模式、Power off - 关机，按电源键确认。这个模式下把手机连到电脑上就可以用命令调试。注意最下面的「LOCK STATE」，表示你的 bootloader 是否已经解锁。

        Recovery 模式（恢复模式）：相当于一个小型系统，可以用来把手机里的「刷机包」（也就是一个压缩包）刷到手机里，「卡刷」用的就是这个

## 替换launcher

1.  [修改system.img](https://www.cnblogs.com/l2rf/p/4229157.html)

    > 生成oat文件 

    >dex2oat --runtime-arg -Xms64m --runtime-arg -Xmx512m --dex-file=/data/local/tmp/Launcher3.dex --dex-location=~/aosp/aosp_build/Launcher3.apk --oat-file=~/aosp/aosp_build/Launcher3.odex --android-root=/system --instruction-set=armv8a --instruction-set-variant=armv8a --instruction-set-features=default --include-patch-information --runtime-arg -Xnorelocate --no-generate-debug-info --abort-on-hard-verifier-error

没有成功, launcher 需要系统签名，系统可设置安装的时候动态编译oat

2. 直接下载现成的launcher
    下载小米的launcher 可以安装成功， 但是不能启动， 猜测是小米的launcher对自身的系统作了校验 

3. 替换自己开发的app, 可以替换成功

## 生成系统函数签名

[生成系统函数签名](https://www.jianshu.com/p/63d699cffa1a)

    找到平台签名文件“platform.pk8”和“platform.x509.pem”

    文件位置 android/build/target/product/security/

    签名工具“signapk.jar”

    位置：android/prebuilts/sdk/tools/lib

    签名证书“platform.pk8 ”“platform.x509.pem ”，签名工具“signapk.jar ”放置在同一个文件夹；
    执行命令

    java -jar signapk.jar platform.x509.pem platform.pk8 Demo.apk signedDemo.apk

    或者直接在Ubuntu 编译环境执行
    java -jar out/host/linux-x86/framework/signapk.jar build/target/product/security/platform.x509.pem build/target/product/security/platform.pk8 input.apk output.apk

    生成平台platform.keystore文件：

    编译平台签名文件“platform.pk8”和“platform.x509.pem”

    文件位置：android/build/target/product/security/


    把pkcs8格式的私钥转化成pkcs12格式：

    openssl pkcs8 -in platform.pk8 -inform DER -outform PEM -out shared.priv.pem -nocrypt


    把x509.pem公钥转换成pkcs12格式：

    openssl pkcs12 -export -in platform.x509.pem -inkey     shared.priv.pem -out shared.pk12 -name androiddebugkey
    alias: androiddebugkey 密码都是：android


    生成platform.keystore

    keytool -importkeystore -deststorepass android -destkeypass android -destkeystore platform.keystore -srckeystore shared.pk12 -srcstoretype PKCS12 -srcstorepass android -alias androiddebugkey


## 调用系统权限验证

[控制GPS 开关](http://www.itboth.com/d/m6Bjae/android)

    1. 添加权限
    <uses-permission android:name="android.permission.WRITE_SECURE_SETTINGS" />
    2. 在AndroidManifest.xml设置android:sharedUserId="android.uid.system"
    3. 使用上述生成的系统签名
    4. 控制gps
    Settings.Secure.setLocationProviderEnabled(contentResolver, LocationManager.GPS_PROVIDER, true)
    5. 直接生成release应用安装， 测试可成功控制gps
## 遇到问题
1. fastboot device

no permissions (user in plugdev group; are your udev rules wrong?); see [http://developer.android.com/tools/device.html]	fastboot

[解决办法, 修改.rules文件](https://cxuef.github.io/android/Nexus-5X-%E5%88%B7%E5%85%A5Android-N-Preview%E5%8A%A8%E6%89%8B%E5%AE%9E%E8%B7%B5/)

## 定制rom
1. 如何定制其他机型的rom

    组装驱动, 真得可以安装成功吗? 
    编译原码要选哪一个平台呢?

2. wifi, 蓝牙, 通话, 短信功能会不会受到影响

3. Lineageos 和 mokee

    又一次的刷新了新的知识面, 关于刷机, 还是懂得太少啊. 
    这一下子又打开了一扇门, 是可以学习的方向
    清华的, 网络的开源组织们, 果然高人都很多, 也仅需要那几个高人就可以维护一个第三方的rom版本
    为何我动起了歪心思? 打起黑产的主意, 良心的拷问

## 参考资源

[源码编译, 模块编译，sdk 编译](https://www.jianshu.com/p/9605f895d153)

[rom刷机](https://www.jianshu.com/p/afc3f1e3515b)

[android 9.0 刷机](https://www.intellectsoft.net/blog/build-and-run-android-from-aosp-source-code-to-a-nexus-7/)
