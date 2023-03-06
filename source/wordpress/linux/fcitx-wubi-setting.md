---
title: fcitx 五笔字库单字上屏
uuid: 291
status: publish
date: 2020-02-19 21:46:01
tags: Fcitx, 五笔
categories: Linux
description: fcitx 五笔字库删减掉词组, 适合单一字上屏的习惯。 
---

### fcitx 五笔输入法配置

	支持生僻字库， 安装 fcitx-wubi-large

	然后在fcitx-configtool 里， 选择 五笔(large) 输入法
	
安装完fcitx-wubi-large字库后， 打出来的字首选字多好多词组，现将其改成单字库
参考 [配置fcitx单字库)(https://www.cnblogs.com/quantumman/p/10633531.html)

    1. 使用apt-get安装fcitx-tools。其中包含了需要用到的mb2txt与txt2mb命令，用于在二进制格式的码表与文本格式之间做转换。

    使用mb2txt将五笔输入法的码表转为文本格式：

     $ mb2txt /usr/share/fcitx/table/wbx.mb > wbx.txt
	 
    由此得到的wbx.txt文件包含如下内容：

     ;fcitx Version 0x03 Table file
     KeyCode=abcdefghijklmnopqrstuvwxy
     Length=4
     Pinyin=@
     PinyinLength=4
     Prompt=&
     ConstructPhrase=^
     [Rule]
     e2=p11+p12+p21+p22
     e3=p11+p21+p31+p32
     a4=p11+p21+p31+n11
     [Data]
     a 工
     a 戈
     a 或
     a 其
     aa 式
     aa 戒
     aaa 工
     aaaa 工
     aaaa 恭恭敬敬
     aaad 工期
     aaae 黄花菜
     aaae 黄芽菜
     ...

    可以看出，[Data]域之后就是输入法的每一个字母序列与对应的字词。

    编写如下的Awk脚本wbx.awk，用于删除wbx.txt中的所有词汇并保留其它内容：

     {
       if ($0 ~ /^\S+\s+\S+$/) {
         if (length($2) == 1) print $0
       }
       else print $0
     }

    执行gawk命令，将wbx.txt中的词汇删除并保存为新的文件：

     $ gawk -f wbx.awk wbx.txt > wbx-single-chars.txt

    使用txt2mb，将生成的wbx-single-chars.txt文件编译为二进制格式的码表：

     $ txt2mb wbx-single-chars.txt wbx-single-chars.mb

    将生成的wbx-single-chars.mb五笔单字码表覆盖/usr/share/fcitx/table/wbx.mb，wubi-large.mb, 还有 ~/.config/fcitx/tables/*.mb 文件, 然后重启Fcitx即可。

### 更高的需求

字库中还有一些乱码的方块字符没有去掉， 盲文也可以去掉。 

既然字库可以定制， 那么打不出来的汉字， 当然也可以完善字库， 所以，随着自己的习惯， 积累一份够自己用的字库， 是完全没有问题的。 
