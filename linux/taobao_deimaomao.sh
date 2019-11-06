#!/bin/bash


# 华为p20, 淘宝赢猫币脚本
for (( i=0; i<24; i++ ))
do
	yc=`expr 1383 + $i % 3 \* 200`
	adb shell input tap 890 $yc
    sleep 3
	adb shell input swipe 10 500 10 10 200
	sleep 3
	adb shell input swipe 10 500 10 10 200
    sleep 17
    adb shell input keyevent 4
    sleep 2
done

yc=`expr 1183 + 4 \* 200`
for (( i=1; i<=20; i++))
do
    adb shell input tap 890 $yc
    sleep 3
	adb shell input swipe 10 500 10 10 200
	sleep 3
	adb shell input swipe 10 500 10 10 200
    sleep 17
    adb shell input keyevent 4
    sleep 2
    
done
