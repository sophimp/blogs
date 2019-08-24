
## 工具

[split_bootimg.pl]() 是一个perl 写的脚本工具, 按照boot.img 格式读取

mkbootfs, mkbootimg, bootsigner: 编译源码会在out/host/linux-x86/bin 下生成, 也可以从[官网上下载](http://code.google.com/p/android-serialport-api/downloads/detail?name=android_bootimg_tools.tar.gz&can=2&q=)

## 具体步䯅

``` sh
	split_bootimg.pl boot.img # 会得到 boot.img-kernel, boot.img-ramdisk.gz

	mkdir ramdisk | cd ramdisk 
	gzip -dc ../boot.img-ramdisk.gz | cpio -i # 会在ramdisk 下将得到所有内容, 做想要的修改

	cd .. # 返回ramdisk 上一层目录
	mkbootfs ramdisk | gzip > ramdisk.img # 制作ramdisk.img
	
	# 以nubia z18mini 的内核命令打包

	# cmdline : "androidboot.hardware=qcom user_debug=31 msm_rtb.filter=0x37 ehci-hcd.park=3 lpm_levels.sleep_disabled=1 sched_enable_hmp=1 sched_enable_power_aware=1 service_locator.enable=1 swiotlb=1 androidboot.configfs=true androidboot.usbcontroller=a800000.dwc3 buildvariant=user"

	# cmdline: "console=ttyMSM0,115200,n8 androidboot.console=ttyMSM0 earlycon=msm_serial_dm,0xc1700000000 androidboot.hardware=qcom user_debug=31 msm_rtb.filter=0x237 ehci-hcd.park=3 lpm_levels.sleep_disabled=1 sched_enable_hmp=1 sched_enable_power_aware=1 service_locator.enable=1 swiotlb=1 androidboot.configfs=true androidboot.usbcontroller=a800000.dwc3 buildvariant=userdebug"

	mkbootimg --kernel kernel --ramdisk ramdisk.img --base 0x00000000 --pagesize 4096  --cmdline "androidboot.hardware=qcom user_debug=31 msm_rtb.filter=0x37 ehci-hcd.park=3 lpm_levels.sleep_disabled=1 sched_enable_hmp=1 sched_enable_power_aware=1 service_locator.enable=1 swiotlb=1 androidboot.configfs=true androidboot.usbcontroller=a800000.dwc3 buildvariant=user" --os_version 8.1.0 --os_patch_level 2019-08-25 --output boot_new.img

	# 签名 在官方开源的内核源码中有
	boot_signer /boot boot.img verity.pk8 verity.x509.pem boot_signer.img

```
