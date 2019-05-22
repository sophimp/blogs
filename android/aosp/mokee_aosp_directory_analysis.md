
## Mokee 与 aosp 工程文件的分析

通过文件夹对比, 了解整个工程结构, aosp的开发流程, mokee系统做了哪些事情

- mokee nexus 5x:

android     bootable        compatibility  development  frameworks  libnativehelper  packages          prebuilts  test
Android.bp  bootstrap.bash  cts            device       hardware    Makefile         pdk               sdk        toolchain
art         build           dalvik         doc          kernel      mokee-sdk        platform_testing  syntax     tools
bionic                      developers     external     libcore     out              plugin            system     vendor

- aosp sargo:

Android.bp   bootable        developers                       frameworks       Makefile          projectFilesBackup   tools
             bootstrap.bash  development                      gen              out               projectFilesBackup1  vendor
             build           device                           hardware         packages          sdk
             compatibility   external                         kernel           pdk               system
art          cts             extract-google_devices-sargo.sh  libcore          platform_testing  test
bionic       dalvik          extract-qcom-sargo.sh            libnativehelper  prebuilts         toolchain

- 不同之处:

android :

    default.xml, snippets/mokee.xml 记录的是整个工程的应用路径,名称,分组

    分组有 pdk, aosp, tools, nopresubmit, vts, darwin, pdk-fs, pdk-cw-fs...  

    应用文件包有 packages, frameworks, prebuilts, pdk, external, art, bionic, cts, dalvik, bootable, device, developers, development, hardware, system, test, tools, mokee-sdk, vendor, 
    基本上每个文件夹下都是应用

    这些配置文件是在什么时候加载的呢? 

    pdk, bionic, cts 代表啥

gen:

    aosp 编译完生成的 aidl 文件

mokee-sdk:


plugin:

syntax:

- 相同之处:
art:

bionic: 
bootable: 
bootstrap.bash:
build: 
compatibility: 
cts: 
dalvik: 
developers: 
development: 
device: 
external: 
frameworks: 
hardware: 
kernel: 
libcord: 
libnativehelper: 
Makefile: 
out: 
packages: 
pdk: 
platform_testing: 
prebuilts: 
sdk: 
system: 
test: 
toolchain: 
tools: 
vendor

