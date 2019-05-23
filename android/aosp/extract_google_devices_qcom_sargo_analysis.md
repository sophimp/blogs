
##  谷歌下载的官方驱动脚本都做了些什么 

    `extract-google_devices-sargo.sh` 和 `extract-qcom-sargo.sh` 都是脚本语言, linux的脚本语言还未系统学习过

直接上代码分析, 语法总结放在 [linux的脚本语言学习总结](../../linux/linus_shell_script.md)

## extract-google_devices_sargo.sh

```shell
# license argument

if test $? != 0
 then
   echo ERROR: Couldn\'t display license file 1>&2
   exit 1
 fi
 
 echo
 
 echo -n Type \"I ACCEPT\" if you agree to the terms of the license:\ 
 read typed
 
 if test "$typed" != I\ ACCEPT
 then
   echo
   echo You didn\'t accept the license. Extraction aborted.
   exit 2
 fi
 
 echo
 
 tail -n +315 $0 | tar zxv
 
 if test $? != 0
 then
echo
   echo ERROR: Couldn\'t extract files. 1>&2
   exit 3
 else
   echo
   echo Files extracted successfully.
 fi
 exit 0
  
# 加密内容
```

## extract-qcom-sargo.sh

```shell
# license argument

if test $? != 0                                                                                   
 then                                                                                              
   echo ERROR: Couldn\'t display license file 1>&2                                                 
   exit 1                                                                                          
 fi                                                                                                
                                                                                                   
 echo                                                                                              
                                                                                                   
 echo -n Type \"I ACCEPT\" if you agree to the terms of the license:\                              
 read typed                                                                                        
                                                                                                   
 if test "$typed" != I\ ACCEPT                                                                     
 then                                                                                              
   echo                                                                                            
   echo You didn\'t accept the license. Extraction aborted.                                        
   exit 2                                                                                          
 fi                                                                                                
                                                                                                   
 echo                                                                                              
                                                                                                   
 tail -n +315 $0 | tar zxv                                                                         
                                                                                                   
 if test $? != 0 
 then                                                                                              
   echo                                                                                            
   echo ERROR: Couldn\'t extract files. 1>&2                                                       
   exit 3
 else
   echo
   echo Files extracted successfully.
 fi
 exit 0

 # 加密内容
```
