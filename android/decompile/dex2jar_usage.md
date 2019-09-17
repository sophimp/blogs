
## linux dex2jar

经常要打包 telephony.internal 下的类, 从源码中编译出来的telephony-common.jar 解压出来的是 dex 文件
因此, 需要将其转其jar

linux 下的 [dex2jar](https://github.com/pxb1988/dex2jar) 是开源的代码

也可以直接 sudo apt isntall dex2jar

自编译的dex2jar 全是java 代码, 需使用脚本
