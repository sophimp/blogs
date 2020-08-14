#!/bin/bash


# 华为p20, 淘宝赢猫币脚本
yo=`expr 1360 + 3 \* 200`
for (( i=0; i<16; i++ ))
do
	fac=`expr $i % 3`
	echo $fac
	yc=`expr  $yo + $fac \* 200`
	adb shell input tap 894 $yc
    sleep 3
	#adb shell input swipe 10 500 10 10 200
	#sleep 3
	adb shell input swipe 10 500 10 10 200
    sleep 17
    adb shell input keyevent 4
    sleep 2
done

yc=`expr 1360 + 1 \* 200`
for (( i=1; i<=12; i++))
do
    adb shell input tap 890 $yc
    sleep 3
	#adb shell input swipe 10 500 10 10 200
	#sleep 3
	adb shell input swipe 10 500 10 10 200
    sleep 17
    adb shell input keyevent 4
    sleep 2
    
done
