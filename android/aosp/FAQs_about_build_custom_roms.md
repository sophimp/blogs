
## [FAQs and Common errors whille building custom roms (转)](https://forum.xda-developers.com/android/help/faqs-common-error-building-custom-roms-t3617238#post80074544)

Disclaimer:
Code:
All these FAQs and Solutions are taken from my knowledge and experience if anything wrong please point out so I can correct it.And feel free to add more FAQs and Errors from your side
Disclaimer: All these FAQs and Solutions are taken from my knowledge and experience if anything wrong please point out so I can correct it.And feel free to add more FAQs and Errors from your side

FAQ #1 : Easiest way to setup build environment ?
Answer: Their is a script will will make all the work easy by @akhilnarang
Steps to be followed:

Code:
git clone https://github.com/akhilnarang/scripts
cd scripts
bash setup/<name of script>

FAQ #2: Which is the best distro to build custom rom?

Answer: I will always recommend to use Ubuntu 14.04
Download Link : DOWNLOAD NOW

FAQ #3:If I have low internet speed how to sync sources that too 60Gb and all?

Answer: Use Google cloud Platform which is the best because internet speed syncs source within half an hour build speed max 2hour first build then less than 30mins

FAQ #4: Is any programming language required to study while building ROMs?

Answer: Absolutely No since for making roms from source you just require BASIC English thats it and few logic how does fuctions work etc.

FAQ #5: I have MacBook can I built on it since it is having BASH terminal?

Answer:Sure you don't need to install another distro inbuilt Mac OS is enough.

FAQ #6: While building it stopped what to do ?

Answer: Simplest way is copy whole data and paste in any IDE and search for "FAILED:" line and read it understand what made wrong then google how to fix it,Few common errors and their fixed are their below just bookmark if you need.

FAQ #7:I Googled still not found a solution how to fix it ?

Answer: Their are many ways ask on XDA else you get contact with developer of that rom message him and resolve it.

FAQ #8: Is there any full tutorial for NOOB users ?
Answer:
1 [GUIDE: Android ROM Development From Source To End (COMPLETE)](https://forum.xda-developers.com/chef-central/android/guide-android-rom-development-t2814763) 
2 [GUIDE: A Noob Guide On Building Your Own Custom Kernel (ARM & MTK) (ARM64 coming)](https://forum.xda-developers.com/android/software/guide-easy-kernel-building-tutorial-t3581057)
3 [GUIDE: (COMPLETE)How to build ROM with Google Cloud](https://forum.xda-developers.com/chef-central/android/guide-how-to-build-rom-google-cloud-t3360430)

FAQ #9: What is Cherry-picking is please explain?

Answer: It is actually taking a feature of one rom and then add to your rom by giving proper credits to author etc.There is a good tutorial for doing this refer to this
How to apply patches to the source ?.This will surely help you a lot.

FAQ #10: Is there any place where I can get full details of rom files folders etc ?

Answer: Yes there is an awesome post explaining everything.
[GUIDE] Understanding the Android Source Code

FAQ #11: I have one commit which is commit but I need to add proper author to it what to do?

Answer:
git commit --amend --author="NAME "
This will add author to last commit

FAQ #12: I have done changes I need to overwrite the commit its not allowing asking for pull and retry like that.

Answer: do same git push command just add " -f " tag so it overwrites the git.
for e.g.: " git push GitHub 7x -f "instead of "git push GitHub 7x "

FAQ #13: Any Simple way to resolve conflicts while cherry-picking ?

Answer: The best way is to use search tool and search for ">>>","<<<","===" remove, add keep both depending on code.Second Method is by using GitHub as search.

FAQ #14: Is there any simpler way to check cherry-picked correctly or not since building whole ROM takes time.

Answer: Build only the required package to check if it worked correctly then build Rom as whole .For e.g. you made changes to kernel and device tree in that case just use time mka boot image rather than time mka bacon.

FAQ #15:How to remove snap camera from building?

Answer:Remove Snap from BoardConfig and use zip contents and manifest to see what permissions to do, use PRODUCT_COPY_FILES command

FAQ #16: How is flashable ZIP of kernels made ?

Answer:Android zips have updater-script which is programmed in edifier,You basically need to make a flashable zip which would write boot.img into /dev/block/bla/bla/boot.

FAQ #17: Should I dexpreopt my builds?

Answer: Not necessary it is just first boot speeding up and take extra size around 100mb more.

FAQ #18: What does boot.img contain?

Answer: it has kernel and ramdisk

FAQ #19 What are BLOBS?

Answer: Blobs are vendor files and prebuilt libs which are found in system, importing them is copy paste + the mk file, It's usually found in /system/vendor and /system/lib.

Common Errors:

All these erros I mention are faced by me and solution which I did is written along.
- 1:
libwpa_qmi_eap_proxy_
intermediates/export_includes', needed by '/home/vibhoothiiaanand/nuclea/out/target/product/oneplus2/obj/EXECUTABLE
S/wpa_supplicant_intermediates/import_includes', missing and no known rule to make it
make: *** [ninja_wrapper] Error 1
Solution:
First check wheather your vendor repo is broken or not or is it included or not if not clone it from correct source.
Clone wpa supplicant ,wpa_supplicant8 from lineageos and retry it

- 2:Build is successful but its not booting what to do?

Solution: Make another build with permissive by adding
"androidboot.selinux=permissive" to BoardConfig.mk it should work.

-  3:I have synced device tree but device is not showing in breakfast nor lunch menu

Solution:
1.first change romname.mk file to your rom name ,for e.g. you synced Du tree and trying to make nitrogen rom so mv du.mk nitrogen.mk.
2.Change vendorsetup.sh make appropriate name of device name with rom.
3.Change .dependencies name to rom name for e.g.. du.dependencies make it nitrogen.dependencies
4.Make AndroidProducts.mk and call device.mk from it.
Will show you how things are done.
Oneplus2 device tree modded for supporting VertexOS: Vertex-fy
Oneplus2 device tree modded for supporting Candy Rom :Candify
there will be so much commits like this just git search then your good to go.
This must be general case for most of the rom and devices just refer this.

- 4:

ninja: error: '/home/vibhoothiiaanand/nitrogen/out/target/product/oneplus2/obj/SHARED_LIBRARIES/libqdutils_intermediates/export_includes', needed by '/home/vibhoo
thiiaanand/nitrogen/out/target/product/oneplus2/obj/SHARED_LIBRARIES/libsurfaceflinger_intermediates/import_includes', missing and no known rule to make it
make: *** [ninja_wrapper] Error 1
Solution:
this is common error and its due to missing hardware BLOBs so to fix this there are few things to clone
these files are to cross checked if not clone from lineage
hardware/qcom/display
hardware/qcom/display-caf
hardware/qcom/audio
hardware/qcom/audio-caf
hardware/qcom/media
hardware/qcom/media-caf
hardware/qcom/bootctrl
hardware/qcom/bt
hardware/qcom/bt-caf
hardware/qcom/camera
hardware/qcom/gps
hardware/qcom/wlan
hardware/qcom/wlan-caf
hardware/qcom/keymaster
and for cloning I will show you how its done for Oneplus2
git clone https://github.com/LineageOS/android...om_display.git -b cm-14.1 hardware/qcom/display/msm8994
git clone https://github.com/LineageOS/android...qcom_audio.git -b cm-14.1 hardware/qcom/audio/msm8994
git clone https://github.com/LineageOS/android...qcom_media.git -b cm-14.1 hardware/qcom/media/msm8994 git clone https://github.com/LineageOS/android...om_display.git -b cm-14.1-caf-8994 hardware/qcom/display-caf/msm8994
git clone https://github.com/LineageOS/android...qcom_audio.git -b cm-14.1-caf-8994 hardware/qcom/audio-caf/msm8994
git clone https://github.com/LineageOS/android...qcom_media.git -b cm-14.1-caf-8994 hardware/qcom/media-caf/msm8994
- 5
device/generic/goldfish/data/etc/apns-conf.xml', needed by '/home/vibhoothiiaanand/nitrogen/out/target/product/oneplus2/system/etc/apns-conf.xml',
missing and no known rule to make it.
Solution:
just clone generic/goldfish from google since its old AF in lineage source
git clone https://android.googlesource.com/dev...neric/goldfish device/generic/goldfish

- 6
frameworks/native/build/phone-xxxhdpi-4096-dalvik-heap.mk" does not exist. Stop.

Solution:
Fix is just cherry-pick this commit
https://github.com/CyanogenMod/andro...4987ad7bfcb4ab
Done it must be fixed

- 7
ERROR: couldn't find ro.product.model in build.prop

Solution:
This is not that common but this happens while compiling
fix is cherry-pick this commit
https://github.com/AICP/build/commit...e6772503ca0f65

- 8
Model number unknown.

Solution:
Go to device tree and open init/init*.cpp make device name and instead of std::string device = property_get("ro..device"); change to std::string device = property_get("ro.product.device");

- 9
Deleting obsolete path /home/vibhoothiiaanand/vertex/device/oneplus/oneplus2
Deleting obsolete path /home/vibhoothiiaanand/vertex/device/oppo/common
Deleting obsolete path /home/vibhoothiiaanand/vertex/kernel/oneplus/msm8894
Deleting obsolete path /home/vibhoothiiaanand/vertex/vendor/oneplus

Solution:
this is due to not declaring repos in local manifest

- 10 Broken gestures
for this two things must be noted kernel and device common must match the node names in case of oneplus2
in kernel: drivers/input/touchscreen/synaptics_driver_s3320.c and configpanel/src/com/cyanogenmod/settings/device/utils/Constants.java should match node declaration values

- 11 Dex2oated errors
it usually look like this


For this easy fix is disabling dexpreopt

- 12 ninja: error: '/home/vibhoothiiaanand/vertex/out/target/common/obj/JAVA_LIBRARIES/rcscommon_intermediates/javalib.jar', needed by '/home/vibhoothiiaanand/vertex/out/target/product/oneplus2/dex_bootjars/system/framework/arm64/boot.art', missing and no known rule to make it
make: *** [ninja_wrapper] Error 1
make: Leaving directory `/home/vibhoothiiaanand/vertex'
For me this happened while building vertex for that I removed telephony entry from android_vendor_vertex/config/common.mk

- 13 /out/target/product/oneplus2/obj/SHARED_LIBRARIES/libdhcpcd_intermediates/export_includes', needed by '/home/coolmohammad98/cr/out/target/product/oneplus2/obj/EXECUTABLES/ipacm_intermediates/

Solution
For this clone https://github.com/lineageos/android...l_libnfnetlink and then your good to go

